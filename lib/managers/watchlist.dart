import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/models/watchlist_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/service/braze/service.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/ui/tabs/tools/market/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class WatchListManagers extends ChangeNotifier {
  WatchRes? _data;
  WatchRes? get watchData => _data;
  String? _error;
  Status _status = Status.ideal;
  int _page = 1;

  bool get canLoadMore => _page < (_data?.totalPages ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;

  Extra? _extra;
  Extra? get extra => _extra;

  // int? get page => _page;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future onRefresh() async {
    _page = 1;
    getWatchList();
  }

  Future getWatchList({showProgress = false, loadMore = false}) async {
    if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _page = 1;
      setStatus(Status.loading);
    }
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {"token": provider.user?.token ?? "", "page": "$_page"};
      ApiResponse response = await apiRequest(
        url: Apis.watchlist,
        request: request,
        showProgress: showProgress,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = watchListResFromMap(jsonEncode(response.data));
        } else {
          _data?.watches?.addAll(
              watchListResFromMap(jsonEncode(response.data)).watches ?? []);
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      setStatus(Status.loaded);
    }
  }

  Future deleteItem(String symbol) async {
    setStatus(Status.loading);
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {"token": provider.user?.token ?? "", "symbol": symbol};

      ApiResponse response = await apiRequest(
        url: Apis.deleteWatchlist,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );

      if (response.status) {
        BrazeService.eventADWatchlist(symbol: symbol, add: false);

        getWatchList(showProgress: false);
        Navigator.pop(navigatorKey.currentContext!);
      } else {
        _error = response.message;
      }
      TopSnackbar.show(
        message: response.message ?? '',
        type: response.status ? ToasterEnum.success : ToasterEnum.error,
      );
      setStatus(Status.loaded);
    } catch (e) {
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  void redirectToMarket() {
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    // Navigator.pushNamed(navigatorKey.currentContext!, Tabs.path, arguments: {
    //   'index': 2,
    // });
    Navigator.pushNamed(navigatorKey.currentContext!, MarketIndex.path);
  }
}

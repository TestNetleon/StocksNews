import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/gap_up_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';

import '../modals/penny_stocks.dart';

class PennyStocksProvider extends ChangeNotifier with AuthProviderBase {
  int _openIndex = -1;
  int? get openIndex => _openIndex;

  Status _status = Status.ideal;
  // ************* Most Active **************** //
  List<PennyStocksRes>? _data;
  String? _error;
  int _page = 1;

  List<PennyStocksRes>? get data => _data;
  bool get canLoadMore => _page < (extra?.totalPages ?? 0);
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading;
  Extra? _extraData;
  Extra? get extra => _extraData;

  // ************* GAP DOWN **************** //
  List<GapUpRes>? _dataDown;
  String? _errorDown;
  // int _pageDown = 1;

  List<GapUpRes>? get dataDown => _dataDown;
  // bool get canLoadMoreDown => _pageDown < (0 ?? 1);
  String? get errorDown => _errorDown ?? Const.errSomethingWrong;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }
  // void setStatusLosers(status) {
  //   _status = status;
  //   notifyListeners();
  // }
  // void setOpenIndex(index) {
  //   // _openIndex = index;
  //   notifyListeners();
  // }
  // void setOpenIndexLosers(index) {
  //   // _openIndexLosers = index;
  //   notifyListeners();
  // }

  Future getData({showProgress = false, loadMore = false}) async {
    if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _openIndex = -1;
      _page = 1;
      setStatus(Status.loading);
    }
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "page": "$_page"
      };

      ApiResponse response = await apiRequest(
        url: Apis.mostActivePenny,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _extraData = response.extra;
        _error = null;
        if (_page == 1) {
          _data = pennyStocksResFromJson(jsonEncode(response.data));
        } else {
          _data?.addAll(pennyStocksResFromJson(jsonEncode(response.data)));
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
          // showErrorMessage(message: response.message);
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      log(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future logoutUser(request) async {
    try {
      ApiResponse res = await apiRequest(
        url: Apis.logout,
        request: request,
      );
      if (res.status) {
        setStatus(Status.loaded);
        handleSessionOut();
        showErrorMessage(message: res.message, type: SnackbarType.info);
      } else {
        setStatus(Status.loaded);
        showErrorMessage(
          message: res.message,
        );
      }
    } catch (e) {
      setStatus(Status.loaded);
      showErrorMessage(
        message: kDebugMode ? e.toString() : Const.errSomethingWrong,
      );
    }
  }
}

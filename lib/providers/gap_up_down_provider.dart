import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/gainers_losers_res.dart';
import 'package:stocks_news_new/modals/more_stocks_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';

class GapUpDownProvider extends ChangeNotifier with AuthProviderBase {
  GainersLosersRes? _gainersLosers;
  GainersLosersRes? get gainersLosers => _gainersLosers;

  Status _status = Status.ideal;
  Status get status => _status;

  int _pageUp = 1;
  int _openIndex = -1;

  List<MoreStocksRes>? _data;
  List<MoreStocksRes>? get data => _data;

  bool get isLoading => _status == Status.loading;
  bool get canLoadMore => _pageUp < (_gainersLosers?.lastPage ?? 1);

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  int get openIndex => _openIndex;

  GainersLosersRes? _losers;
  GainersLosersRes? get losers => _losers;

  Status _statusLosers = Status.ideal;
  Status get statusLosers => _statusLosers;

  int _pageDown = 1;
  int _openIndexLosers = -1;

  List<MoreStocksRes>? _dataLosers;
  List<MoreStocksRes>? get dataLosers => _dataLosers;

  bool get isLoadingLosers => _statusLosers == Status.loading;
  bool get canLoadMoreLosers => _pageDown < (_losers?.lastPage ?? 1);

  String? _errorLosers;
  String? get errorLosers => _errorLosers ?? Const.errSomethingWrong;

  int get openIndexLosers => _openIndexLosers;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStatusLosers(status) {
    _statusLosers = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  void setOpenIndexLosers(index) {
    _openIndexLosers = index;
    notifyListeners();
  }

  Future getGapDownStocks({showProgress = false, loadMore = false}) async {
    _openIndexLosers = -1;
    if (loadMore) {
      _pageDown++;
      setStatusLosers(Status.loadingMore);
    } else {
      _pageDown = 1;
      setStatusLosers(Status.loading);
    }

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "type": "down",
        "page": "$_pageDown",
      };

      ApiResponse response = await apiRequest(
        url: Apis.gainerLoser,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _errorLosers = null;
        if (_pageDown == 1) {
          _losers = gainersLosersResFromJson(jsonEncode(response.data));
        } else {
          _losers?.data
              ?.addAll(GainersLosersRes.fromJson(response.data).data ?? []);
        }
      } else {
        if (_pageDown == 1) {
          _errorLosers = response.message;
          _losers = null;
        }
      }
      setStatusLosers(Status.loaded);
    } catch (e) {
      _losers = null;
      _errorLosers = Const.errSomethingWrong;
      log(e.toString());
      setStatusLosers(Status.loaded);
    }
  }

  Future getGapUpStocks({showProgress = false, loadMore = false}) async {
    _openIndex = -1;
    if (loadMore) {
      _pageUp++;
      setStatus(Status.loadingMore);
    } else {
      _pageUp = 1;
      setStatus(Status.loading);
    }

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "type": "up",
        "page": "$_pageUp",
      };

      ApiResponse response = await apiRequest(
        url: Apis.gainerLoser,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _error = null;
        if (_pageUp == 1) {
          _gainersLosers = gainersLosersResFromJson(jsonEncode(response.data));
        } else {
          _gainersLosers?.data
              ?.addAll(GainersLosersRes.fromJson(response.data).data ?? []);
        }
      } else {
        if (_pageUp == 1) {
          _error = response.message;
          _gainersLosers = null;
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _gainersLosers = null;
      _error = Const.errSomethingWrong;
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

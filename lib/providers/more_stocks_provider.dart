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

class MoreStocksProvider extends ChangeNotifier with AuthProviderBase {
  GainersLosersRes? _gainersLosers;
  GainersLosersRes? get gainersLosers => _gainersLosers;

  Status _status = Status.ideal;
  Status get status => _status;

  int _page = 1;
  int _openIndex = -1;

  List<MoreStocksRes>? _data;
  List<MoreStocksRes>? get data => _data;

  bool get isLoading => _status == Status.loading;
  bool get canLoadMore => _page < (_gainersLosers?.lastPage ?? 1);

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  int get openIndex => _openIndex;

  GainersLosersRes? _losers;
  GainersLosersRes? get losers => _losers;

  Status _statusLosers = Status.ideal;
  Status get statusLosers => _statusLosers;

  int _pageLosers = 1;
  int _openIndexLosers = -1;

  List<MoreStocksRes>? _dataLosers;
  List<MoreStocksRes>? get dataLosers => _dataLosers;

  bool get isLoadingLosers => _statusLosers == Status.loading;
  bool get canLoadMoreLosers => _pageLosers < (_losers?.lastPage ?? 1);

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

  // Future getData(
  //     {showProgress = false, loadMore = false, required String type}) async {
  //   // if (loadMore) {
  //   //   _page++;
  //   //   setStatus(Status.loadingMore);
  //   // } else {
  //   //   _page = 1;
  //   //   setStatus(Status.loading);
  //   // }
  //   setStatus(Status.loading);

  //   try {
  //     Map request = {
  //       "token":
  //           navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
  //       "type": type
  //     };

  //     ApiResponse response = await apiRequest(
  //       url: Apis.moreStocks,
  //       request: request,
  //       showProgress: showProgress,
  //     );

  //     if (response.status) {
  //       _error = null;
  //       // if (_page == 1) {
  //       _data = moreStocksResFromJson(jsonEncode(response.data));
  //       if (_data!.isEmpty) {
  //         _error = "Data not available";
  //       }
  //       // } else {
  //       //   _data?.data.addAll(WatchlistRes.fromJson(response.data).data);
  //       // }
  //     } else {
  //       // if (_page == 1) {
  //       //   _data = null;
  //       // }
  //       _data = null;
  //       _error = response.message;
  //       showErrorMessage(message: response.message);
  //     }
  //     setStatus(Status.loaded);
  //   } catch (e) {
  //     _data = null;

  //     log(e.toString());
  //     setStatus(Status.loaded);
  //   }
  // }

  Future getLosers({
    showProgress = false,
    loadMore = false,
    required String type,
  }) async {
    _openIndexLosers = -1;
    if (loadMore) {
      _pageLosers++;
      setStatusLosers(Status.loadingMore);
    } else {
      _pageLosers = 1;
      setStatusLosers(Status.loading);
    }

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "type": type,
        "page": "$_pageLosers",
      };

      ApiResponse response = await apiRequest(
        url: Apis.gainerLoser,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _errorLosers = null;
        if (_pageLosers == 1) {
          _losers = gainersLosersResFromJson(jsonEncode(response.data));
        } else {
          _losers?.data
              ?.addAll(GainersLosersRes.fromJson(response.data).data ?? []);
        }
      } else {
        if (_pageLosers == 1) {
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

  Future getGainersLosers(
      {showProgress = false, loadMore = false, required String type}) async {
    _openIndex = -1;
    if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _page = 1;
      setStatus(Status.loading);
    }

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "type": type,
        "page": "$_page",
      };

      ApiResponse response = await apiRequest(
        url: Apis.gainerLoser,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _gainersLosers = gainersLosersResFromJson(jsonEncode(response.data));
        } else {
          _gainersLosers?.data
              ?.addAll(GainersLosersRes.fromJson(response.data).data ?? []);
        }
      } else {
        if (_page == 1) {
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
        showProgress: true,
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

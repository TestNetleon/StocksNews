import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/breakout_stocks_res.dart';
import 'package:stocks_news_new/modals/gainers_losers_res.dart';
import 'package:stocks_news_new/modals/more_stocks_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';

class MoreStocksProvider extends ChangeNotifier {
  GainersLosersRes? _gainersLosers;
  GainersLosersRes? get gainersLosers => _gainersLosers;

  Status _status = Status.ideal;
  Status get status => _status;

  int _page = 1;
  int _openIndex = -1;

  List<MoreStocksRes>? _data;
  List<MoreStocksRes>? get data => _data;

  List<BreakoutStocksRes>? _dataBreakoutStocks;
  List<BreakoutStocksRes>? get dataBreakoutStocks => _dataBreakoutStocks;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  bool get canLoadMore => _page < (_gainersLosers?.lastPage ?? 1);

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;
  String? _errorBreakoutStocks;
  String? get errorBreakoutStocks =>
      _errorBreakoutStocks ?? Const.errSomethingWrong;

  int get openIndex => _openIndex;

  GainersLosersRes? _losers;
  GainersLosersRes? get losers => _losers;

  Status _statusLosers = Status.ideal;
  Status get statusLosers => _statusLosers;

  int _pageLosers = 1;
  int _pageBreakOut = 1;

  int _openIndexLosers = -1;

  List<MoreStocksRes>? _dataLosers;
  List<MoreStocksRes>? get dataLosers => _dataLosers;
  bool get isLoadingBreakOut => _statusLosers == Status.loading;
  bool get canLoadMoreBreakOut =>
      _pageBreakOut < (_extraBreakOutStocks?.totalPages ?? 1);

  bool get isLoadingLosers => _statusLosers == Status.loading;
  bool get canLoadMoreLosers => _pageLosers < (_losers?.lastPage ?? 1);

  String? _errorLosers;
  String? get errorLosers => _errorLosers ?? Const.errSomethingWrong;

  int get openIndexLosers => _openIndexLosers;
  Extra? _extraUpGainers;
  Extra? get extraUpGainers => _extraUpGainers;
  Extra? _extraBreakOutStocks;
  Extra? get extraBreakOutStocks => _extraBreakOutStocks;
  Extra? _extraUpLosers;
  Extra? get extraUpLosers => _extraUpLosers;

  final AudioPlayer _player = AudioPlayer();

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

  Future createAlertSend({
    required String alertName,
    required String symbol,
    required int index,
    bool selectedOne = false,
    bool selectedTwo = false,
    type,
  }) async {
    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "symbol": symbol,
      "alert_name": alertName,
      "sentiment_spike": selectedOne ? "yes" : "no",
      "mention_spike": selectedTwo ? "yes" : "no",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.createAlert,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (response.status) {
        if (type == StocksType.gainers) {
          _gainersLosers?.data?[index].isAlertAdded = 1;

          notifyListeners();
        } else if (type == StocksType.losers) {
          _gainersLosers?.data?[index].isAlertAdded = 1;
          notifyListeners();
        } else if (type == StocksType.actives) {
          _gainersLosers?.data?[index].isAlertAdded = 1;
        }

        _extraUpGainers = response.extra is Extra ? response.extra : null;
        await _player.play(AssetSource(AudioFiles.alertWeathlist));

        navigatorKey.currentContext!
            .read<HomeProvider>()
            .setTotalsAlerts(response.data['total_alerts']);
        notifyListeners();
      }
      Navigator.pop(navigatorKey.currentContext!);
      Navigator.pop(navigatorKey.currentContext!);

      showErrorMessage(
          message: response.message,
          type: response.status ? SnackbarType.info : SnackbarType.error);

      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog(e.toString());
      // showErrorMessage(message: Const.errSomethingWrong);
    }
  }

  Future addToWishList({
    required String symbol,
    required bool up,
    required int index,
    type,
  }) async {
    showGlobalProgressDialog();

    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "symbol": symbol
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.addWatchlist,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (response.status) {
        //

        _gainersLosers?.data?[index].isWatchlistAdded = 1;
        notifyListeners();

        await _player.play(AssetSource(AudioFiles.alertWeathlist));

        navigatorKey.currentContext!
            .read<HomeProvider>()
            .setTotalsWatchList(response.data['total_watchlist']);
      }
      showErrorMessage(
          message: response.message,
          type: response.status ? SnackbarType.info : SnackbarType.error);

      closeGlobalProgressDialog();
      return ApiResponse(status: response.status);
    } catch (e) {
      closeGlobalProgressDialog();

      Utils().showLog(e.toString());
      // showErrorMessage(message: Const.errSomethingWrong);
    }
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

  //     Utils().showLog(e.toString());
  //     setStatus(Status.loaded);
  //   }
  // }

  Future getBreakoutStocks({showProgress = false, loadMore = false}) async {
    _openIndex = -1;
    if (loadMore) {
      _pageBreakOut++;
      setStatusLosers(Status.loadingMore);
    } else {
      _extraBreakOutStocks = null;

      _pageBreakOut = 1;
      setStatusLosers(Status.loading);
    }

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "page": "$_pageBreakOut",
      };

      ApiResponse response = await apiRequest(
        url: Apis.breakoutStocks,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _errorBreakoutStocks = null;
        if (_pageBreakOut == 1) {
          _dataBreakoutStocks =
              breakoutStocksResFromJson(jsonEncode(response.data));
          _extraBreakOutStocks =
              response.extra is Extra ? response.extra : null;
        } else {
          _dataBreakoutStocks
              ?.addAll(breakoutStocksResFromJson(jsonEncode(response.data)));
        }
      } else {
        if (_pageBreakOut == 1) {
          _errorBreakoutStocks = response.message;
          _dataBreakoutStocks = null;
        }
      }
      setStatusLosers(Status.loaded);
    } catch (e) {
      _dataBreakoutStocks = null;
      _errorBreakoutStocks = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatusLosers(Status.loaded);
    }
  }

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
      _extraUpLosers = null;
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
          _extraUpLosers = response.extra is Extra ? response.extra : null;
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
      Utils().showLog(e.toString());
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
      _extraUpGainers = null;
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
          _extraUpGainers = response.extra is Extra ? response.extra : null;
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
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}

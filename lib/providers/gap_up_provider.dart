import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/gap_up_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../service/braze/service.dart';

class GapUpProvider extends ChangeNotifier {
  int _openIndex = -1;
  int? get openIndex => _openIndex;

  // ************* GAP Up **************** //
  Status _status = Status.ideal;
  List<GapUpRes>? _data;
  String? _error;
  int _page = 1;
  bool get canLoadMore => _page < (_extra?.totalPages ?? 1);
  Extra? _extra;
  Extra? get extra => _extra;

  List<GapUpRes>? get data => _data;
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  FilteredParams? _filterParams;
  FilteredParams? get filterParams => _filterParams;

  final AudioPlayer _player = AudioPlayer();

  bool _intSlidableActive = false;
  bool get intSlidableActive => _intSlidableActive;

  void setIntSlidableActive(val) {
    _intSlidableActive = val;
    notifyListeners();
  }

  Future createAlertSend({
    required String alertName,
    required String symbol,
    required String companyName,
    required int index,
    bool selectedOne = false,
    bool selectedTwo = false,
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
        // AmplitudeService.logAlertUpdateEvent(
        //   added: true,
        //   symbol: symbol,
        //   companyName: companyName,
        // );
        BrazeService.eventADAlert(symbol: symbol);

        _data?[index].isAlertAdded = 1;
        notifyListeners();

        _extra = (response.extra is Extra ? response.extra as Extra : null);
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
    required String companyName,
    required bool up,
    required int index,
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
        _data?[index].isWatchlistAdded = 1;
        notifyListeners();
        // AmplitudeService.logWatchlistUpdateEvent(
        //   added: true,
        //   symbol: symbol,
        //   companyName: companyName,
        // );
        // _homeTrendingRes?.trending[index].isWatchlistAdded = 1;
        BrazeService.eventADWatchlist(symbol: symbol);

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

  bool isFilterApplied() {
    if (filterParams != null &&
        (filterParams?.exchange_name != null ||
            filterParams?.sector != null ||
            filterParams?.industry != null ||
            filterParams?.price != "" ||
            filterParams?.market_cap != null ||
            filterParams?.beta != "" ||
            filterParams?.marketRanks != null ||
            filterParams?.analystConsensusParams != null ||
            filterParams?.dividend != "" ||
            filterParams?.isEtf != "" ||
            filterParams?.isFund != "" ||
            filterParams?.isActivelyTrading != "")) {
      return true;
    }
    return false;
  }

  bool isSortingApplied() {
    if (filterParams != null && filterParams?.sorting != "") {
      return true;
    }
    return false;
  }

  void resetFilter() {
    _filterParams = null;
    _page = 1;
    notifyListeners();
  }

  void applyFilter(FilteredParams? params) {
    _filterParams = params;
    _page = 1;
    notifyListeners();
    getGapUpStocks();
  }

  void applySorting(String sortingKey) {
    if (_filterParams == null) {
      _filterParams = FilteredParams(sorting: sortingKey);
    } else {
      _filterParams!.sorting = sortingKey;
    }
    _page = 1;
    notifyListeners();
    Utils()
        .showLog("Sorting Data ===   $sortingKey   ${_filterParams?.sorting}");
    getGapUpStocks();
  }

  // void exchangeFilter(String item) {
  //   _filterParams!.exchange_name!.remove(item);
  //   if (_filterParams!.exchange_name!.isEmpty) {
  //     _filterParams!.exchange_name = null;
  //   }
  //   _page = 1;
  //   notifyListeners();
  //   getGapUpStocks();
  // }

  // void sectorFilter(String item) {
  //   _filterParams!.sector!.remove(item);
  //   if (_filterParams!.sector!.isEmpty) {
  //     _filterParams!.sector = null;
  //   }
  //   _page = 1;

  //   notifyListeners();
  //   getGapUpStocks();
  // }

  // void industryFilter(String item) {
  //   _filterParams!.industry!.remove(item);
  //   if (_filterParams!.industry!.isEmpty) {
  //     _filterParams!.industry = null;
  //   }
  //   _page = 1;
  //   notifyListeners();
  //   getGapUpStocks();
  // }

  void setStatusUp(status) {
    _status = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  Future onRefreshGapUp() async {
    getGapUpStocks();
  }

  Future getGapUpStocks({loadMore = false}) async {
    if (loadMore) {
      _page++;
      setStatusUp(Status.loadingMore);
    } else {
      _page = 1;
      setStatusUp(Status.loading);
    }
    _openIndex = -1;
    // _extraDown = null;
    // _extraUp = null;

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "page": "$_page",
        "exchange_name": _filterParams?.exchange_name?.key ?? "",
        "price": _filterParams?.price ?? "",
        "industry": _filterParams?.industry?.key ?? "",
        "market_cap": _filterParams?.market_cap?.key ?? "",
        "beta": _filterParams?.beta ?? "",
        "dividend": _filterParams?.dividend ?? "",
        "isEtf": _filterParams?.isEtf ?? "",
        "isFund": _filterParams?.isFund ?? "",
        "isActivelyTrading": _filterParams?.isActivelyTrading ?? "",
        "sector": _filterParams?.sector?.key ?? "",
        "sortBy": _filterParams?.sorting ?? "",
        "marketRank": _filterParams?.marketRanks?.key ?? "",
        "analystConsensus": _filterParams?.analystConsensusParams?.key ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.gapUpStocks,
        request: request,
        showProgress: false,
        onRefresh: onRefreshGapUp,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = gapUpResFromJson(jsonEncode(response.data));
          _extra = response.extra is Extra ? response.extra : null;
          setIntSlidableActive(true);
        } else {
          _data?.addAll(gapUpResFromJson(jsonEncode(response.data)));
        }
      } else {
        setIntSlidableActive(false);
        if (_page == 1) {
          _data = null;
          _error = response.message;
          // showErrorMessage(message: response.message);
        }
      }
      setStatusUp(Status.loaded);
    } catch (e) {
      _data = null;
      Utils().showLog(e.toString());
      setStatusUp(Status.loaded);
    }
  }
}

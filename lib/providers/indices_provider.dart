import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/dow_thirty_res.dart';
import 'package:stocks_news_new/modals/indices_res.dart';
import 'package:stocks_news_new/modals/low_price_stocks_tab.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';

class IndicesProvider extends ChangeNotifier {
  String? _error;
  Status _status = Status.ideal;
  Status _tabStatus = Status.ideal;
  int selectedIndex = 0;

  List<LowPriceStocksTabRes>? _tabs;

  List<LowPriceStocksTabRes>? get tabs => _tabs;

  List<IndicesRes>? _data;
  List<IndicesRes>? get data => _data;
  List<Result>? _dataDowThirtyStocks;
  List<Result>? get dataDowThirtyStocks => _dataDowThirtyStocks;

  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  bool get tabLoading => _tabStatus == Status.loading;
  bool get canLoadMore => _page < (_extra?.totalPages ?? 1);
  int _page = 1;
  Extra? _extra;
  Extra? get extra => _extra;

  String? title;
  String? subTitle;
  int _openIndexIndices = -1;
  int get openIndexIndices => _openIndexIndices;
  int _openIndex = -1;
  int get openIndex => _openIndex;
  bool _typeDowThirty = false;
  bool get typeDowThirty => _typeDowThirty;
  bool _typeSpFifty = false;
  bool get typeSpFifty => _typeSpFifty;

  final AudioPlayer _player = AudioPlayer();

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

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setData() {
    _data = null;
    notifyListeners();
  }

  void setTabStatus(status) {
    _tabStatus = status;
    notifyListeners();
  }

  void setOpenIndexIndices(index) {
    _openIndexIndices = index;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  void tabChange(index) {
    if (selectedIndex != index) {
      selectedIndex = index - 2;
      _filterParams = null;
      notifyListeners();
      getIndicesData(showProgress: false);
    }
  }

//----------Filter ------------------

  FilteredParams? _filterParams;
  FilteredParams? get filterParams => _filterParams;

  bool isFilterApplied() {
    if (filterParams != null &&
        (filterParams?.exchange_name != null ||
            filterParams?.sector != null ||
            filterParams?.industry != null ||
            filterParams?.price != "" ||
            filterParams?.market_cap != null ||
            filterParams?.marketRanks != null ||
            filterParams?.analystConsensusParams != null ||
            filterParams?.beta != "" ||
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
    getIndicesData();
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
    getIndicesData();
  }

  // void exchangeFilter(String item) {
  //   _filterParams!.exchange_name!.remove(item);
  //   if (_filterParams!.exchange_name!.isEmpty) {
  //     _filterParams!.exchange_name = null;
  //   }
  //   _page = 1;
  //   notifyListeners();
  //   getIndicesData();
  // }

//----------Filter ------------------
  Future onRefresh() async {
    getTabsData();
  }

  Future getTabsData({showProgress = false}) async {
    _tabs == null;

    setTabStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.exchanageTab,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
        removeForceLogin: true,
      );

      if (response.status) {
        _tabs = lowPriceStocksTabResFromJson(jsonEncode(response.data));
        if (_tabs != null) {
          getIndicesData();
        }
      } else {
        _error = response.message;
        _tabs = null;
        // showErrorMessage(message: response.message);
      }
      setTabStatus(Status.loaded);
    } catch (e) {
      _error = Const.errSomethingWrong;
      _tabs = null;

      Utils().showLog(e.toString());
      setTabStatus(Status.loaded);
    }
  }

  Future onRefreshIndicesData() async {
    getTabsData();
  }

  Future getIndicesData(
      {loadMore = false,
      showProgress = false,
      dowThirtyStocks = false,
      sPFiftyStocks = false}) async {
    setStatus(Status.loading);
    if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _page = 1;
      setStatus(Status.loading);
    }
    if (dowThirtyStocks == true) {
      _typeSpFifty = false;

      _typeDowThirty = true;
    } else if (sPFiftyStocks == true) {
      _typeDowThirty = false;
      _typeSpFifty = true;
    } else {
      _typeSpFifty = false;
      _typeDowThirty = false;
    }
    notifyListeners();

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "page": "$_page",
        "exchange": _tabs?[selectedIndex].value,
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
        "marketRank": _filterParams?.marketRanks?.key ?? "",
        "analystConsensus": _filterParams?.analystConsensusParams?.key ?? "",
      };
      // Map requestDowThirty = {
      //   "token":
      //       navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      //   "page": "$_page"
      // };
      // Map requestSPFifty = {
      //   "token":
      //       navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      //   "page": "$_page"
      // };

      ApiResponse response = await apiRequest(
        url:
            // dowThirtyStocks == true
            //     ? Apis.dowThirty
            //     : sPFiftyStocks == true
            //         ? Apis.spFifty
            //         :
            Apis.indices,
        request:
            // dowThirtyStocks
            //     ? requestDowThirty
            //     : sPFiftyStocks
            //         ? requestSPFifty
            //         :
            request,
        showProgress: false,
        onRefresh: onRefreshIndicesData,
        removeForceLogin: true,
      );
      if (response.status) {
        // if (_tabs?[selectedIndex].key != null &&
        //     _tabs?[selectedIndex].key != '') {
        //   AmplitudeService.logUserInteractionEvent(
        //       type: _tabs?[selectedIndex].key ?? '');
        // }

        _extra = response.extra is Extra ? response.extra : null;
        notifyListeners();

        // _extraUp = response.extra;
        // notifyListeners();
        // title = response.extra?.title;
        // subTitle = response.extra?.subTitle;
        _error = null;
        if (_page == 1) {
          if (dowThirtyStocks == true) {
            _dataDowThirtyStocks =
                dowThirtyResFromJson(jsonEncode(response.data));
          } else if (sPFiftyStocks == true) {
            _dataDowThirtyStocks =
                dowThirtyResFromJson(jsonEncode(response.data));
          } else {
            _data = indicesResFromJson(jsonEncode(response.data));
            Utils().showLog("----------${_data?.length}");
          }

          // _data =  indicesResFromJson(jsonEncode(response.data));
        } else {
          if (dowThirtyStocks == true) {
            _dataDowThirtyStocks
                ?.addAll(dowThirtyResFromJson(jsonEncode(response.data)));
          } else if (sPFiftyStocks == true) {
            _dataDowThirtyStocks
                ?.addAll(dowThirtyResFromJson(jsonEncode(response.data)));
          } else {
            _data?.addAll(indicesResFromJson(jsonEncode(response.data)));
            Utils().showLog("----------${_data?.length}");
          }

          // _data?.addAll(indicesResFromJson(jsonEncode(response.data)));
        }

        notifyListeners();
      } else {
        if (_page == 1) {
          _data = null;
          _dataDowThirtyStocks = null;
          _error = response.message;
          // showErrorMessage(message: response.message);
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      Utils().showLog(e.toString());

      setStatus(Status.loaded);
    }
  }
}

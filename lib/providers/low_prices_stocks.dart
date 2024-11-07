import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/low_price_stocks_tab.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../modals/low_price_stocks_res.dart';
import '../service/amplitude/service.dart';

class LowPriceStocksProvider extends ChangeNotifier {
  String? _error;
  Status _status = Status.ideal;
  Status _tabStatus = Status.ideal;
  // int _selectedIndex = 0;
  int _typeIndex = 0;
  int get typeIndex => _typeIndex;

  List<LowPriceStocksTabRes>? _tabs;
  List<LowPriceStocksTabRes>? get tabs => _tabs;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(index) => _selectedIndex = index;

  List<LowPriceStocksRes>? _data;
  List<LowPriceStocksRes>? get data => _data;

  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  bool get tabLoading => _tabStatus == Status.loading;

  String? title;
  String? subTitle;
  bool get canLoadMore => _page < (_extra?.totalPages ?? 1);
  // bool get canLoadMoreDown => _pageDown < (_extraDown?.totalPages ?? 1);
  int _page = 1;
  // int _pageDown = 1;
  Extra? _extra;
  Extra? get extra => _extra;
  // Extra? _extraDown;

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
        AmplitudeService.logAlertUpdateEvent(
          added: true,
          symbol: symbol,
          companyName: companyName,
        );
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
        AmplitudeService.logWatchlistUpdateEvent(
          added: true,
          symbol: symbol,
          companyName: companyName,
        );
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

  void setStocksOnSaleData(status) {
    _status = status;
    notifyListeners();
  }

  void setTabStatus(status) {
    _tabStatus = status;
    notifyListeners();
  }

  void tabChange(index) {
    _filterParams = null;
    _extra = null;
    if (tabs?[index].key != null && tabs?[index].key != '') {
      AmplitudeService.logUserInteractionEvent(type: tabs?[index].key ?? '');
    }

    if (tabs?[index].key == "Stocks On Sale") {
      if (_selectedIndex != index) {
        _selectedIndex = index;
        notifyListeners();
        getLowPriceData(type: 1);
      }
      return;
    } else {
      if (_selectedIndex != index) {
        _selectedIndex = index;
        notifyListeners();
        getLowPriceData(type: 0);
      }
    }
  }

// --------- Filter ------------

  FilteredParams? _filterParams;
  FilteredParams? get filterParams => _filterParams;

  void resetFilter() {
    _filterParams = null;
    _page = 1;
    notifyListeners();
  }

  void applyFilter(FilteredParams? params) {
    _filterParams = params;
    _page = 1;
    notifyListeners();
    getLowPriceData();
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
    getLowPriceData();
  }

  // void exchangeFilter(String item) {
  //   _filterParams!.exchange_name!.remove(item);
  //   if (_filterParams!.exchange_name!.isEmpty) {
  //     _filterParams!.exchange_name = null;
  //   }
  //   _page = 1;
  //   notifyListeners();
  //   getLowPriceData();
  // }

  // void sectorFilter(String item) {
  //   _filterParams!.sector!.remove(item);
  //   if (_filterParams!.sector!.isEmpty) {
  //     _filterParams!.sector = null;
  //   }
  //   _page = 1;

  //   notifyListeners();
  //   getTabsData();
  // }

  // void industryFilter(String item) {
  //   _filterParams!.industry!.remove(item);
  //   if (_filterParams!.industry!.isEmpty) {
  //     _filterParams!.industry = null;
  //   }
  //   _page = 1;
  //   notifyListeners();
  //   getTabsData();
  // }

// ---------------------

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
        url: Apis.lowPricesTab,
        request: request,
        showProgress: showProgress,
        onRefresh: onRefresh,
        removeForceLogin: true,
      );
      if (response.status) {
        _tabs = lowPriceStocksTabResFromJson(jsonEncode(response.data));
        if (_tabs != null) {
          getLowPriceData(type: 0);
          AmplitudeService.logUserInteractionEvent(type: tabs?[0].key ?? '');
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

  // Future getLowPriceData({showProgress = false}) async {
  //   setStatus(Status.loading);

  //   try {
  //     Map request = {
  //       "token":
  //           navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
  //       "slug": _tabs?[selectedIndex].key,
  //     };

  //     ApiResponse response = await apiRequest(
  //       url: Apis.lowPricesStocks,
  //       request: request,
  //       showProgress: showProgress,
  //     );

  //     if (response.status) {
  //       _error = null;
  //       _data = lowPriceStocksResFromJson(jsonEncode(response.data));
  //       title = response.extra?.title;
  //       subTitle = response.extra?.subTitle;
  //     } else {
  //       _data = null;
  //       _error = response.message;
  //     }

  //     setStatus(Status.loaded);
  //   } catch (e) {
  //     _data = null;
  //     Utils().showLog(e.toString());

  //     setStatus(Status.loaded);
  //   }
  // }

  Future getLowPriceData({loadMore = false, type}) async {
    _typeIndex = type ?? typeIndex;
    notifyListeners();

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
        if (typeIndex == 0) "slug": _tabs?[selectedIndex].value,
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
        url: typeIndex == 1 ? Apis.saleOnStocks : Apis.lowPricesStocks,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = lowPriceStocksResFromJson(jsonEncode(response.data));
          _extra = response.extra is Extra ? response.extra : null;
          title = response.extra?.title;
          subTitle = response.extra?.subTitle;
        } else {
          _data?.addAll(lowPriceStocksResFromJson(jsonEncode(response.data)));
          notifyListeners();
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
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}

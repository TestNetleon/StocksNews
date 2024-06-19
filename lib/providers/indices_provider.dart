import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/dow_thirty_res.dart';
import 'package:stocks_news_new/modals/indices_res.dart';
import 'package:stocks_news_new/modals/low_price_stocks_tab.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
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
      // if (tabs?[index].key == "DOW30") {
      //   selectedIndex = index;
      //   notifyListeners();
      //   getIndicesData(showProgress: true, dowThirtyStocks: true);
      // } else if (tabs?[index].key == "SP500") {
      //   selectedIndex = index;
      //   notifyListeners();
      //   getIndicesData(showProgress: true, sPFiftyStocks: true);
      // } else {
      selectedIndex = index - 2;
      _filterParams = null;
      notifyListeners();
      getIndicesData(showProgress: false);
    }
    // }
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
            filterParams?.market_cap != "" ||
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

  void exchangeFilter(String item) {
    _filterParams!.exchange_name!.remove(item);
    if (_filterParams!.exchange_name!.isEmpty) {
      _filterParams!.exchange_name = null;
    }
    _page = 1;
    notifyListeners();
    getIndicesData();
  }

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
        "exchange_name": _filterParams?.exchange_name?.join(",") ?? "",
        "price": _filterParams?.price ?? "",
        "industry": _filterParams?.industry?.join(",") ?? "",
        "market_cap": _filterParams?.market_cap ?? "",
        "beta": _filterParams?.beta ?? "",
        "dividend": _filterParams?.dividend ?? "",
        "isEtf": _filterParams?.isEtf ?? "",
        "isFund": _filterParams?.isFund ?? "",
        "isActivelyTrading": _filterParams?.isActivelyTrading ?? "",
        "sector": _filterParams?.sector?.join(",") ?? "",
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
      );
      if (response.status) {
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

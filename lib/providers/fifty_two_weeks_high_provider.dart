import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/fifty_two_weeks_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class FiftyTwoWeeksHighProvider extends ChangeNotifier with AuthProviderBase {
  int _openIndex = -1;
  int? get openIndex => _openIndex;

  // ************* GAP Up **************** //
  Status _status = Status.ideal;
  List<FiftyTwoWeeksRes>? _data;
  String? _error;
  int _page = 1;
  Extra? _extra;

  List<FiftyTwoWeeksRes>? get data => _data;
  Extra? get extra => _extra;
  bool get canLoadMore => _page <= (_extra?.totalPages ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

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

  void resetFilter() {
    _filterParams = null;
    _page = 1;
    notifyListeners();
  }

  void applyFilter(FilteredParams? params) {
    _filterParams = params;
    _page = 1;
    notifyListeners();
    getFiftyTwoWeekHigh();
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
    getFiftyTwoWeekHigh();
  }

  // void exchangeFilter(String item) {
  //   _filterParams!.exchange_name!.remove(item);
  //   if (_filterParams!.exchange_name!.isEmpty) {
  //     _filterParams!.exchange_name = null;
  //   }
  //   _page = 1;
  //   notifyListeners();
  //   getFiftyTwoWeekHigh();
  // }

  // void sectorFilter(String item) {
  //   _filterParams!.sector!.remove(item);
  //   if (_filterParams!.sector!.isEmpty) {
  //     _filterParams!.sector = null;
  //   }
  //   _page = 1;

  //   notifyListeners();
  //   getFiftyTwoWeekHigh();
  // }

  // void industryFilter(String item) {
  //   _filterParams!.industry!.remove(item);
  //   if (_filterParams!.industry!.isEmpty) {
  //     _filterParams!.industry = null;
  //   }
  //   _page = 1;
  //   notifyListeners();
  //   getFiftyTwoWeekHigh();
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
    getFiftyTwoWeekHigh();
  }

  Future getFiftyTwoWeekHigh({loadMore = false}) async {
    if (loadMore) {
      _page++;
      setStatusUp(Status.loadingMore);
    } else {
      _page = 1;
      setStatusUp(Status.loading);
    }
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
      };
      ApiResponse response = await apiRequest(
        url: Apis.weekHighs,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = fiftyTwoWeeksResFromJson(jsonEncode(response.data));
          _extra = response.extra is Extra ? response.extra : null;
        } else {
          _data?.addAll(fiftyTwoWeeksResFromJson(jsonEncode(response.data)));
        }
      } else {
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

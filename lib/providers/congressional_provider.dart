import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../modals/congressional_res.dart';

class CongressionalProvider extends ChangeNotifier {
  List<CongressionalRes>? _data;
  List<CongressionalRes>? get data => _data;

  Status _status = Status.ideal;
  Status get status => _status;

  int _pageUp = 1;
  int _openIndex = -1;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  bool canLoadMore = true;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Extra? _extra;
  Extra? get extra => _extra;

  int get openIndex => _openIndex;

  String? title;
  String? subTitle;

  FilteredParams? _filterParams;
  FilteredParams? get filterParams => _filterParams;

  void resetFilter() {
    _filterParams = null;
    _pageUp = 1;
    notifyListeners();
  }

  void applyFilter(FilteredParams? params) {
    _filterParams = params;
    _pageUp = 1;
    notifyListeners();
    getData();
  }

  void applySorting(String sortingKey) {
    if (_filterParams == null) {
      _filterParams = FilteredParams(sorting: sortingKey);
    } else {
      _filterParams!.sorting = sortingKey;
    }
    _pageUp = 1;
    notifyListeners();
    Utils()
        .showLog("Sorting Data ===   $sortingKey   ${_filterParams?.sorting}");
    getData();
  }

  // void exchangeFilter(String item) {
  //   _filterParams!.exchange_name!.remove(item);
  //   if (_filterParams!.exchange_name!.isEmpty) {
  //     _filterParams!.exchange_name = null;
  //   }
  //   _pageUp = 1;
  //   notifyListeners();
  //   getData();
  // }

  // void sectorFilter(String item) {
  //   _filterParams!.sector!.remove(item);
  //   if (_filterParams!.sector!.isEmpty) {
  //     _filterParams!.sector = null;
  //   }
  //   _pageUp = 1;
  //   notifyListeners();
  //   getData();
  // }

  // void industryFilter(String item) {
  //   _filterParams!.industry!.remove(item);
  //   if (_filterParams!.industry!.isEmpty) {
  //     _filterParams!.industry = null;
  //   }
  //   _pageUp = 1;
  //   notifyListeners();
  //   getData();
  // }

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  Future onRefresh() async {
    getData();
  }

  Future getData({
    showProgress = false,
    loadMore = false,
  }) async {
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
        "page": "$_pageUp",
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
        url: Apis.congress,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );
      if (response.status) {
        _error = null;
        canLoadMore = _pageUp < (response.extra.totalPages ?? 1);
        if (_pageUp == 1) {
          title = response.extra?.title;
          subTitle = response.extra?.subTitle;
          _data = congressionalResFromJson(jsonEncode(response.data));
          _extra = (response.extra is Extra ? response.extra as Extra : null);
        } else {
          List<CongressionalRes> parsedData = List<CongressionalRes>.from(
            (response.data as List).map((x) => CongressionalRes.fromJson(x)),
          );
          _data?.addAll(parsedData);
        }
      } else {
        if (_pageUp == 1) {
          _error = response.message;
          _data = null;
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}

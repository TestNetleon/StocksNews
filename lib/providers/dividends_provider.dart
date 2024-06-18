// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/dividends_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';

class DividendsProvider extends ChangeNotifier with AuthProviderBase {
  Status _status = Status.ideal;
  // ************* GAP DOWN **************** //
  List<DividendsRes>? _data;
  String? _error;
  int _page = 1;
  Extra? _extra;

  List<DividendsRes>? get data => _data;
  Extra? get extra => _extra;
  bool get canLoadMore => _page < (_extra?.totalPages ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  Status _statusDividendsStocks = Status.ideal;
  Status get statusDividendsStocks => _statusDividendsStocks;
  bool get isLoadingDividendsStocks => _statusDividendsStocks == Status.loading;
  int get openIndexDividendsStocks => _openIndexDividendsStocks;
  int _openIndexDividendsStocks = -1;
  int _openIndex = -1;

  int get openIndex => _openIndex;

  // ************* GAP DOWN **************** //
  String? _errorDown;
  int _pageDown = 1;
  // int? _totalPageDown;
  Extra? _extraDown;

  bool get canLoadMoreDown => _pageDown < (_extraDown?.totalPages ?? 1);
  String? get errorDown => _errorDown ?? Const.errSomethingWrong;
  bool get isLoadingDown => _status == Status.loading;

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
    getDividendsStocks();
  }

  void applySorting(String sortingKey) {
    _filterParams?.sorting = sortingKey;
    _page = 1;
    notifyListeners();

    getDividendsStocks();
  }

  void exchangeFilter(String item) {
    _filterParams!.exchange_name!.remove(item);
    if (_filterParams!.exchange_name!.isEmpty) {
      _filterParams!.exchange_name = null;
    }
    _page = 1;
    notifyListeners();
    getDividendsStocks();
  }

  void sectorFilter(String item) {
    _filterParams!.sector!.remove(item);
    if (_filterParams!.sector!.isEmpty) {
      _filterParams!.sector = null;
    }
    _page = 1;

    notifyListeners();
    getDividendsStocks();
  }

  void industryFilter(String item) {
    _filterParams!.industry!.remove(item);
    if (_filterParams!.industry!.isEmpty) {
      _filterParams!.industry = null;
    }
    _page = 1;
    notifyListeners();
    getDividendsStocks();
  }

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStatusDividendsStocks(status) {
    _statusDividendsStocks = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  void setOpenIndexDividendsStocks(index) {
    _openIndexDividendsStocks = index;
    notifyListeners();
  }

  Future getDividendsStocks({loadMore = false}) async {
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
        "page": "$_page",
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
        "sortBy": _filterParams?.sorting ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.dividends,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = dividendsResFromJson(jsonEncode(response.data));
          _extra = response.extra is Extra ? response.extra : null;
        } else {
          _data?.addAll(dividendsResFromJson(jsonEncode(response.data)));
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
      setStatus(Status.loaded);
    }
  }
}

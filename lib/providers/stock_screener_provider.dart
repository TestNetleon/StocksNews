// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/stock_screener_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';

class StockScreenerProvider extends ChangeNotifier {
  Status _status = Status.ideal;

  String? _error;
  int _page = 1;
  Extra? _extraUp;
  List<Result>? _data;

  List<Result>? get data => _data;
  Extra? get extraUp => _extraUp;
  bool get canLoadMore => _page < (_extraUp?.totalPages ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  Status _statusStockScreenerStocks = Status.ideal;

  Status get statusStockScreenerStocks => _statusStockScreenerStocks;
  bool get isLoadingStockScreenerStocks =>
      _statusStockScreenerStocks == Status.loading;
  int get openIndexStockScreenerStocks => _openIndexStockScreenerStocks;
  int _openIndexStockScreenerStocks = -1;
  int _openIndex = -1;

  int get openIndex => _openIndex;
  String? _errorDown;
  int _pageDown = 1;
  Extra? _extraDown;

  bool get canLoadMoreDown => _pageDown < (_extraDown?.totalPages ?? 1);
  String? get errorDown => _errorDown ?? Const.errSomethingWrong;
  bool get isLoadingDown => _status == Status.loading;

  StockScreenerRes? _dataFilterBottomSheet;
  StockScreenerRes? get dataFilterBottomSheet => _dataFilterBottomSheet;

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
    getStockScreenerStocks();
  }

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStatusStockScreenerStocks(status) {
    _statusStockScreenerStocks = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  void setOpenIndexStockScreenerStocks(index) {
    _openIndexStockScreenerStocks = index;
    notifyListeners();
  }

  Future getStockScreenerStocks({loadMore = false}) async {
    if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _page = 1;
      setStatus(Status.loading);
    }
    try {
      Map<String, dynamic> request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "exchange_name": _filterParams?.exchange_name?.key ?? "",
        "price": _filterParams?.price ?? "",
        "industry": _filterParams?.industry ?? "",
        "market_cap": _filterParams?.market_cap?.key ?? "",
        "beta": _filterParams?.beta ?? "",
        "dividend": _filterParams?.dividend ?? "",
        "isEtf": _filterParams?.isEtf ?? "",
        "isFund": _filterParams?.isFund ?? "",
        "isActivelyTrading": _filterParams?.isActivelyTrading ?? "",
        "sector": _filterParams?.sector ?? "",
        "page": "$_page",
      };
      // Map request = {
      //   "price": priceKey == null ? "" : priceKey.toString(),
      //   "industry": industriesKey == null ? "" : industriesKey.toString(),
      //   "exchange_name": exchangeKey == null ? "" : exchangeKey.toString(),
      //   "market_cap": marketCapKey == null ? "" : marketCapKey.toString(),
      //   "beta": betaKey == null ? "" : betaKey.toString(),
      //   "dividend": dividendKey == null ? "" : dividendKey.toString(),
      //   "isEtf": isEtfKey == null ? "" : isEtfKey.toString(),
      //   "isFund": isFundKey == null ? "" : isFundKey.toString(),
      //   "isActivelyTrading":
      //       isActivelyTradingKey == null ? "" : isActivelyTradingKey.toString(),
      //   "sector": sectorKey == null ? "" : sectorKey.toString(),
      //   "page": "$_page",
      // };

      ApiResponse response = await apiRequest(
        url: Apis.stockScreener,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _error = null;
        _dataFilterBottomSheet =
            stockScreenerResFromJson(jsonEncode(response.data));

        if (_page == 1) {
          _data = stockScreenerResFromJson(jsonEncode(response.data)).result;
          _extraUp = response.extra is Extra ? response.extra : null;
        } else {
          _data?.addAll(stockScreenerResFromJson(jsonEncode(response.data))
              .result as Iterable<Result>);
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

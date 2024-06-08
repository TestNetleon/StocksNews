// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/stock_screener_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/utils/constants.dart';

class StockScreenerProvider extends ChangeNotifier with AuthProviderBase {
  Status _status = Status.ideal;

  String? _error;
  int _page = 1;
  Extra? _extraUp;
  List<Result>? _data;

  List<Result>? get data => _data;
  Extra? get extraUp => _extraUp;
  bool get canLoadMore => _page < (_extraUp?.totalPages ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading;
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

  // TextEditingController exchangeController = TextEditingController(text: "");
  // String? _exchangeKey;
  // String? get exchangeKey => _exchangeKey;
  // TextEditingController sectorController = TextEditingController(text: "");
  // String? _sectorKey;
  // String? get sectorKey => _sectorKey;
  // TextEditingController industryController = TextEditingController(text: "");
  // String? _industriesKey;
  // String? get industriesKey => _industriesKey;
  // TextEditingController marketCapController = TextEditingController(text: "");
  // String? _marketCapKey;
  // String? get marketCapKey => _marketCapKey;
  // TextEditingController priceController = TextEditingController(text: "");
  // String? _priceKey;
  // String? get priceKey => _priceKey;
  // TextEditingController betaController = TextEditingController(text: "");
  // String? _betaKey;
  // String? get betaKey => _betaKey;
  // TextEditingController dividendController = TextEditingController(text: "");
  // String? _dividendKey;
  // String? get dividendKey => _dividendKey;
  // TextEditingController isEtfController = TextEditingController(text: "");
  // String? _isEtfKey;
  // String? get isEtfKey => _isEtfKey;
  // TextEditingController isFundController = TextEditingController(text: "");
  // String? _isFundKey;
  // String? get isFundKey => _isFundKey;
  // TextEditingController isActivelyTradingController =
  //     TextEditingController(text: "");
  // String? _isActivelyTradingKey;
  // String? get isActivelyTradingKey => _isActivelyTradingKey;

  // void onChangeExchange(key, value) {
  //   exchangeController.text = value;
  //   _exchangeKey = key;
  //   notifyListeners();
  // }

  // void onChangeNullValueSet() {
  //   exchangeController.text = "All Exchange";
  //   _exchangeKey = null;
  //   sectorController.text = "All Sector";
  //   _sectorKey = null;
  //   industryController.text = "All Industry";
  //   _industriesKey = null;
  //   marketCapController.text = "All Market Cap";
  //   _marketCapKey = null;
  //   priceController.text = "All Price";
  //   _priceKey = null;
  //   betaController.text = "All Beta";
  //   _betaKey = null;
  //   dividendController.text = "All Dividend";
  //   _dividendKey = null;
  //   isEtfController.text = "All";
  //   _isEtfKey = null;
  //   isFundController.text = "All";
  //   _isFundKey = null;
  //   isActivelyTradingController.text = "All";
  //   _isActivelyTradingKey = null;
  //   notifyListeners();
  // }

  // void onChangeSector(key, value) {
  //   sectorController.text = value;
  //   _sectorKey = key;
  //   notifyListeners();
  // }

  // void onChangeIndustries(key, value) {
  //   industryController.text = value;
  //   _industriesKey = key;
  //   notifyListeners();
  // }

  // void onChangeMarketcap(key, value) {
  //   marketCapController.text = value;
  //   _marketCapKey = key;
  //   notifyListeners();
  // }

  // void onChangePrice(key, value) {
  //   priceController.text = value;
  //   _priceKey = key;
  //   notifyListeners();
  // }

  // void onChangeBeta(key, value) {
  //   betaController.text = value;
  //   _betaKey = key;
  //   notifyListeners();
  // }

  // void onChangeDividend(key, value) {
  //   dividendController.text = value;
  //   _dividendKey = key;
  //   notifyListeners();
  // }

  // void onChangeIsEtf(key, value) {
  //   isEtfController.text = value;
  //   _isEtfKey = key;
  //   notifyListeners();
  // }

  // void onChangeIsFund(key, value) {
  //   isFundController.text = value;
  //   _isFundKey = key;
  //   notifyListeners();
  // }

  // void onChangeIsActivelyTrading(key, value) {
  //   isActivelyTradingController.text = value;
  //   _isActivelyTradingKey = key;
  //   notifyListeners();
  // }

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

  void exchangeFilter(String item) {
    _filterParams!.exchange_name!.remove(item);
    if (_filterParams!.exchange_name!.isEmpty) {
      _filterParams!.exchange_name = null;
    }
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
        "exchange_name": _filterParams?.exchange_name?.join(",") ?? "",
        "price": _filterParams?.price ?? "",
        "industry": _filterParams?.industry ?? "",
        "market_cap": _filterParams?.market_cap ?? "",
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

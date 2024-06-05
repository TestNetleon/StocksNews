// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/stock_screener_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
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

  TextEditingController exchangeController = TextEditingController();
  TextEditingController sectorController = TextEditingController();
  TextEditingController industryController = TextEditingController();
  TextEditingController marketCapController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController betaController = TextEditingController();
  TextEditingController dividendController = TextEditingController();
  TextEditingController isEtfController = TextEditingController();
  TextEditingController isFundController = TextEditingController();
  TextEditingController isActivelyTradingController = TextEditingController();

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
      Map request = {"page": "$_page"};

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

// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/dividends_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/utils/constants.dart';

class StockScreenerProvider extends ChangeNotifier with AuthProviderBase {
  Status _status = Status.ideal;
  // ************* GAP DOWN **************** //
  List<DividendsRes>? _data;
  String? _error;
  int _page = 1;
  Extra? _extraUp;

  List<DividendsRes>? get data => _data;
  Extra? get extraUp => _extraUp;
  bool get canLoadMore => _page < (_extraUp?.totalPages ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading;
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
      Map request = {"page": "$_page"};

      ApiResponse response = await apiRequest(
        url: Apis.dividends,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = dividendsResFromJson(jsonEncode(response.data));
          _extraUp = response.extra is Extra ? response.extra : null;
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

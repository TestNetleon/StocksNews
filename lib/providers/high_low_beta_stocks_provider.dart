// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/high_low_beta_stocks_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class HighLowBetaStocksProvider extends ChangeNotifier with AuthProviderBase {
  Status _status = Status.ideal;
  // ************* GAP DOWN **************** //

  String? _error;
  int _page = 1;
  Extra? _extraUp;
  List<HighLowBetaStocksRes>? _data;

  List<HighLowBetaStocksRes>? get data => _data;
  List<HighLowBetaStocksRes>? _dataLowBetaStocks;

  List<HighLowBetaStocksRes>? get dataLowBetaStocks => _dataLowBetaStocks;
  List<HighLowBetaStocksRes>? _dataNegativeBetaStocks;

  List<HighLowBetaStocksRes>? get dataNegativeBetaStocks =>
      _dataNegativeBetaStocks;
  Extra? get extraUp => _extraUp;
  bool get canLoadMore => _page < (_extraUp?.totalPages ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading;
  Status _statusHighLowBetaStocks = Status.ideal;
  Status get statusHighLowBetaStocks => _statusHighLowBetaStocks;
  bool get isLoadingHighLowBetaStocks =>
      _statusHighLowBetaStocks == Status.loading;
  int get openIndexHighLowBetaStocks => _openIndexHighLowBetaStocks;
  int _openIndexHighLowBetaStocks = -1;
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

  void setStatusHighLowBetaStocks(status) {
    _statusHighLowBetaStocks = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  void setOpenIndexHighLowBetaStocks(index) {
    _openIndexHighLowBetaStocks = index;
    notifyListeners();
  }

  Future onRefresh() async {
    // getHighLowNegativeBetaStocks();
  }

  Future getHighLowNegativeBetaStocks({loadMore = false, type = 1}) async {
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
        url: type == 1
            ? Apis.highBetaStocks
            : type == 2
                ? Apis.lowBetaStocks
                : Apis.negativeBetaStocks,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          type == 1
              ? _data = highLowBetaStocksResFromJson(jsonEncode(response.data))
              : type == 2
                  ? _dataLowBetaStocks =
                      highLowBetaStocksResFromJson(jsonEncode(response.data))
                  : _dataNegativeBetaStocks =
                      highLowBetaStocksResFromJson(jsonEncode(response.data));

          _extraUp = response.extra is Extra ? response.extra : null;
        } else {
          type == 1
              ? _data?.addAll(
                  highLowBetaStocksResFromJson(jsonEncode(response.data)))
              : type == 2
                  ? _dataLowBetaStocks?.addAll(
                      highLowBetaStocksResFromJson(jsonEncode(response.data)))
                  : _dataNegativeBetaStocks?.addAll(
                      highLowBetaStocksResFromJson(jsonEncode(response.data)));
        }
      } else {
        if (_page == 1) {
          type == 1
              ? _data = null
              : type == 2
                  ? _dataLowBetaStocks = null
                  : _dataNegativeBetaStocks = null;
          _data = null;
          _error = response.message;
          // showErrorMessage(message: response.message);
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      type == 1
          ? _data = null
          : type == 2
              ? _dataLowBetaStocks = null
              : _dataNegativeBetaStocks = null;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}

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

class HighBetaStocksProvider extends ChangeNotifier with AuthProviderBase {
  Status _status = Status.ideal;

  String? _error;
  int _page = 1;
  Extra? _extraUp;
  List<HighLowBetaStocksRes>? _data;

  List<HighLowBetaStocksRes>? get data => _data;

  Extra? get extraUp => _extraUp;
  bool get canLoadMore => _page < (_extraUp?.totalPages ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading;

  int get openIndex => _openIndex;
  int _openIndex = -1;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  Future onRefresh() async {
    // getHighLowNegativeBetaStocks();
  }

  Future getHighBetaStocks({loadMore = false, type = 1}) async {
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
        url: Apis.highBetaStocks,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = highLowBetaStocksResFromJson(jsonEncode(response.data));

          _extraUp = response.extra is Extra ? response.extra : null;
        } else {
          _data
              ?.addAll(highLowBetaStocksResFromJson(jsonEncode(response.data)));
        }
      } else {
        if (_page == 1) {
          _data = null;
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

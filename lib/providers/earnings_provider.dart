import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/earnings_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/utils/constants.dart';

class EarningsProvider extends ChangeNotifier with AuthProviderBase {
  Status _status = Status.ideal;
  // ************* GAP DOWN **************** //
  List<EarningsRes>? _data;
  String? _error;
  int _page = 1;
  Extra? _extraUp;

  List<EarningsRes>? get data => _data;
  Extra? get extraUp => _extraUp;
  bool get canLoadMore => _page < (_extraUp?.totalPages ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading;
  Status _statusEarningsStocks = Status.ideal;
  Status get statusEarningsStocks => _statusEarningsStocks;
  bool get isLoadingEarningsStocks => _statusEarningsStocks == Status.loading;
  int get openIndexEarningsStocks => _openIndexEarningsStocks;
  int _openIndexEarningsStocks = -1;
  int _openIndex = -1;

  int get openIndex => _openIndex;

  // ************* GAP DOWN **************** //
  String? _errorDown;
  // int _pageDown = 1;
  // int? _totalPageDown;
  // Extra? _extraDown;

  // bool get canLoadMoreDown => _pageDown < (_extraDown?.totalPages ?? 1);
  String? get errorDown => _errorDown ?? Const.errSomethingWrong;
  bool get isLoadingDown => _status == Status.loading;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStatusEarningsStocks(status) {
    _statusEarningsStocks = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  void setOpenIndexEarningsStocks(index) {
    _openIndexEarningsStocks = index;
    notifyListeners();
  }

  Future getEarningsStocks({loadMore = false}) async {
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
        url: Apis.earnings,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = earningsResFromJson(jsonEncode(response.data));
          _extraUp = response.extra is Extra ? response.extra : null;
        } else {
          _data?.addAll(earningsResFromJson(jsonEncode(response.data)));
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

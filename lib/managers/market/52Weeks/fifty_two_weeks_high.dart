import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/managers/market/market.dart';
import 'package:stocks_news_new/models/lock.dart';
import 'package:stocks_news_new/models/market/most_bullish.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class FiftyTwoWeeksHighManager extends ChangeNotifier {
  MarketDataRes? _data;
  MarketDataRes? get data => _data;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  int _page = 1;
  bool get canLoadMore => (_data?.totalPages ?? 0) >= _page;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getData({loadMore = false, filter = false}) async {
    final filterRequest =
        navigatorKey.currentContext!.read<MarketManager>().filterRequest;

    if (loadMore == false || filter) {
      _page = 1;
    }

    try {
      _error = null;
      setStatus(loadMore ? Status.loadingMore : Status.loading);

      final request = filterRequest != null
          ? {"page": "$_page", ...filterRequest}
          : {"page": "$_page"};

      ApiResponse response = await apiRequest(
        url: Apis.fiftyTwoWeekHigh,
        request: request,
      );
      if (response.status) {
        if (_page == 1) {
          _data = marketDataResFromJson(jsonEncode(response.data));
          _lockInformation = _data?.lockInfo;
        } else {
          _data!.data!.addAll(
            marketDataResFromJson(jsonEncode(response.data)).data!,
          );
        }
        _page++;
      } else {
        _data = null;
        _error = response.message;
      }
      setStatus(Status.loaded);
    } catch (e) {
      Utils().showLog("Error => $e");
      _data = null;
      _error = Const.errSomethingWrong;
      setStatus(Status.loaded);
    }
  }

  void updateTickerInfo({required String symbol, alertAdded, watchListAdded}) {
    if (_data?.data != null) {
      final index =
          _data?.data?.indexWhere((element) => element.symbol == symbol);
      if (index != null && index != -1) {
        if (alertAdded != null) {
          _data?.data![index].isAlertAdded = alertAdded;
        }
        if (watchListAdded != null) {
          _data?.data![index].isWatchlistAdded = watchListAdded;
        }
        notifyListeners();
      }
    }
  }

  BaseLockInfoRes? _lockInformation;
  BaseLockInfoRes? get lockInformation => _lockInformation;

  BaseLockInfoRes? getLockINFO() {
    BaseLockInfoRes? info = _lockInformation;
    return info;
  }
}

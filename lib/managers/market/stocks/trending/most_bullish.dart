import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/models/market/most_bullish.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class MostBullishManager extends ChangeNotifier {
  MarketDataRes? _data;
  MarketDataRes? get data => _data;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  bool get isLoadingBullish => _status == Status.loading;

  Extra? _extra;
  Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getData({showProgress = false}) async {
    try {
      _error = null;
      setStatus(Status.loading);
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserManager>().user?.token ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.mostBullish,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _data = marketDataResFromJson(jsonEncode(response.data));
        _extra = (response.extra is Extra ? response.extra as Extra : null);
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
    // finally {
    //   setStatus(Status.loaded);
    // }
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
}

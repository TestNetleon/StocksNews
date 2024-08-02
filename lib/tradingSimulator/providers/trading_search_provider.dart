import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/tradingSimulator/modals/trading_search_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

//
class TradingSearchProvider extends ChangeNotifier {
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  List<TradingSearchTickerRes>? _data;
  List<TradingSearchTickerRes>? get data => _data;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _statusS = Status.ideal;
  Status get statusS => _statusS;

  bool get isLoadingS => _statusS == Status.loading;

  Extra? _extra;
  Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStatusS(status) {
    _statusS = status;
    notifyListeners();
  }

  void clearSearch() {
    _status = Status.ideal;
    _statusS = Status.ideal;
    _data = null;
    // _dataNew = null;
    notifyListeners();
  }

  Future getSearchDefaults() async {
    setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? ""
      };

      ApiResponse response = await apiRequest(
        url: Apis.tradingMostSearch,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _extra = (response.extra is Extra ? response.extra as Extra : null);
        _data = tradingSearchTickerResFromJson(jsonEncode(response.data));
      } else {
        // _data = null;
        // showErrorMessage(message: response.message);
      }
      setStatus(Status.ideal);
    } catch (e) {
      Utils().showLog(e.toString());
      setStatus(Status.ideal);
    }
  }
}

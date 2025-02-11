import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';

class MarketManager extends ChangeNotifier {
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  MarketRes? _data;
  MarketRes? get data => _data;

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getData() async {
    try {
      setStatus(Status.loading);
      UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
      Map request = {'token': provider.user?.token ?? ''};

      ApiResponse response = await apiRequest(
        url: Apis.marketData,
        request: request,
      );

      if (response.status) {
        _data = marketResFromJson(jsonEncode(response.data));
        _error = null;
      } else {
        _data = null;
        _error = response.message;
      }
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
    } finally {
      setStatus(Status.loaded);
    }
  }
}

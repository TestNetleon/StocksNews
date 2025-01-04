import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_portfolio_res.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_user_res.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

//
class TsPortfolioProvider extends ChangeNotifier {
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  List<TsPortfolioRes>? _data;
  List<TsPortfolioRes>? get data => _data;

  TsUserRes? _userData;
  TsUserRes? get userData => _userData;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  // Extra? _extra;
  // Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void updateBalance({num? position, num? marketValue}) {
    if (position != null) {
      _userData?.currentPositionAmount = position;
    }
    if (marketValue != null) {
      _userData?.investedValue = marketValue;
    }
    notifyListeners();
  }

  Future getData() async {
    setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "mssql_id": "${userData?.sqlId}"
      };

      ApiResponse response = await apiRequest(
        url: Apis.tsPortfolio,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _data = tsPortfolioResFromJson(jsonEncode(response.data));
        // _extra = (response.extra is Extra ? response.extra as Extra : null);
        _error = null;
      } else {
        _data = null;
        _error = response.message ?? Const.errSomethingWrong;
        // showErrorMessage(message: response.message);
      }
      setStatus(Status.loaded);
    } catch (e) {
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future getDashboardData() async {
    setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? ""
      };
      ApiResponse response = await apiRequest(
        url: Apis.tsUserInfo,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _userData = tsUserResFromJson(jsonEncode(response.data));
        // _userData?.tradeBalance = 100;
        // _extra = (response.extra is Extra ? response.extra as Extra : null);
        _error = null;
      } else {
        _data = null;
        _error = response.message ?? Const.errSomethingWrong;
        // showErrorMessage(message: response.message);
      }
      setStatus(Status.loaded);
    } catch (e) {
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}

import 'dart:async';
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

import '../modals/stream_data.dart';

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

  Extra? _extra;
  Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void updateBalance({
    num? totalReturn,
    num? marketValue,
    num? todayReturn,
  }) {
    if (totalReturn != null) {
      _userData?.totalReturn = totalReturn;
    }
    if (marketValue != null) {
      _userData?.marketValue = marketValue;
    }
    if (todayReturn != null) {
      _userData?.todayReturn = todayReturn;
    }
    notifyListeners();
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
        // _userData?.staticTotalReturn = _userData?.totalReturn;
        // _userData?.totalReturn = (_userData?.staticTotalReturn ?? 0) +
        //     ((_userData?.marketValue ?? 0) - (_userData?.investedAmount ?? 0));

        _userData?.totalReturn =
            ((_userData?.marketValue ?? 0) - (_userData?.investedAmount ?? 0));
        _extra = (response.extra is Extra ? response.extra as Extra : null);
        _error = null;
      } else {
        _userData = null;
        _error = response.message ?? Const.errSomethingWrong;
        // showErrorMessage(message: response.message);
      }
      setStatus(Status.loaded);
    } catch (e) {
      _userData = null;

      _error = Const.errSomethingWrong;
      Utils().showLog('Error getDashboardData $e');
      setStatus(Status.loaded);
    }
  }

  StreamRes? _streamData;
  StreamRes? get streamData => _streamData;

  Future getStreamKeysData() async {
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? ""
      };
      ApiResponse response = await apiRequest(
        url: Apis.tsStreamData,
        request: request,
      );
      if (response.status) {
        _streamData = streamResFromJson(jsonEncode(response.data));
        streamKeysRes = _streamData;
      } else {
        _streamData = null;
        streamKeysRes = _streamData;
      }
      notifyListeners();
    } catch (e) {
      _streamData = null;
      streamKeysRes = _streamData;

      notifyListeners();
    }
  }
}

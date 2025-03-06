import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/stream_data.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_holidays_list_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_user_res.dart';
import 'package:stocks_news_new/utils/constants.dart';
import '../../../../../utils/utils.dart';

class PortfolioManager extends ChangeNotifier {
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading;


  TsUserRes? _userData;
  TsUserRes? get userData => _userData;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;


  void setStatus(status) {
    _status = status;
    notifyListeners();
  }


  void updateBalance({
    num? totalReturn,
    num? marketValue,
    num? todayReturn,
  }) {

    if (todayReturn != null) {
      _userData?.userDataRes?.todayReturn = todayReturn;
      notifyListeners();
    }
    if (totalReturn != null) {
      _userData?.userDataRes?.totalReturn = totalReturn;
    }
    if (marketValue != null) {
      _userData?.userDataRes?.marketValue = marketValue;
    }

    notifyListeners();
  }

  List<MarketResData> tabs = [
    MarketResData(title: 'OPEN'),
    MarketResData(title: 'PENDING'),
    MarketResData(title: 'TRANSACTIONS'),
    MarketResData(title: 'RECURRING'),
  ];

  int? selectedScreen=0;
  onScreenChange(index) {
    if (selectedScreen != index) {
      selectedScreen = index;
      notifyListeners();
    }
  }

  Future getDashboardData({bool reset = false}) async {
    if(reset){
      _userData=null;
      _error=null;
    }
    setStatus(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.tsUserInfo,
        showProgress: false,
        request: {},
      );
      if (response.status) {
        _userData = tsUserResFromJson(jsonEncode(response.data));
        _error = null;
      } else {
        _userData = null;
        _error = response.message ?? Const.errSomethingWrong;
      }
      setStatus(Status.loaded);
    } catch (e) {
      _userData = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Error getDashboardData $e');
      setStatus(Status.loaded);
    }
  }

  /*List<DateTime>? _holidays;
  List<DateTime>? get holidays => _holidays;*/

  HolidayRes? _holidaysRes;
  HolidayRes? get holidaysRes => _holidaysRes;


  Future<void> getHolidays() async {
    try {
      ApiResponse response = await apiRequest(
        url: Apis.holidaysList,
        showProgress: false,
        request: {},
      );
      if (response.status) {
        _holidaysRes = holidayResFromMap(jsonEncode(response.data));
        _holidaysRes?.holidays?.add(DateTime(DateTime.now().year + 1, 1, 1));
        _error = null;
      } else {
        _holidaysRes = null;
        _error = response.message ?? Const.errSomethingWrong;
      }

    } catch (e) {
      _holidaysRes = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Open data: $e');
    }
  }

  StreamRes? _streamData;
  StreamRes? get streamData => _streamData;

  Future getStreamKeysData() async {
    try {
      ApiResponse response = await apiRequest(
        url: Apis.tsStreamData,
        request: {},
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

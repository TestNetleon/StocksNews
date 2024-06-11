import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/stockDetailRes/dividends.dart';
import 'package:stocks_news_new/modals/stockDetailRes/tab.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../api/apis.dart';
import '../modals/stockDetailRes/earnings.dart';
import '../route/my_app.dart';
import '../utils/constants.dart';
import 'user_provider.dart';

class StockDetailProviderNew extends ChangeNotifier {
  //TAB DATA
  String? _errorTab;
  String? get errorTab => _errorTab ?? Const.errSomethingWrong;

  Status _statusTab = Status.ideal;
  Status get statusTab => _statusTab;

  bool get isLoadingTab => _statusTab == Status.loading;

  Extra? _extra;
  Extra? get extra => _extra;

  StockDetailTabRes? _tabRes;
  StockDetailTabRes? get tabRes => _tabRes;

  int selectedTab = 0;

  void setStatusTab(status) {
    _statusTab = status;
    notifyListeners();
  }

  onTabChange(index) {
    if (selectedTab != index) {
      selectedTab = index;
      notifyListeners();
    }
  }

  Future getTabData({String? symbol}) async {
    _tabRes = null;
    selectedTab = 0;
    setStatusTab(Status.loading);
    try {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
      });
      ApiResponse response = await apiRequest(
        url: Apis.stockDetailTab,
        formData: request,
        showProgress: false,
      );
      if (response.status) {
        _tabRes = stockDetailTabResFromJson(jsonEncode(response.data));
        _extra = (response.extra is Extra ? response.extra as Extra : null);

        if (_tabRes != null) {
          // getPlaidPortfolioData(name: _tabs[selectedTab]);
        }
      } else {
        //
        _errorTab = response.message;
      }
      setStatusTab(Status.loaded);
    } catch (e) {
      Utils().showLog(e.toString());
      setStatusTab(Status.loaded);
    }
  }

//---------------------------------------------------------------
  //Earnings DATA
  String? _errorEarning;
  String? get errorEarning => _errorEarning ?? Const.errSomethingWrong;

  Status _statusEarning = Status.ideal;
  Status get statusEarning => _statusEarning;

  bool get isLoadingEarning => _statusEarning == Status.loading;

  Extra? _extraEarning;
  Extra? get extraEarning => _extraEarning;

  SdEarningsRes? _earnings;
  SdEarningsRes? get earnings => _earnings;

  void setStatusEarning(status) {
    _statusEarning = status;
    notifyListeners();
  }

  Future getEarningsData({String? symbol}) async {
    setStatusEarning(Status.loading);
    try {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
      });
      ApiResponse response = await apiRequest(
        url: Apis.detailEarning,
        formData: request,
        showProgress: false,
      );
      if (response.status) {
        _earnings = sdEarningsResFromJson(jsonEncode(response.data));
        _extraEarning =
            (response.extra is Extra ? response.extra as Extra : null);
      } else {
        //
        _earnings = null;
        _errorEarning = response.message;
      }
      setStatusEarning(Status.loaded);
    } catch (e) {
      _earnings = null;
      _errorEarning = Const.errSomethingWrong;

      Utils().showLog(e.toString());
      setStatusEarning(Status.loaded);
    }
  }

//---------------------------------------------------------------
  //Dividends DATA
  String? _errorDividends;
  String? get errorDividends => _errorDividends ?? Const.errSomethingWrong;

  Status _statusDividends = Status.ideal;
  Status get statusDividends => _statusDividends;

  bool get isLoadingDividends => _statusDividends == Status.loading;

  Extra? _extraDividends;
  Extra? get extraDividends => _extraDividends;

  SdDividendsRes? _dividends;
  SdDividendsRes? get dividends => _dividends;

  void setStatusDividends(status) {
    _statusDividends = status;
    notifyListeners();
  }

  Future getDividendsData({String? symbol}) async {
    setStatusDividends(Status.loading);
    try {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
      });
      ApiResponse response = await apiRequest(
        url: Apis.detailDividends,
        formData: request,
        showProgress: false,
      );
      if (response.status) {
        _dividends = sdDividendsResFromJson(jsonEncode(response.data));
        _extraDividends =
            (response.extra is Extra ? response.extra as Extra : null);
      } else {
        //
        _dividends = null;
        _errorDividends = response.message;
      }
      setStatusDividends(Status.loaded);
    } catch (e) {
      _dividends = null;
      _errorDividends = Const.errSomethingWrong;

      Utils().showLog(e.toString());
      setStatusDividends(Status.loaded);
    }
  }
}

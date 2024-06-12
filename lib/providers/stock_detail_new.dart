import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/stockDetailRes/chart.dart';
import 'package:stocks_news_new/modals/stockDetailRes/dividends.dart';
import 'package:stocks_news_new/modals/stockDetailRes/sec_filing_res.dart';
import 'package:stocks_news_new/modals/stockDetailRes/tab.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../api/apis.dart';
import '../modals/analysis_res.dart';
import '../modals/stockDetailRes/analyst_forecast.dart';
import '../modals/stockDetailRes/earnings.dart';
import '../modals/technical_analysis_res.dart';
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
        "symbol": symbol ?? "",
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
        "symbol": symbol ?? "",
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
        "symbol": symbol ?? "",
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

//---------------------------------------------------------------
  //Analysis DATA
  String? _errorAnalysis;
  String? get errorAnalysis => _errorAnalysis ?? Const.errSomethingWrong;

  Status _statusAnalysis = Status.ideal;
  Status get statusAnalysis => _statusAnalysis;

  bool get isLoadingAnalysis => _statusAnalysis == Status.loading;

  Extra? _extraAnalysis;
  Extra? get extraAnalysis => _extraAnalysis;

  AnalysisRes? _analysis;
  AnalysisRes? get analysis => _analysis;

  void setStatusAnalysis(status) {
    _statusAnalysis = status;
    notifyListeners();
  }

  Future getAnalysisData({String? symbol}) async {
    setStatusAnalysis(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.stockAnalysis,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _analysis = analysisResFromJson(jsonEncode(response.data));
      } else {
        _analysis = null;
        _errorAnalysis = response.message;
      }
      setStatusAnalysis(Status.loaded);
    } catch (e) {
      _analysis = null;
      Utils().showLog(e.toString());
      _errorAnalysis = Const.errSomethingWrong;
      setStatusAnalysis(Status.loaded);
    }
  }

//---------------------------------------------------------------
  //Chart DATA
  String? _errorChart;
  String? get errorChart => _errorChart ?? Const.errSomethingWrong;

  Status _statusChart = Status.ideal;
  Status get statusChart => _statusChart;

  bool get isLoadingChart => _statusChart == Status.loading;

  Extra? _extraChart;
  Extra? get extraChart => _extraChart;

  SdChartRes? _chartRes;
  SdChartRes? get chartRes => _chartRes;

  void setStatusChart(status) {
    _statusChart = status;
    notifyListeners();
  }

  Future getChartData({String? symbol}) async {
    setStatusChart(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.detailChart,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _chartRes = sdChartResFromJson(jsonEncode(response.data));
      } else {
        _chartRes = null;
        _errorChart = response.message;
      }
      setStatusChart(Status.loaded);
    } catch (e) {
      _chartRes = null;
      Utils().showLog(e.toString());
      _errorChart = Const.errSomethingWrong;
      setStatusChart(Status.loaded);
    }
  }

//---------------------------------------------------------------
  //Sec Filing DATA
  String? _errorSec;
  String? get errorSec => _errorSec ?? Const.errSomethingWrong;

  Status _statusSec = Status.ideal;
  Status get statusSec => _statusSec;

  bool get isLoadingSec => _statusSec == Status.loading;

  Extra? _extraSec;
  Extra? get extraSec => _extraSec;

  SecFilingRes? _secRes;
  SecFilingRes? get secRes => _secRes;

  void setStatusSec(status) {
    _statusSec = status;
    notifyListeners();
  }

  Future getSecFilingData({String? symbol}) async {
    setStatusSec(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.detailSec,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _secRes = secFilingResFromJson(jsonEncode(response.data));
      } else {
        _secRes = null;
        _errorSec = response.message;
      }
      setStatusSec(Status.loaded);
    } catch (e) {
      _secRes = null;
      Utils().showLog(e.toString());
      _errorSec = Const.errSomethingWrong;
      setStatusSec(Status.loaded);
    }
  }

//---------------------------------------------------------------
  //Analyst Forecast DATA
  String? _errorForecast;
  String? get errorForecast => _errorForecast ?? Const.errSomethingWrong;

  Status _statusForecast = Status.ideal;
  Status get statusForecast => _statusForecast;

  bool get isLoadingForecast => _statusForecast == Status.loading;

  Extra? _extraForecast;
  Extra? get extraForecast => _extraForecast;

  SdAnalystForecastRes? _forecastRes;
  SdAnalystForecastRes? get forecastRes => _forecastRes;

  void setStatusForecast(status) {
    _statusForecast = status;
    notifyListeners();
  }

  Future getForecastData({String? symbol}) async {
    setStatusForecast(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.detailForecast,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _forecastRes = sdAnalystForecastResFromJson(jsonEncode(response.data));
      } else {
        _forecastRes = null;
        _errorForecast = response.message;
      }
      setStatusForecast(Status.loaded);
    } catch (e) {
      _forecastRes = null;
      Utils().showLog(e.toString());
      _errorForecast = Const.errSomethingWrong;
      setStatusForecast(Status.loaded);
    }
  }

//---------------------------------------------------------------
  //Technical Analysis DATA
  String? _errorTech;
  String? get errorTech => _errorTech ?? Const.errSomethingWrong;

  Status _statusTech = Status.ideal;
  Status get statusTech => _statusTech;

  bool get isLoadingTech => _statusTech == Status.loading;

  Extra? _extraTech;
  Extra? get extraTech => _extraTech;

  TechnicalAnalysisRes? _techRes;
  TechnicalAnalysisRes? get techRes => _techRes;

  void setStatusTechnical(status) {
    _statusTech = status;
    notifyListeners();
  }

  Future getTechnicalAnalysisData({
    String? symbol,
    String interval = "5min",
  }) async {
    setStatusTechnical(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol ?? "",
        "interval": interval,
      };

      ApiResponse response = await apiRequest(
        url: Apis.technicalAnalysis,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _techRes = technicalAnalysisResFromJson(jsonEncode(response.data));
      } else {
        _techRes = null;
        _errorForecast = response.message;
      }
      setStatusTechnical(Status.loaded);
    } catch (e) {
      _techRes = null;
      Utils().showLog(e.toString());
      _errorTech = Const.errSomethingWrong;
      setStatusTechnical(Status.loaded);
    }
  }
}

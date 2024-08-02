import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/stockDetailRes/chart.dart';
import 'package:stocks_news_new/modals/stockDetailRes/competitor.dart';
import 'package:stocks_news_new/modals/stockDetailRes/dividends.dart';
import 'package:stocks_news_new/modals/stockDetailRes/financial.dart';
import 'package:stocks_news_new/modals/stockDetailRes/mergers_res.dart';
import 'package:stocks_news_new/modals/stockDetailRes/ownership.dart';
import 'package:stocks_news_new/modals/stockDetailRes/overview_graph.dart';
import 'package:stocks_news_new/modals/stockDetailRes/sd_insider_res.dart';
import 'package:stocks_news_new/modals/stockDetailRes/sd_news.dart';
import 'package:stocks_news_new/modals/stockDetailRes/sd_social_res.dart';
import 'package:stocks_news_new/modals/stockDetailRes/sec_filing_res.dart';
import 'package:stocks_news_new/modals/stockDetailRes/tab.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:vibration/vibration.dart';

import '../api/apis.dart';
import '../modals/analysis_res.dart';
import '../modals/stockDetailRes/analyst_forecast.dart';
import '../modals/stockDetailRes/earnings.dart';
import '../modals/stockDetailRes/overview.dart';
import '../modals/technical_analysis_res.dart';
import '../route/my_app.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import 'user_provider.dart';

class StockDetailProviderNew extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  void clearAll() {
    //Tab clear
    selectedTab = 0;
    _errorTab = null;
    _extra = null;
    _tabRes = null;

    //Earning clear
    _errorEarning = null;
    _extraEarning = null;
    _earnings = null;

    //Dividends clear
    _errorDividends = null;
    _extraDividends = null;
    _dividends = null;

    //Analysis clear
    _errorAnalysis = null;
    _extraAnalysis = null;
    _analysis = null;

    //Chart clear
    _errorChart = null;
    _extraChart = null;
    _chartRes = null;

    //Sec Filing clear
    _errorSec = null;
    _extraSec = null;
    _secRes = null;

    //Analyst Forecast clear
    _errorForecast = null;
    _extraForecast = null;
    _forecastRes = null;

    //Technical Analysis clear
    _errorTech = null;
    _extraTech = null;
    _techRes = null;

    //Overview clear
    _errorOverview = null;
    _extraOverview = null;
    _overviewRes = null;

    //Graph clear
    _errorGraph = null;
    _extraGraph = null;
    _graphChart = null;

    //Ownership clear
    _errorOwnership = null;
    _extraOwnership = null;
    _ownershipRes = null;

    //Competitor clear
    _errorCompetitor = null;
    _extraCompetitor = null;
    _competitorRes = null;

    //News clear
    _errorNews = null;
    _extraNews = null;
    _newsRes = null;
    _newsResN = null;
    value = null;

    //Social clear
    _errorSocial = null;
    _extraSocial = null;
    _socialRes = null;

    //Insider Trades clear
    _errorInsiderTrade = null;
    _extraInsiderTrade = null;
    _sdInsiderTradeRes = null;

    //Financial clear
    _errorFinancial = null;
    _extraFinancial = null;
    _sdFinancialArray = null;
    _types = null;
    _periods = null;
    typeIndex = 0;
    periodIndex = 0;
  }

  void updateSocket({
    String? price,
    num? change,
    num? changePercentage,
    String? changeString,
  }) {
    if (change != null) {
      _tabRes?.keyStats?.change = change;
    }
    if (price != null && price != '') {
      _tabRes?.keyStats?.price = price;
    }
    if (changePercentage != null) {
      _tabRes?.keyStats?.changesPercentage = changePercentage;
    }
    if (changeString != null && changeString != '') {
      _tabRes?.keyStats?.changeWithCur = changeString;
    }

    notifyListeners();
  }

  //TAB DATA
  String? _errorTab;
  String? get errorTab => _errorTab ?? Const.errSomethingWrong;

  Status _statusTab = Status.ideal;
  Status get statusTab => _statusTab;

  bool get isLoadingTab =>
      _statusTab == Status.loading || _statusTab == Status.ideal;

  Extra? _extra;
  Extra? get extra => _extra;

  StockDetailTabRes? _tabRes;
  StockDetailTabRes? get tabRes => _tabRes;

  int selectedTab = 0;
  int _openIndex = -1;
  int get openIndex => _openIndex;
  bool _firstValueNotShow = true;
  bool get firstValueNotShow => _firstValueNotShow;
  bool _firstValueNotShowOne = false;
  bool get firstValueNotShowOne => _firstValueNotShowOne;

  bool _firstValueNotShowTwo = false;
  bool get firstValueNotShowTwo => _firstValueNotShowTwo;

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  void changeAlert(value) {
    _tabRes?.isAlertAdded = value;
    notifyListeners();
  }

  void changeWatchList(value) {
    _tabRes?.isWatchListAdded = value;
    notifyListeners();
  }

  void firstValueNotShowD(value) {
    _firstValueNotShow = value;
    notifyListeners();
  }

  void firstValueNotShowOneD(value) {
    _firstValueNotShowOne = value;
    notifyListeners();
  }

  void firstValueNotShowTwoD(value) {
    _firstValueNotShowTwo = value;
    notifyListeners();
  }

  void setStatusTab(status) {
    _statusTab = status;
    notifyListeners();
  }

  onTabChange(index) {
    notifyListeners();
    if (selectedTab != index) {
      selectedTab = index;
      notifyListeners();
    }
  }

  Future createAlertSendPeer({
    required String alertName,
    required String symbol,
    required int index,
    bool selectedOne = false,
    bool selectedTwo = false,
  }) async {
    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "symbol": symbol,
      "alert_name": alertName,
      "sentiment_spike": selectedOne ? "yes" : "no",
      "mention_spike": selectedTwo ? "yes" : "no",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.createAlert,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      _analysis?.peersData?[index].isAlertAdded = 1;
      notifyListeners();

      _extra = (response.extra is Extra ? response.extra as Extra : null);
      await _player.play(AssetSource(AudioFiles.alertWeathlist));

      navigatorKey.currentContext!
          .read<HomeProvider>()
          .setTotalsAlerts(response.data['total_alerts']);
      notifyListeners();

      Navigator.pop(navigatorKey.currentContext!);
      Navigator.pop(navigatorKey.currentContext!);

      showErrorMessage(
          message: response.message,
          type: response.status ? SnackbarType.info : SnackbarType.error);

      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog(e.toString());
      // showErrorMessage(message: Const.errSomethingWrong);
    }
  }

  Future addToWishListPeer({
    required String symbol,
    required bool up,
    required int index,
  }) async {
    showGlobalProgressDialog();

    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "symbol": symbol
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.addWatchlist,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (response.status) {
        //
        _analysis?.peersData?[index].isWatchlistAdded = 1;
        notifyListeners();

        // _homeTrendingRes?.trending[index].isWatchlistAdded = 1;

        await _player.play(AssetSource(AudioFiles.alertWeathlist));

        navigatorKey.currentContext!
            .read<HomeProvider>()
            .setTotalsWatchList(response.data['total_watchlist']);
      }
      showErrorMessage(
          message: response.message,
          type: response.status ? SnackbarType.info : SnackbarType.error);

      closeGlobalProgressDialog();
      return ApiResponse(status: response.status);
    } catch (e) {
      closeGlobalProgressDialog();

      Utils().showLog(e.toString());
      // showErrorMessage(message: Const.errSomethingWrong);
    }
  }

  Future createAlertSend({
    required String alertName,
    bool selectedOne = false,
    bool selectedTwo = false,
    int? index,
  }) async {
    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "symbol": _tabRes?.keyStats?.symbol ?? "",
      "alert_name": alertName,
      "sentiment_spike": selectedOne ? "yes" : "no",
      "mention_spike": selectedTwo ? "yes" : "no",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.createAlert,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (response.status) {
        if (index == null) {
          _tabRes?.isAlertAdded = 1;
        }
        if (index != null) {
          _analysis?.peersData?[index].isAlertAdded = 1;
        }

        await _player.play(AssetSource(AudioFiles.alertWeathlist));

        navigatorKey.currentContext!
            .read<HomeProvider>()
            .setTotalsAlerts(response.data['total_alerts']);
        // notifyListeners();
      }
      Navigator.pop(navigatorKey.currentContext!);
      Navigator.pop(navigatorKey.currentContext!);
      notifyListeners();

      return ApiResponse(status: response.status, data: response.data);
    } catch (e) {
      Utils().showLog(e.toString());
      notifyListeners();
    }
  }

  Future addToWishList({int? index}) async {
    notifyListeners();

    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "symbol": _tabRes?.keyStats?.symbol ?? "",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.addWatchlist,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (response.status) {
        if (index == null) {
          _tabRes?.isWatchListAdded = 1;
        }
        if (index != null) {
          _analysis?.peersData?[index].isWatchlistAdded = 1;
        }
        await _player.play(AssetSource(AudioFiles.alertWeathlist));

        navigatorKey.currentContext!
            .read<HomeProvider>()
            .setTotalsWatchList(response.data['total_watchlist']);
      }
      // showErrorMessage(
      //     message: response.message,
      //     type: response.status ? SnackbarType.info : SnackbarType.error);

      notifyListeners();

      return ApiResponse(status: response.status, data: response.data);
    } catch (e) {
      Utils().showLog(e.toString());
      notifyListeners();

      // showErrorMessage(message: Const.errSomethingWrong);
    }
  }

  Future getTabData({
    String? symbol,
    showProgress = false,
  }) async {
    clearAll();
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
        showProgress: showProgress,
      );
      if (response.status) {
        _tabRes = stockDetailTabResFromJson(jsonEncode(response.data));
        _tabRes?.tabs?.removeWhere((tab) => tab.name == "Social Activities");
        _extra = (response.extra is Extra ? response.extra as Extra : null);
        Preference.saveReferInput(_extra?.affiliateInput == 1);

        if (_tabRes != null) {
          // getPlaidPortfolioData(name: _tabs[selectedTab]);
        }
      } else {
        //
        _errorTab = response.message;
      }
      setStatusTab(Status.loaded);
      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog(e.toString());
      setStatusTab(Status.loaded);
      return ApiResponse(status: false);
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

  int _openIndexEarningHistory = -1;
  int get openIndexEarningHistory => _openIndexEarningHistory;
  void setOpenIndexEarningHistory(index) {
    _openIndexEarningHistory = index;
    notifyListeners();
  }

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
    _openIndex = -1;
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
        _extraAnalysis =
            (response.extra is Extra ? response.extra as Extra : null);
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
        _extraChart =
            (response.extra is Extra ? response.extra as Extra : null);
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
        _extraSec = (response.extra is Extra ? response.extra as Extra : null);
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
    _openIndex = -1;

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
        Utils().showLog("length ---- ${_forecastRes?.chartData?.length}");
        _extraForecast =
            (response.extra is Extra ? response.extra as Extra : null);
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
        _extraTech = (response.extra is Extra ? response.extra as Extra : null);
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

//---------------------------------------------------------------
//Overview DATA
  String? _errorOverview;
  String? get errorOverview => _errorOverview ?? Const.errSomethingWrong;

  Status _statusOverview = Status.ideal;
  Status get statusOverview => _statusOverview;

  bool get isLoadingOverview => _statusOverview == Status.loading;
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;
  Extra? _extraOverview;
  Extra? get extraOverview => _extraOverview;

  SdOverviewRes? _overviewRes;
  SdOverviewRes? get overviewRes => _overviewRes;

  void setStatusOverview(status) {
    _statusOverview = status;
    notifyListeners();
  }

  Future getOverviewData({
    String? symbol,
    pointsDeducted,
  }) async {
    setStatusOverview(Status.loading);
    try {
      // Map request = {
      //   "token":
      //       navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      //   "symbol": symbol ?? "",
      // };

      Map request = pointsDeducted != null
          ? {
              "token": navigatorKey.currentContext!
                      .read<UserProvider>()
                      .user
                      ?.token ??
                  "",
              "symbol": symbol ?? "",
              "point_deduction": "$pointsDeducted",
            }
          : {
              "token": navigatorKey.currentContext!
                      .read<UserProvider>()
                      .user
                      ?.token ??
                  "",
              "symbol": symbol ?? "",
            };

      ApiResponse response = await apiRequest(
        url: Apis.detailOverview,
        request: request,
        showProgress: false,
        removeForceLogin: true,
      );

      if (response.status) {
        _overviewRes = sdOverviewResFromJson(jsonEncode(response.data));
        _extraOverview =
            (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _overviewRes = null;
        _errorOverview = response.message;
      }
      setStatusOverview(Status.loaded);
    } catch (e) {
      _overviewRes = null;
      Utils().showLog(e.toString());
      _errorOverview = Const.errSomethingWrong;
      setStatusOverview(Status.loaded);
    }
  }

//---------------------------------------------------------------
//Overview Graph DATA
  String? _errorGraph;
  String? get errorGraph => _errorGraph ?? Const.errSomethingWrong;

  Status _statusGraph = Status.ideal;
  Status get statusGraph => _statusGraph;

  bool get isLoadingGraph => _statusGraph == Status.loading;

  Extra? _extraGraph;
  Extra? get extraGraph => _extraGraph;

  List<SdOverviewGraphRes>? _graphChart;
  List<SdOverviewGraphRes>? get graphChart => _graphChart;

  void setStatusOverviewG(status) {
    _statusGraph = status;
    notifyListeners();
  }

  LineChartData avgData({bool showDate = true}) {
    List<SdOverviewGraphRes> reversedData =
        _graphChart?.reversed.toList() ?? [];

    List<FlSpot> spots = [];

    for (int i = 0; i < reversedData.length; i++) {
      spots.add(FlSpot(i.toDouble(), reversedData[i].close.toDouble()));
    }

    return LineChartData(
      lineTouchData: LineTouchData(
        getTouchLineEnd: (barData, spotIndex) {
          return double.infinity;
        },
        getTouchLineStart: (barData, spotIndex) {
          return 0.0;
        },
        getTouchedSpotIndicator: (barData, spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(
                // color: Colors.grey[400],
                color: spots.first.y > spots.last.y
                    ? ThemeColors.sos
                    : ThemeColors.accent,
                strokeWidth: 1,
                dashArray: [5, 0],
              ),
              FlDotData(
                show: true,
                checkToShowDot: (spot, barData) {
                  return true;
                },
              ),
            );
          }).toList();
        },
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipHorizontalOffset: 0,
          tooltipRoundedRadius: 4.0,
          showOnTopOfTheChartBoxArea: true,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          maxContentWidth: 300,
          tooltipPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          tooltipMargin: 1,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map(
              (LineBarSpot touchedSpot) {
                return LineTooltipItem(
                  children: [
                    TextSpan(
                      text: "\$${touchedSpot.y.toStringAsFixed(2)}\n",
                      style: stylePTSansRegular(
                        color: ThemeColors.white,
                        fontSize: 18,
                      ),
                    ),
                    TextSpan(
                      text: !showDate
                          ? DateFormat('dd MMM, yyyy')
                              .format(reversedData[touchedSpot.x.toInt()].date)
                          : '${DateFormat('dd MMM').format(reversedData[touchedSpot.x.toInt()].date)}, ${DateFormat('h:mm a').format(reversedData[touchedSpot.x.toInt()].date)}',
                      style: stylePTSansRegular(
                          height: 1.5,
                          color: ThemeColors.greyText,
                          fontSize: 13),
                    ),
                  ],
                  '',
                  stylePTSansBold(color: ThemeColors.white, fontSize: 10),
                );
              },
            ).toList();
          },
          getTooltipColor: (touchedSpot) {
            return const Color.fromARGB(255, 25, 25, 25);
          },
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(
            sideTitles: SideTitles(
          showTitles: false,
        )),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(

            // axisNameWidget: Text(
            //   "Time",
            //   style: stylePTSansRegular(fontSize: 15),
            // ),
            sideTitles: SideTitles(
          showTitles: false,
          getTitlesWidget: (value, meta) {
            int index = value.toInt();
            if (index >= 0 && index < (spots.length)) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, left: 5),
                child: Text(
                  DateFormat('HH:mm').format(reversedData[index].date),
                  style: stylePTSansRegular(fontSize: 8),
                ),
              );
            }
            return Text(
              "-",
              style: stylePTSansRegular(fontSize: 10),
            );
          },
        )),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 32,
            showTitles: false,
            getTitlesWidget: (double value, TitleMeta meta) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 5),
                child: Text(
                  value.toStringAsFixed(2),
                  style: stylePTSansRegular(fontSize: 8),
                ),
              );
            },
          ),
        ),
      ),
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: ThemeColors.white.withOpacity(0.16),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: ThemeColors.white.withOpacity(0.16),
            strokeWidth: 1,
          );
        },
      ),
      minX: 0,
      maxX: reversedData.length.toDouble() - 1,
      minY: reversedData
          .map((data) => data.close.toDouble())
          .reduce((a, b) => a < b ? a : b),
      maxY: reversedData
          .map((data) => data.close.toDouble())
          .reduce((a, b) => a > b ? a : b),
      lineBarsData: [
        LineChartBarData(
          preventCurveOverShooting: true,

          spots: spots,
          // color: (_data?.keyStats?.previousCloseNUM ?? 0) > spots.last.y
          //     ? ThemeColors.sos
          //     : ThemeColors.accent,
          color: spots.first.y > spots.last.y
              ? ThemeColors.sos
              : ThemeColors.accent,

          // color: ThemeColors.accent,
          isCurved: true,
          barWidth: 1.5,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                // (_data?.keyStats?.previousCloseNUM ?? 0) > spots.last.y
                //     ? ThemeColors.sos.withOpacity(0.1)
                //     : ThemeColors.accent.withOpacity(0.1),
                spots.first.y > spots.last.y
                    ? ThemeColors.sos.withOpacity(0.1)
                    : ThemeColors.accent.withOpacity(0.1),

                // ThemeColors.accent.withOpacity(0.1),
                ThemeColors.background,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future getOverviewGraphData({
    String? symbol,
    String range = '1H',
    showProgress = false,
  }) async {
    setStatusOverviewG(Status.loading);
    try {
      String newRange = range == "1H"
          ? "1hour"
          : range == "1D"
              ? "1day"
              : range == "1W"
                  ? "1week"
                  : range == "1M"
                      ? "1month"
                      : range == "1Y"
                          ? "1year"
                          : "1hour";

      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
        "range": newRange,
      };

      ApiResponse response = await apiRequest(
        url: Apis.newsAlertGraphData,
        request: request,
        showProgress: showProgress,
        removeForceLogin: true,
      );

      if (response.status) {
        _graphChart = sdOverviewGraphResFromJson(jsonEncode(response.data));
        _extraGraph =
            (response.extra is Extra ? response.extra as Extra : null);

        avgData(showDate: newRange != "1Y");
      } else {
        _graphChart = null;
        _errorGraph = response.message;
      }
      setStatusOverviewG(Status.loaded);
    } catch (e) {
      _graphChart = null;
      Utils().showLog(e.toString());
      _errorGraph = Const.errSomethingWrong;
      setStatusOverviewG(Status.loaded);
    }
  }

//---------------------------------------------------------------
  // Ownership

  String? _errorOwnership;
  String? get errorOwnership => _errorOwnership ?? Const.errSomethingWrong;

  Status _statusOwnership = Status.ideal;
  Status get statusOwnership => _statusOwnership;

  bool get isLoadingOwnership => _statusOwnership == Status.loading;

  Extra? _extraOwnership;
  Extra? get extraOwnership => _extraOwnership;

  SdOwnershipRes? _ownershipRes;
  SdOwnershipRes? get ownershipRes => _ownershipRes;

  void setStatusOwnership(status) {
    _statusOwnership = status;
    notifyListeners();
  }

  Future getOwnershipData({String? symbol}) async {
    setStatusOwnership(Status.loading);
    try {
      Map request = {
        "symbol": symbol ?? "",
        'sort': "ownership",
        'direction': "desc",
      };

      ApiResponse response = await apiRequest(
        url: Apis.detailOwnership,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _ownershipRes = sdOwnershipResFromJson(jsonEncode(response.data));
        _extraOwnership =
            (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _ownershipRes = null;
        _errorOwnership = response.message;
      }
      setStatusOwnership(Status.loaded);
    } catch (e) {
      // _ownershipRes = null;
      Utils().showLog(e.toString());
      _errorOwnership = Const.errSomethingWrong;
      setStatusOwnership(Status.loaded);
    }
  }

//---------------------------------------------------------------
  // Competitor

  String? _errorCompetitor;
  String? get errorCompetitor => _errorCompetitor ?? Const.errSomethingWrong;

  Status _statusCompetitor = Status.ideal;
  Status get statusCompetitor => _statusCompetitor;

  bool get isLoadingCompetitor => _statusCompetitor == Status.loading;

  Extra? _extraCompetitor;
  Extra? get extraCompetitor => _extraCompetitor;

  SdCompetitorRes? _competitorRes;
  SdCompetitorRes? get competitorRes => _competitorRes;

  void setStatusCompetitor(status) {
    _statusCompetitor = status;
    notifyListeners();
  }

  Future getCompetitorData({String? symbol}) async {
    setStatusCompetitor(Status.loading);
    try {
      Map request = {"symbol": symbol ?? ""};
      ApiResponse response = await apiRequest(
        url: Apis.detailCompetitor,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _competitorRes = sdCompetitorResFromJson(jsonEncode(response.data));
        _extraCompetitor =
            (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _competitorRes = null;
        _errorCompetitor = response.message;
      }
      setStatusCompetitor(Status.loaded);
    } catch (e) {
      Utils().showLog(e.toString());
      _errorCompetitor = Const.errSomethingWrong;
      setStatusCompetitor(Status.loaded);
    }
  }

//---------------------------------------------------------------
//News DATA
  String? _errorNews;
  String? get errorNews => _errorNews ?? Const.errSomethingWrong;

  Status _statusNews = Status.ideal;
  Status get statusNews => _statusNews;

  bool get isLoadingNews => _statusNews == Status.loading;

  Extra? _extraNews;
  Extra? get extraNews => _extraNews;

  SdNewsRes? _newsRes;
  SdNewsRes? get newsRes => _newsRes;

  void setStatusNews(status) {
    _statusNews = status;
    notifyListeners();
  }

  Future getNewsData({
    String? symbol,
  }) async {
    setStatusNews(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.stockDetailNews,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _newsRes = sdNewsResFromJson(jsonEncode(response.data));
      } else {
        _newsRes = null;
        _errorNews = response.message;
      }
      setStatusNews(Status.loaded);
    } catch (e) {
      _newsRes = null;
      Utils().showLog(e.toString());
      _errorNews = Const.errSomethingWrong;
      setStatusNews(Status.loaded);
    }
  }

//---------------------------------------------------------------
//News DATA New
  String? _errorNewsN;
  String? get errorNewsN => _errorNewsN ?? Const.errSomethingWrong;

  Status _statusNewsN = Status.ideal;
  Status get statusNewsN => _statusNewsN;

  bool get isLoadingNewsN => _statusNewsN == Status.loading;

  Extra? _extraNewsN;
  Extra? get extraNewsN => _extraNewsN;

  SdNewsRes? _newsResN;
  SdNewsRes? get newsResN => _newsResN;

  num? value;

  List<String> range = ['1D', '7D', '15D', '30D'];
  int selectedIndex = 0;

  void setStatusNewsN(status) {
    _statusNewsN = status;
    notifyListeners();
  }

  void onGaugeChange({
    String day = "1D",
    String? symbol,
    int? index,
  }) {
    selectedIndex = index ?? 0;
    notifyListeners();
    getNewsDataN(
      symbol: symbol,
      changingDay: true,
      day: day,
    );
  }

  Future getNewsDataN({
    String? symbol,
    String day = "1D",
    bool changingDay = false,
  }) async {
    if (!changingDay) {
      selectedIndex = 0;
    }
    if (!changingDay) setStatusNewsN(Status.loading);
    notifyListeners();

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol ?? "",
        "day": day == "1D"
            ? "1"
            : day == "7D"
                ? "7"
                : day == "15D"
                    ? "15"
                    : "30",
        "full_data": changingDay ? "0" : "1"
      };

      ApiResponse response = await apiRequest(
        url: Apis.stockDetailNewsV2,
        request: request,
        showProgress: changingDay,
      );

      if (response.status) {
        if (!changingDay) {
          _newsResN = sdNewsResFromJson(jsonEncode(response.data));
        }
        value = sdNewsResFromJson(jsonEncode(response.data)).sentimentsPer;
      } else {
        _newsResN = null;
        _errorNewsN = response.message;
        value = 0;
      }
      if (!changingDay) setStatusNewsN(Status.loaded);
      notifyListeners();
    } catch (e) {
      _newsResN = null;
      value = 0;

      Utils().showLog(e.toString());
      _errorNewsN = Const.errSomethingWrong;
      if (!changingDay) setStatusNewsN(Status.loaded);
      notifyListeners();
    }
  }

  //---------------------------------------------------------------
//Social Activities DATA
  String? _errorSocial;
  String? get errorSocial => _errorSocial ?? Const.errSomethingWrong;

  Status _statusSocial = Status.ideal;
  Status get statusSocial => _statusSocial;

  bool get isLoadingSocial => _statusSocial == Status.loading;

  Extra? _extraSocial;
  Extra? get extraSocial => _extraSocial;

  SdSocialRes? _socialRes;
  SdSocialRes? get socialRes => _socialRes;

  void setStatusSocial(status) {
    _statusSocial = status;
    notifyListeners();
  }

  Future getSocialData({
    String? symbol,
  }) async {
    setStatusSocial(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.stockDetailSocial,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _socialRes = sdSocialResFromJson(jsonEncode(response.data));
        _extraSocial =
            (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _socialRes = null;
        _errorSocial = response.message;
      }
      setStatusSocial(Status.loaded);
    } catch (e) {
      _socialRes = null;
      Utils().showLog(e.toString());
      _errorSocial = Const.errSomethingWrong;
      setStatusSocial(Status.loaded);
    }
  }

  //---------------------------------------------------------------
//Insider Trade
  String? _errorInsiderTrade;
  String? get errorInsiderTrade =>
      _errorInsiderTrade ?? Const.errSomethingWrong;

  Status _statusInsiderTrade = Status.ideal;
  Status get statusInsiderTrade => _statusInsiderTrade;

  bool get isLoadingInsiderTrade => _statusInsiderTrade == Status.loading;

  Extra? _extraInsiderTrade;
  Extra? get extraInsiderTrade => _extraInsiderTrade;

  SdInsiderTradeRes? _sdInsiderTradeRes;
  SdInsiderTradeRes? get sdInsiderTradeRes => _sdInsiderTradeRes;

  void setStatusInsiderTrade(status) {
    _statusInsiderTrade = status;
    notifyListeners();
  }

  Future getInsiderTradeData({
    String? symbol,
  }) async {
    setStatusInsiderTrade(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.stockDetailInsider,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _sdInsiderTradeRes =
            sdInsiderTradeResFromJson(jsonEncode(response.data));
        _extraInsiderTrade =
            (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _sdInsiderTradeRes = null;
        _errorInsiderTrade = response.message;
      }
      setStatusInsiderTrade(Status.loaded);
    } catch (e) {
      _sdInsiderTradeRes = null;
      Utils().showLog(e.toString());
      _errorInsiderTrade = Const.errSomethingWrong;
      setStatusInsiderTrade(Status.loaded);
    }
  }

  //---------------------------------------------------------------
//Financial data
  String? _errorFinancial;
  String? get errorFinancial => _errorFinancial ?? Const.errSomethingWrong;

  Status _statusFinancial = Status.ideal;
  Status get statusFinancial => _statusFinancial;

  bool get isLoadingFinancial => _statusFinancial == Status.loading;

  Status _statusFinancialTab = Status.ideal;
  Status get statusFinancialTab => _statusFinancialTab;

  bool get isLoadingFinancialTab => _statusFinancialTab == Status.loading;

  Extra? _extraFinancial;
  Extra? get extraFinancial => _extraFinancial;

  List<dynamic>? _sdFinancialArray;
  List<dynamic>? get sdFinancialArray => _sdFinancialArray;

  List<dynamic>? _sdFinancialArrayTableIncome;
  List<dynamic>? get sdFinancialArrayTableIncome =>
      _sdFinancialArrayTableIncome;
  List<dynamic>? _sdFinancialArrayTableFinancial;
  List<dynamic>? get sdFinancialArrayTableFinancial =>
      _sdFinancialArrayTableFinancial;
  List<dynamic>? _sdFinancialArrayTableCash;
  List<dynamic>? get sdFinancialArrayTableCash => _sdFinancialArrayTableCash;

  SdFinancialRes? _sdFinancialChartRes;
  SdFinancialRes? get sdFinancialChartRes => _sdFinancialChartRes;
  SdFinancialRes? _incomeSdFinancialChartRes;
  SdFinancialRes? get incomeSdFinancialChartRes => _incomeSdFinancialChartRes;
  SdFinancialRes? _balanceSdFinancialChartRes;
  SdFinancialRes? get balanceSdFinancialChartRes => _balanceSdFinancialChartRes;
  SdFinancialRes? _cashSdFinancialChartRes;
  SdFinancialRes? get cashSdFinancialChartRes => _cashSdFinancialChartRes;

  String _changeTabAreaValue = "1";
  String get changeTabAreaValue => _changeTabAreaValue;

  int _openIndexInsider = -1;
  int get openIndexInsider => _openIndexInsider;

  void setOpenIndexInsider(index) {
    _openIndexInsider = index;
    notifyListeners();
  }

  List<SdTopRes>? _types;
  List<SdTopRes>? get types => _types;

  List<SdTopRes>? _periods;
  List<SdTopRes>? get periods => _periods;

  int typeIndex = 0;
  int periodIndex = 0;

  String? _typeValue;
  String? get typeValue => _typeValue;

  String? _typePeriods;
  String? get typePeriods => _typePeriods;

  int changePeriodTypeIndex = 0;

  List<Chart>? _areaIncomeChart;
  List<Chart>? get areaIncomeChart => _areaIncomeChart;

  List<Chart>? _areaIncomeChartBalance;
  List<Chart>? get areaIncomeChartBalance => _areaIncomeChartBalance;

  String _changeTabAreaValueBalance = "1";
  String get changeTabAreaValueBalance => _changeTabAreaValueBalance;

  List<Chart>? _areaIncomeChartCashFlow;
  List<Chart>? get areaIncomeChartCashFlow => _areaIncomeChartCashFlow;

  String _changeTabAreaValueCashFlow = "1";
  String get changeTabAreaValueCashFlow => _changeTabAreaValueCashFlow;

  void changeTabType(index, {String? symbol}) {
    if (typeIndex != index) {
      typeIndex = index;
      notifyListeners();
      getFinancialData(
        symbol: symbol,
        period: _periods?[periodIndex].value,
        type: _types?[typeIndex].value,
        tabProgress: true,
      );
    }
  }

  void changeTabAreaIncomeSix(value, data) {
    _changeTabAreaValue = value;
    if (data == null) return;
    _areaIncomeChart = data?.sublist(0, 6);
    Utils().showLog('Error initializing Firebase: $data');
    notifyListeners();
  }

  void changeTabAreaIncomeTen(value, data) {
    _changeTabAreaValue = value;
    if (data == null) return;
    _areaIncomeChart = data?.sublist(0, 10);
    Utils().showLog('Error initializing Firebase: $data');
    notifyListeners();
  }

  void changeTabAreaIncomeTenInt(value, data) {
    _changeTabAreaValue = value;
    if (data == null) return;
    _areaIncomeChart = data;
    Utils().showLog('Error initializing Firebase: $data');
    notifyListeners();
  }

  void changeTabAreaBalanceSix(value, data) {
    _changeTabAreaValueBalance = value;
    if (data == null) return;
    _areaIncomeChartBalance = data?.sublist(0, 6);
    Utils().showLog('Error initializing Firebase: $data');
    notifyListeners();
  }

  void changeTabAreaBalanceTen(value, data) {
    _changeTabAreaValueBalance = value;
    if (data == null) return;
    _areaIncomeChartBalance = data?.sublist(0, 10);
    Utils().showLog('Error initializing Firebase: $data');
    notifyListeners();
  }

  void changeTabAreaBalanceTenInt(value, data) {
    _changeTabAreaValueBalance = value;
    if (data == null) return;
    _areaIncomeChartBalance = data;
    Utils().showLog('Error initializing Firebase: $data');
    notifyListeners();
  }

  void changeTabAreaCashFlowSix(value, data) {
    _changeTabAreaValueCashFlow = value;
    if (data == null) return;
    _areaIncomeChartCashFlow = data?.sublist(0, 6);
    Utils().showLog('Error initializing Firebase: $data');
    notifyListeners();
  }

  void changeTabAreaCashFlowTen(value, data) {
    _changeTabAreaValueCashFlow = value;
    if (data == null) return;
    _areaIncomeChartCashFlow = data?.sublist(0, 10);
    Utils().showLog('Error initializing Firebase: $data');
    notifyListeners();
  }

  void changeTabAreaCashFlowTenInt(value, data) {
    _changeTabAreaValueCashFlow = value;
    if (data == null) return;
    _areaIncomeChartCashFlow = data;
    Utils().showLog('Error initializing Firebase: $data');
    notifyListeners();
  }

  void changeTabTypeChartData(index, {String? symbol}) {
    if (typeIndex != index) {
      typeIndex = index;
      vibrateTabFinancial();
      Utils().showLog("index  $index");
      if (index == 0 && incomeSdFinancialChartRes == null) {
        notifyListeners();
        getFinancialData(
          symbol: symbol,
          period: _periods?[periodIndex].value,
          type: _types?[typeIndex].value,
          tabProgress: true,
        );
      }
      if (index == 1 && balanceSdFinancialChartRes == null) {
        notifyListeners();
        getFinancialData(
          symbol: symbol,
          period: _periods?[periodIndex].value,
          type: _types?[typeIndex].value,
          tabProgress: true,
        );
      }
      if (index == 2 && cashSdFinancialChartRes == null) {
        notifyListeners();
        getFinancialData(
          symbol: symbol,
          period: _periods?[periodIndex].value,
          type: _types?[typeIndex].value,
          tabProgress: true,
        );
      }
      if (index == 0 && incomeSdFinancialChartRes != null) {
        _typeValue = "income-statement";
        _sdFinancialChartRes = incomeSdFinancialChartRes;
        _sdFinancialArray = _sdFinancialArrayTableIncome;
      }
      if (index == 1 && balanceSdFinancialChartRes != null) {
        _typeValue = 'balance-sheet-statement';
        _sdFinancialChartRes = balanceSdFinancialChartRes;
        _sdFinancialArray = _sdFinancialArrayTableFinancial;
      }
      if (index == 2 && cashSdFinancialChartRes != null) {
        _typeValue = 'cash-flow-statement';
        _sdFinancialChartRes = cashSdFinancialChartRes;
        _sdFinancialArray = _sdFinancialArrayTableCash;
      }

      notifyListeners();
    }
  }

  void vibrateTabFinancial() async {
    try {
      if (Platform.isAndroid) {
        bool isVibe = await Vibration.hasVibrator() ?? false;
        if (isVibe) {
          Vibration.vibrate(pattern: [50, 50, 79, 55], intensities: [1, 10]);
        }
      } else {
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      //
    }
  }

  void changePeriodType(index, {String? symbol}) {
    if (periodIndex != index) {
      periodIndex = index;
      vibrateTabFinancial();
      _incomeSdFinancialChartRes = null;
      _sdFinancialArrayTableIncome = null;
      _balanceSdFinancialChartRes = null;
      _sdFinancialArrayTableFinancial = null;
      _cashSdFinancialChartRes = null;
      _sdFinancialArrayTableCash = null;
      notifyListeners();
      getFinancialData(
        symbol: symbol,
        period: _periods?[periodIndex].value,
        type: _types?[typeIndex].value,
        tabProgress: true,
      );
    }
  }

  void changePeriodTypeIndexVoid(index) {
    if (changePeriodTypeIndex != index) {
      vibrateTabFinancial();

      changePeriodTypeIndex = index;
      notifyListeners();
    }
  }

  void setStatusFinancial(status) {
    _statusFinancial = status;
    notifyListeners();
  }

  void setStatusFinancialTab(status) {
    _statusFinancialTab = status;
    notifyListeners();
  }

  Future getFinancialData({
    String? symbol,
    String period = "annual",
    String type = "income-statement",
    bool reset = false,
    bool showProgress = false,
    bool tabProgress = false,
  }) async {
    _sdFinancialChartRes = null;
    _typeValue = null;
    notifyListeners();
    if (reset) {
      _incomeSdFinancialChartRes = null;
      _sdFinancialArrayTableIncome = null;
      _balanceSdFinancialChartRes = null;
      _sdFinancialArrayTableFinancial = null;
      _cashSdFinancialChartRes = null;
      _sdFinancialArrayTableCash = null;

      typeIndex = 0;
      periodIndex = 0;
      notifyListeners();
    }
    if (tabProgress) {
      setStatusFinancialTab(Status.loading);
    } else {
      setStatusFinancial(Status.loading);
    }
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol ?? "",
        "period": period,
        "type": type,
      };

      ApiResponse response = await apiRequest(
        url: Apis.detailFinancial,
        request: request,
        showProgress: tabProgress,
      );

      if (response.status) {
        _typePeriods = period.toString();
        _typeValue = type;
        _sdFinancialChartRes =
            sdFinancialResFromJson(jsonEncode(response.data));

        if (type == "income-statement") {
          _incomeSdFinancialChartRes =
              sdFinancialResFromJson(jsonEncode(response.data));
          _sdFinancialArrayTableIncome = response.data['finance_statement'];
        } else if (type == "balance-sheet-statement") {
          _balanceSdFinancialChartRes =
              sdFinancialResFromJson(jsonEncode(response.data));
          _sdFinancialArrayTableFinancial = response.data['finance_statement'];
        } else if (type == "cash-flow-statement") {
          _cashSdFinancialChartRes =
              sdFinancialResFromJson(jsonEncode(response.data));
          _sdFinancialArrayTableCash = response.data['finance_statement'];
        }

        // _sdFinancialChartRes?.chart?.sublist(0, 5);

        // List<dynamic> financeStatementData = response.data['finance_statement'];

        // for (var item in financeStatementData) {
        //   if (item is Map<String, dynamic>) {
        //     _sdFinancialMap?.addAll(item);
        //   }
        // }

        List<dynamic> financeStatementData = response.data['finance_statement'];

        // Save the array directly for later processing
        _sdFinancialArray = financeStatementData;

        _extraFinancial =
            (response.extra is Extra ? response.extra as Extra : null);
      } else {
        // _sdFinancialRes = null;
        _sdFinancialArray = null;

        _errorFinancial = response.message;
      }

      _types = _extraFinancial?.type;
      _periods = _extraFinancial?.period;

      if (tabProgress) {
        setStatusFinancialTab(Status.loaded);
      } else {
        setStatusFinancial(Status.loaded);
      }
    } catch (e) {
      _sdFinancialArray = null;
      Utils().showLog(e.toString());
      _errorFinancial = Const.errSomethingWrong;
      if (tabProgress) {
        setStatusFinancialTab(Status.loaded);
      } else {
        setStatusFinancial(Status.loaded);
      }
    }
  }

  //Mergers DATA
  String? _errorMergers;
  String? get errorMergers => _errorMergers ?? Const.errSomethingWrong;

  Status _statusMergers = Status.ideal;
  Status get statusMergers => _statusMergers;

  bool get isLoadingMergers => _statusMergers == Status.loading;

  Extra? _extraMergers;
  Extra? get extraMergers => _extraMergers;

  SdMergersRes? _sdMergersRes;
  SdMergersRes? get sdMergersRes => _sdMergersRes;

  void setStatusMergers(status) {
    _statusMergers = status;
    notifyListeners();
  }

  Future getMergersData({
    String? symbol,
  }) async {
    setStatusMergers(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.stockDetailMergers,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _sdMergersRes = sdMergersResFromJson(jsonEncode(response.data));
        _extraMergers =
            (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _sdMergersRes = null;
        _errorMergers = response.message;
      }
      setStatusMergers(Status.loaded);
    } catch (e) {
      _sdMergersRes = null;
      Utils().showLog(e.toString());
      _errorMergers = Const.errSomethingWrong;
      setStatusMergers(Status.loaded);
    }
  }
}

class FinancialHolder {
  String? type;
  List<dynamic>? data;
  SdFinancialRes? financialRes;

  FinancialHolder({
    this.type,
    this.data,
    this.financialRes,
  });
}

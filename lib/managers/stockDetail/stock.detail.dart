import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/models/stockDetail/key_stats.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../../api/api_requester.dart';
import '../../api/api_response.dart';
import '../../api/apis.dart';
import '../../models/stockDetail/analyst_forecast.dart';
import '../../models/stockDetail/earning.dart';
import '../../models/stockDetail/historical_chart.dart';
import '../../models/stockDetail/news.dart';
import '../../models/stockDetail/overview.dart';
import '../../models/stockDetail/stock_analysis.dart';
import '../../models/stockDetail/tabs.dart';
import '../../routes/my_app.dart';
import '../../utils/constants.dart';
import '../user.dart';

class SDManager extends ChangeNotifier {
//MARK: Clear All
  clearAllData() {
    _data = null;
    _selectedIndex = -1;
    _selectedStock = null;
    _dataOverview = null;
    _dataHistoricalC = null;
    _dataKeyStats = null;
    _dataStocksAnalysis = null;
    _dataAnalystForecast = null;
    _openAnalystForecast = -1;
    _dataEarnings = null;
    _openEarnings = -1;
    notifyListeners();
  }

  //MARK: Stock Detail Tab
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading;

  SDRes? _data;
  SDRes? get data => _data;

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;

  MarketResData? _selectedTab;
  MarketResData? get selectedTab => _selectedTab;

  String? _selectedStock;
  String? get selectedStock => _selectedStock;

//MARK: Common TabChange
  onTabChange(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      _selectedTab = _data?.tabs?[index];
      notifyListeners();

      switch (index) {
        case 0:
          if (_dataOverview == null) {
            getSDOverview();
          }
          if (_dataHistoricalC == null) {
            getSDHistoricalC();
          }
          break;

        case 1:
          if (_dataKeyStats == null) {
            getSDKeyStats();
          }
          break;

        case 2:
          if (_dataStocksAnalysis == null) {
            getSDStocksAnalysis();
          }
          break;

        case 4:
          if (_dataAnalystForecast == null) {
            getSDAnalystForecast();
          }
          break;

        case 5:
          if (_dataLatestNews == null) {
            getSDLatestNews();
          }
          break;

        case 6:
          if (_dataEarnings == null) {
            getSDEarnings();
          }
          break;

        default:
      }
    }
  }

//MARK: Common Refresh
  Future onSelectedTabRefresh() async {
    switch (_selectedIndex) {
      case 0:
        getSDOverview(reset: true);
        getSDHistoricalC(reset: true);
        break;

      case 1:
        getSDKeyStats(reset: true);
        break;

      case 2:
        getSDStocksAnalysis(reset: true);
        break;

      case 4:
        getSDAnalystForecast(reset: true);
        break;

      case 5:
        getSDLatestNews(reset: true);
        break;

      case 6:
        getSDEarnings(reset: true);
        break;

      default:
    }
  }

  Future getSDTab(String symbol) async {
    clearAllData();
    _selectedStock = symbol;
    if (symbol == '') return;
    try {
      setStatus(Status.loading);
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': symbol,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sdTab,
        request: request,
      );
      if (response.status) {
        _data = stocksDetailResFromJson(jsonEncode(response.data));
        onTabChange(0);
        _error = null;
      } else {
        _data = null;
        _error = response.message;
      }
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.sdTab}: $e');
    } finally {
      setStatus(Status.loaded);
    }
  }

  //MARK: Stock Overview
  String? _errorOverview;
  String? get errorOverview => _errorOverview ?? Const.errSomethingWrong;

  Status _statusOverview = Status.ideal;
  Status get statusOverview => _statusOverview;

  bool get isLoadingOverview => _statusOverview == Status.loading;

  SDOverviewRes? _dataOverview;
  SDOverviewRes? get dataOverview => _dataOverview;

  setStatusOverview(status) {
    _statusOverview = status;
    notifyListeners();
  }

  Future getSDOverview({bool reset = false}) async {
    if (_selectedStock == '') return;
    if (reset) _dataOverview = null;

    try {
      setStatusOverview(Status.loading);
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _selectedStock,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sdOverview,
        request: request,
      );
      if (response.status) {
        _dataOverview =
            stocksDetailOverviewResFromJson(jsonEncode(response.data));
        _errorOverview = null;
      } else {
        _dataOverview = null;
        _errorOverview = response.message;
      }
    } catch (e) {
      _dataOverview = null;
      _errorOverview = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.sdOverview}: $e');
    } finally {
      setStatusOverview(Status.loaded);
    }
  }

  //MARK: Stock Historical
  String? _errorHistoricalC;
  String? get errorHistoricalC => _errorHistoricalC ?? Const.errSomethingWrong;

  Status _statusHistoricalC = Status.ideal;
  Status get statusHistoricalC => _statusHistoricalC;

  bool get isLoadingHistoricalC => _statusHistoricalC == Status.loading;

  SDHistoricalChartRes? _dataHistoricalC;
  SDHistoricalChartRes? get dataHistoricalC => _dataHistoricalC;

  setStatusHistoricalC(status) {
    _statusHistoricalC = status;
    notifyListeners();
  }

  Future getSDHistoricalC({String range = '1hour', bool reset = false}) async {
    if (_selectedStock == '') return;
    if (reset) _dataHistoricalC = null;

    try {
      setStatusHistoricalC(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _selectedStock,
        'range': range,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sdHistoricalC,
        request: request,
        showProgress: _dataHistoricalC != null,
      );
      if (response.status) {
        _dataHistoricalC =
            stocksDetailHistoricalChartResFromJson(jsonEncode(response.data));
        _errorHistoricalC = null;
      } else {
        _dataHistoricalC = null;
        _errorHistoricalC = response.message;
      }
    } catch (e) {
      _dataHistoricalC = null;
      _errorHistoricalC = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.sdHistoricalC}: $e');
    } finally {
      setStatusHistoricalC(Status.loaded);
    }
  }

  //MARK: Stock KeyStats
  String? _errorKeyStats;
  String? get errorKeyStats => _errorKeyStats ?? Const.errSomethingWrong;

  Status _statusKeyStats = Status.ideal;
  Status get statusKeyStats => _statusKeyStats;

  bool get isLoadingKeyStats => _statusKeyStats == Status.loading;

  SdKeyStatsRes? _dataKeyStats;
  SdKeyStatsRes? get dataKeyStats => _dataKeyStats;

  setStatusKeyStats(status) {
    _statusKeyStats = status;
    notifyListeners();
  }

  Future getSDKeyStats({bool reset = false}) async {
    if (_selectedStock == '') return;
    if (reset) _dataKeyStats = null;

    try {
      setStatusKeyStats(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _selectedStock,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sdKeyStats,
        request: request,
      );
      if (response.status) {
        _dataKeyStats = sdKeyStatsResFromJson(jsonEncode(response.data));
        _errorKeyStats = null;
      } else {
        _errorKeyStats = response.message;
        _dataKeyStats = null;
      }
    } catch (e) {
      _errorKeyStats = Const.errSomethingWrong;
      _dataKeyStats = null;
      Utils().showLog('Error in ${Apis.sdKeyStats}: $e');
    } finally {
      setStatusKeyStats(Status.loaded);
    }
  }

  //MARK: Stock Analysis
  String? _errorStocksAnalysis;
  String? get errorStocksAnalysis =>
      _errorStocksAnalysis ?? Const.errSomethingWrong;

  Status _statusStocksAnalysis = Status.ideal;
  Status get statusStocksAnalysis => _statusStocksAnalysis;

  bool get isLoadingStocksAnalysis => _statusStocksAnalysis == Status.loading;

  SDStocksAnalysisRes? _dataStocksAnalysis;
  SDStocksAnalysisRes? get dataStocksAnalysis => _dataStocksAnalysis;

  setStatusStocksAnalysis(status) {
    _statusStocksAnalysis = status;
    notifyListeners();
  }

  Future getSDStocksAnalysis({bool reset = false}) async {
    if (_selectedStock == '') return;
    if (reset) _dataStocksAnalysis = null;

    try {
      setStatusStocksAnalysis(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _selectedStock,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sdStocksAnalysis,
        request: request,
      );
      if (response.status) {
        _dataStocksAnalysis =
            sdStocksAnalysisResFromJson(jsonEncode(response.data));
        _errorStocksAnalysis = null;
      } else {
        _errorStocksAnalysis = response.message;
        _dataStocksAnalysis = null;
      }
    } catch (e) {
      _errorStocksAnalysis = Const.errSomethingWrong;
      _dataStocksAnalysis = null;
      Utils().showLog('Error in ${Apis.sdStocksAnalysis}: $e');
    } finally {
      setStatusStocksAnalysis(Status.loaded);
    }
  }

  //MARK: Analyst ForeCast
  String? _errorAnalystForecast;
  String? get errorAnalystForecast =>
      _errorAnalystForecast ?? Const.errSomethingWrong;

  Status _statusAnalystForecast = Status.ideal;
  Status get statusAnalystForecast => _statusAnalystForecast;

  bool get isLoadingAnalystForecast => _statusAnalystForecast == Status.loading;

  SDAnalystForecastRes? _dataAnalystForecast;
  SDAnalystForecastRes? get dataAnalystForecast => _dataAnalystForecast;

  int _openAnalystForecast = -1;
  int get openAnalystForecast => _openAnalystForecast;

  openAnalystForecastIndex(index) {
    _openAnalystForecast = index;
    notifyListeners();
  }

  setStatusAnalystForecast(status) {
    _statusAnalystForecast = status;
    notifyListeners();
  }

  Future getSDAnalystForecast({bool reset = false}) async {
    if (_selectedStock == '') return;
    if (reset) {
      _dataAnalystForecast = null;
      _openAnalystForecast = -1;
    }

    try {
      setStatusAnalystForecast(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _selectedStock,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sdAnalystForecast,
        request: request,
      );
      if (response.status) {
        _dataAnalystForecast = sdAnalysisResFromJson(jsonEncode(response.data));
        _errorAnalystForecast = null;
      } else {
        _dataAnalystForecast = null;
        _errorAnalystForecast = response.message;
      }
    } catch (e) {
      _dataAnalystForecast = null;
      _errorAnalystForecast = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.sdAnalystForecast}: $e');
    } finally {
      setStatusAnalystForecast(Status.loaded);
    }
  }

  //MARK: Latest News
  String? _errorLatestNews;
  String? get errorLatestNews => _errorLatestNews ?? Const.errSomethingWrong;

  Status _statusLatestNews = Status.ideal;
  Status get statusLatestNews => _statusLatestNews;

  bool get isLoadingLatestNews => _statusLatestNews == Status.loading;

  SDLatestNewsRes? _dataLatestNews;
  SDLatestNewsRes? get dataLatestNews => _dataLatestNews;

  setStatusLatestNews(status) {
    _statusLatestNews = status;
    notifyListeners();
  }

  Future getSDLatestNews(
      {bool reset = false, String day = '1', showProgress = false}) async {
    if (_selectedStock == '') return;
    if (reset) _dataLatestNews = null;

    try {
      setStatusLatestNews(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _selectedStock,
        'day': day,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sdLatestNews,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _dataLatestNews = sdLatestNewsFromJson(jsonEncode(response.data));
        _errorLatestNews = null;
      } else {
        _dataLatestNews = null;
        _errorLatestNews = response.message;
      }
    } catch (e) {
      _dataLatestNews = null;
      _errorLatestNews = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.sdLatestNews}: $e');
    } finally {
      setStatusLatestNews(Status.loaded);
    }
  }

  //MARK: Earnings
  String? _errorEarnings;
  String? get errorEarnings => _errorEarnings ?? Const.errSomethingWrong;

  Status _statusEarnings = Status.ideal;
  Status get statusEarnings => _statusEarnings;

  bool get isLoadingEarnings => _statusEarnings == Status.loading;

  SDEarningsRes? _dataEarnings;
  SDEarningsRes? get dataEarnings => _dataEarnings;

  setStatusEarnings(status) {
    _statusEarnings = status;
    notifyListeners();
  }

  int _openEarnings = -1;
  int get openEarnings => _openEarnings;

  openEarningsIndex(index) {
    _openEarnings = index;
    notifyListeners();
  }

  Future getSDEarnings({
    bool reset = false,
  }) async {
    if (_selectedStock == '') return;
    if (reset) {
      _dataEarnings = null;
      _openEarnings = -1;
    }
    try {
      setStatusEarnings(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _selectedStock,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sdEarnings,
        request: request,
      );
      if (response.status) {
        _dataEarnings = SDEarningsResFromJson(jsonEncode(response.data));
        _errorEarnings = null;
      } else {
        _dataEarnings = null;
        _errorEarnings = response.message;
      }
    } catch (e) {
      _dataEarnings = null;
      _errorEarnings = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.sdEarnings}: $e');
    } finally {
      setStatusEarnings(Status.loaded);
    }
  }
}

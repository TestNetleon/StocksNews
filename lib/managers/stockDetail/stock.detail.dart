import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/models/stockDetail/key_stats.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../api/api_requester.dart';
import '../../api/api_response.dart';
import '../../api/apis.dart';
import '../../models/stockDetail/analyst_forecast.dart';
import '../../models/stockDetail/chart.dart';
import '../../models/stockDetail/competitors.dart';
import '../../models/stockDetail/dividends.dart';
import '../../models/stockDetail/earning.dart';
import '../../models/stockDetail/historical_chart.dart';
import '../../models/stockDetail/insider_trades.dart';
import '../../models/stockDetail/mergers.dart';
import '../../models/stockDetail/news.dart';
import '../../models/stockDetail/overview.dart';
import '../../models/stockDetail/ownership.dart';
import '../../models/stockDetail/sec_filing.dart';
import '../../models/stockDetail/stock_analysis.dart';
import '../../models/stockDetail/tabs.dart';
import '../../models/stockDetail/technical_analysis.dart';
import '../../routes/my_app.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
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
    _dataTechnicalAnalysis = null;
    _dataStocksAnalysis = null;
    _dataAnalystForecast = null;
    _openAnalystForecast = -1;
    _dataEarnings = null;
    _openEarnings = -1;
    _dataDividends = null;
    _openDividends = -1;
    _dataInsiderTrade = null;
    _openInsiderTrades = -1;
    _dataCompetitors = null;
    _openCompetitors = -1;
    _dataFinancials = null;
    _dataSecFiling = null;
    _dataMergers = null;
    _openMergers = -1;
    _dataChart = null;
    _dataCHistorical = null;
    _dataOwnership = null;
    notifyListeners();
  }

  //MARK: Stock Detail Tab
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

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
    Utils().showLog('--Index--$index');
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

        case 3:
          if (_dataTechnicalAnalysis == null) {
            getSDTechnicalAnalysis();
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

        case 7:
          if (_dataDividends == null) {
            getSDDividends();
          }
          break;

        case 8:
          if (_dataInsiderTrade == null) {
            getSDInsiderTrades();
          }
          break;

        case 9:
          if (_dataCompetitors == null) {
            getSDCompetitors();
          }
          break;

        case 10:
          if (_dataOwnership == null) {
            getSDOwnership();
          }
          break;

        case 11:
          if (_dataChart == null) {
            getSDChart();
          }
          if (_dataCHistorical == null) {
            getSDCHistorical();
          }
          break;

        case 12:
          if (_dataFinancials == null) {
            getSDFinancials();
          }
          break;

        case 13:
          if (_dataSecFiling == null) {
            getSDSecFiling();
          }
          break;

        case 14:
          if (_dataMergers == null) {
            getSDMergers();
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

      case 3:
        getSDTechnicalAnalysis(reset: true);
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

      case 7:
        getSDDividends(reset: true);
        break;

      case 8:
        getSDInsiderTrades(reset: true);
        break;

      case 9:
        getSDCompetitors(reset: true);
        break;

      case 10:
        getSDOwnership(reset: true);
        break;

      case 11:
        getSDChart(reset: true);
        getSDCHistorical(reset: true);
        break;

      case 12:
        getSDFinancials(reset: true);
        break;

      case 13:
        getSDSecFiling(reset: true);
        break;

      case 14:
        getSDMergers(reset: true);
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

//MARK: Line Chart
  LineChartData avgData({
    bool showDate = true,
    required List<HistoricalChartRes> reversedData,
  }) {
    // List<HistoricalChartRes> reversedData =
    //     historicalChartData.reversed.toList();

    List<FlSpot> spots = [];

    for (int i = 0; i < reversedData.length; i++) {
      spots.add(FlSpot(i.toDouble(), reversedData[i].close.toDouble()));
    }

    return LineChartData(
      borderData: FlBorderData(show: false),
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
          // tooltipPadding:
          //     const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          // tooltipMargin: 1,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map(
              (LineBarSpot touchedSpot) {
                return LineTooltipItem(
                  children: [
                    TextSpan(
                      text: "\$${touchedSpot.y.toStringAsFixed(2)}\n",
                      style: styleBaseSemiBold(
                        fontSize: 18,
                      ),
                    ),
                    TextSpan(
                      text: !showDate
                          ? DateFormat('dd MMM, yyyy')
                              .format(reversedData[touchedSpot.x.toInt()].date)
                          : '${DateFormat('dd MMM').format(reversedData[touchedSpot.x.toInt()].date)}, ${DateFormat('h:mm a').format(reversedData[touchedSpot.x.toInt()].date)}',
                      style: styleBaseSemiBold(
                          height: 1.5,
                          color: ThemeColors.neutral20,
                          fontSize: 13),
                    ),
                  ],
                  '',
                  styleBaseSemiBold(color: ThemeColors.white, fontSize: 10),
                );
              },
            ).toList();
          },
          getTooltipColor: (touchedSpot) {
            return ThemeColors.neutral5;
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
            sideTitles: SideTitles(
          showTitles: false,
        )),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 32,
            showTitles: false,
          ),
        ),
      ),
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: ThemeColors.white,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: ThemeColors.white,
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
          color: spots.first.y > spots.last.y
              ? ThemeColors.sos
              : ThemeColors.accent,
          isCurved: true,
          barWidth: 2,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: spots.first.y > spots.last.y
                  ? [
                      const Color.fromRGBO(255, 99, 99, 0.18),
                      const Color.fromRGBO(255, 150, 150, 0.15),
                      const Color.fromRGBO(255, 255, 255, 0.0),
                    ]
                  : [
                      const Color.fromRGBO(71, 193, 137, 0.18),
                      const Color.fromRGBO(171, 227, 201, 0.15),
                      const Color.fromRGBO(255, 255, 255, 0.0),
                    ],
              stops: [0.0, 0.6, 4],
            ),
          ),
        ),
      ],
    );
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

  //MARK: Technical Analysis
  String? _errorTechnicalAnalysis;
  String? get errorTechnicalAnalysis =>
      _errorTechnicalAnalysis ?? Const.errSomethingWrong;

  Status _statusTechnicalAnalysis = Status.ideal;
  Status get statusTechnicalAnalysis => _statusTechnicalAnalysis;

  bool get isLoadingTechnicalAnalysis =>
      _statusTechnicalAnalysis == Status.loading;

  SDTechnicalAnalysisRes? _dataTechnicalAnalysis;
  SDTechnicalAnalysisRes? get dataTechnicalAnalysis => _dataTechnicalAnalysis;

  setStatusTechnicalAnalysis(status) {
    _statusTechnicalAnalysis = status;
    notifyListeners();
  }

  Future getSDTechnicalAnalysis({
    bool reset = false,
    String interval = '5min',
    bool showProgress = false,
  }) async {
    if (_selectedStock == '') return;
    if (reset) _dataTechnicalAnalysis = null;

    try {
      setStatusTechnicalAnalysis(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _selectedStock,
        'interval': interval,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sdTechnicalAnalysis,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _dataTechnicalAnalysis =
            SDTechnicalAnalysisResFromJson(jsonEncode(response.data));
        _errorTechnicalAnalysis = null;
      } else {
        _errorStocksAnalysis = response.message;
        _errorTechnicalAnalysis = null;
      }
    } catch (e) {
      _errorTechnicalAnalysis = Const.errSomethingWrong;
      _dataTechnicalAnalysis = null;
      Utils().showLog('Error in ${Apis.sdTechnicalAnalysis}: $e');
    } finally {
      setStatusTechnicalAnalysis(Status.loaded);
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

  //MARK: Dividends
  String? _errorDividends;
  String? get errorDividends => _errorDividends ?? Const.errSomethingWrong;

  Status _statusDividends = Status.ideal;
  Status get statusDividends => _statusDividends;

  bool get isLoadingDividends => _statusDividends == Status.loading;

  SDDividendsRes? _dataDividends;
  SDDividendsRes? get dataDividends => _dataDividends;

  setStatusDividends(status) {
    _statusDividends = status;
    notifyListeners();
  }

  int _openDividends = -1;
  int get openDividends => _openDividends;

  openDividendsIndex(index) {
    _openDividends = index;
    notifyListeners();
  }

  Future getSDDividends({
    bool reset = false,
  }) async {
    if (_selectedStock == '') return;
    if (reset) {
      _dataDividends = null;
      _openDividends = -1;
    }
    try {
      setStatusDividends(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _selectedStock,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sdDividends,
        request: request,
      );
      if (response.status) {
        _dataDividends = SDDividendsResFromJson(jsonEncode(response.data));
        _errorDividends = null;
      } else {
        _dataDividends = null;
        _errorDividends = response.message;
      }
    } catch (e) {
      _dataDividends = null;
      _errorDividends = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.sdDividends}: $e');
    } finally {
      setStatusDividends(Status.loaded);
    }
  }

  //MARK: Insider Trades
  String? _errorInsiderTrade;
  String? get errorInsiderTrade =>
      _errorInsiderTrade ?? Const.errSomethingWrong;

  Status _statusInsiderTrade = Status.ideal;
  Status get statusInsiderTrade => _statusInsiderTrade;

  bool get isLoadingInsiderTrade => _statusInsiderTrade == Status.loading;

  SDInsiderTradesRes? _dataInsiderTrade;
  SDInsiderTradesRes? get dataInsiderTrade => _dataInsiderTrade;

  setStatusInsiderTrades(status) {
    _statusInsiderTrade = status;
    notifyListeners();
  }

  int _openInsiderTrades = -1;
  int get openInsiderTrades => _openInsiderTrades;

  openInsiderTradesIndex(index) {
    _openInsiderTrades = index;
    notifyListeners();
  }

  Future getSDInsiderTrades({
    bool reset = false,
  }) async {
    if (_selectedStock == '') return;
    if (reset) {
      _dataInsiderTrade = null;
      _openInsiderTrades = -1;
    }
    try {
      setStatusInsiderTrades(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _selectedStock,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sdInsiderTrades,
        request: request,
      );
      if (response.status) {
        _dataInsiderTrade =
            SDInsiderTradesResFromJson(jsonEncode(response.data));
        _errorInsiderTrade = null;
      } else {
        _dataInsiderTrade = null;
        _errorInsiderTrade = response.message;
      }
    } catch (e) {
      _dataInsiderTrade = null;
      _errorInsiderTrade = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.sdInsiderTrades}: $e');
    } finally {
      setStatusInsiderTrades(Status.loaded);
    }
  }

  //MARK: Competitors
  String? _errorCompetitors;
  String? get errorCompetitors => _errorCompetitors ?? Const.errSomethingWrong;

  Status _statusCompetitors = Status.ideal;
  Status get statusCompetitors => _statusCompetitors;

  bool get isLoadingCompetitors => _statusCompetitors == Status.loading;

  SDCompetitorsRes? _dataCompetitors;
  SDCompetitorsRes? get dataCompetitors => _dataCompetitors;

  setStatusCompetitors(status) {
    _statusCompetitors = status;
    notifyListeners();
  }

  int _openCompetitors = -1;
  int get openCompetitors => _openCompetitors;

  openCompetitorsIndex(index) {
    _openCompetitors = index;
    notifyListeners();
  }

  Future getSDCompetitors({
    bool reset = false,
  }) async {
    if (_selectedStock == '') return;
    if (reset) {
      _dataCompetitors = null;
      _openCompetitors = -1;
    }
    try {
      setStatusCompetitors(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _selectedStock,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sdCompetitors,
        request: request,
      );
      if (response.status) {
        _dataCompetitors = SDCompetitorsResFromJson(jsonEncode(response.data));
        _errorCompetitors = null;
      } else {
        _dataCompetitors = null;
        _errorCompetitors = response.message;
      }
    } catch (e) {
      _dataCompetitors = null;
      _errorCompetitors = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.sdCompetitors}: $e');
    } finally {
      setStatusCompetitors(Status.loaded);
    }
  }

  //MARK: Ownership

  String? _errorOwnership;
  String? get errorOwnership => _errorOwnership ?? Const.errSomethingWrong;

  Status _statusOwnership = Status.ideal;
  Status get statusOwnership => _statusOwnership;

  bool get isLoadingOwnership => _statusOwnership == Status.loading;

  SDOwnershipRes? _dataOwnership;
  SDOwnershipRes? get dataOwnership => _dataOwnership;

  setStatusOwnership(status) {
    _statusOwnership = status;
    notifyListeners();
  }

  int _openOwnership = -1;
  int get openOwnership => _openOwnership;

  openOwnershipIndex(index) {
    _openOwnership = index;
    notifyListeners();
  }

  Future getSDOwnership({
    bool reset = false,
  }) async {
    if (_selectedStock == '') return;
    if (reset) {
      _dataOwnership = null;
    }
    try {
      setStatusOwnership(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _selectedStock,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sdOwnership,
        request: request,
      );
      if (response.status) {
        _dataOwnership = SDOwnershipResFromJson(jsonEncode(response.data));
        _errorOwnership = null;
      } else {
        _dataOwnership = null;
        _errorOwnership = response.message;
      }
    } catch (e) {
      _dataOwnership = null;
      _errorOwnership = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.sdOwnership}: $e');
    } finally {
      setStatusOwnership(Status.loaded);
    }
  }

  //MARK: Chart Historical
  String? _errorCHistorical;
  String? get errorCHistorical => _errorCHistorical ?? Const.errSomethingWrong;

  SDHistoricalChartRes? _dataCHistorical;
  SDHistoricalChartRes? get dataCHistorical => _dataCHistorical;

  Future getSDCHistorical({String range = '1hour', bool reset = false}) async {
    if (_selectedStock == '') return;
    if (reset) _dataCHistorical = null;

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
        showProgress: _dataCHistorical != null,
      );
      if (response.status) {
        _dataCHistorical =
            stocksDetailHistoricalChartResFromJson(jsonEncode(response.data));
        _errorCHistorical = null;
      } else {
        _dataCHistorical = null;
        _errorCHistorical = response.message;
      }
    } catch (e) {
      _dataCHistorical = null;
      _errorCHistorical = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.sdHistoricalC}: $e');
    } finally {
      setStatusHistoricalC(Status.loaded);
    }
  }

  //MARK: Chart
  String? _errorChart;
  String? get errorChart => _errorChart ?? Const.errSomethingWrong;

  Status _statusChart = Status.ideal;
  Status get statusChart => _statusChart;

  bool get isLoadingChart => _statusChart == Status.loading;

  SDChartRes? _dataChart;
  SDChartRes? get dataChart => _dataChart;

  int _openChart = -1;
  int get openChart => _openChart;

  openChartIndex(index) {
    _openChart = index;
    notifyListeners();
  }

  setStatusChart(status) {
    _statusChart = status;
    notifyListeners();
  }

  Future getSDChart({
    bool reset = false,
  }) async {
    if (_selectedStock == '') return;
    if (reset) {
      _dataMergers = null;
      _openChart = -1;
    }
    try {
      setStatusChart(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _selectedStock,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sdChart,
        request: request,
      );
      if (response.status) {
        _dataChart = SDChartResFromJson(jsonEncode(response.data));
        _errorChart = null;
      } else {
        _dataChart = null;
        _errorChart = response.message;
      }
    } catch (e) {
      _dataChart = null;
      _errorChart = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.sdChart}: $e');
    } finally {
      setStatusChart(Status.loaded);
    }
  }

  //MARK: Financial
  String? _errorFinancial;
  String? get errorFinancial => _errorFinancial ?? Const.errSomethingWrong;

  Status _statusFinancial = Status.ideal;
  Status get statusFinancial => _statusFinancial;

  bool get isLoadingFinancial => _statusFinancial == Status.loading;

  List<Map<String, dynamic>>? _dataFinancials;
  List<Map<String, dynamic>>? get dataFinancials => _dataFinancials;

  setStatusFinancials(status) {
    _statusFinancial = status;
    notifyListeners();
  }

  Future getSDFinancials({
    bool reset = false,
  }) async {
    if (_selectedStock == '') return;
    if (reset) {
      _dataFinancials = null;
    }
    try {
      setStatusFinancials(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _selectedStock,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sdFinancials,
        request: request,
      );
      if (response.status) {
        _dataFinancials = List<Map<String, dynamic>>.from(
            response.data?['finance_statement'] ?? []);

        _errorCompetitors = null;
      } else {
        _dataFinancials = null;
        _errorCompetitors = response.message;
      }
    } catch (e) {
      _dataFinancials = null;
      _errorCompetitors = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.sdFinancials}: $e');
    } finally {
      setStatusFinancials(Status.loaded);
    }
  }

  //MARK: Sec Filing
  String? _errorSecFiling;
  String? get errorSecFiling => _errorSecFiling ?? Const.errSomethingWrong;

  Status _statusSecFiling = Status.ideal;
  Status get statusSecFiling => _statusSecFiling;

  bool get isLoadingSecFiling => _statusSecFiling == Status.loading;

  SDSecFilingRes? _dataSecFiling;
  SDSecFilingRes? get dataSecFiling => _dataSecFiling;

  setStatusSecFiling(status) {
    _statusSecFiling = status;
    notifyListeners();
  }

  Future getSDSecFiling({
    bool reset = false,
  }) async {
    if (_selectedStock == '') return;
    if (reset) {
      _dataSecFiling = null;
    }
    try {
      setStatusSecFiling(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _selectedStock,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sdSecFiling,
        request: request,
      );
      if (response.status) {
        _dataSecFiling = SDSecFilingResFromJson(jsonEncode(response.data));
        _errorSecFiling = null;
      } else {
        _dataSecFiling = null;
        _errorSecFiling = response.message;
      }
    } catch (e) {
      _dataSecFiling = null;
      _errorSecFiling = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.sdSecFiling}: $e');
    } finally {
      setStatusSecFiling(Status.loaded);
    }
  }

  //MARK: Mergers
  String? _errorMergers;
  String? get errorMergers => _errorMergers ?? Const.errSomethingWrong;

  Status _statusMergers = Status.ideal;
  Status get statusMergers => _statusMergers;

  bool get isLoadingMergers => _statusMergers == Status.loading;

  SDMergersRes? _dataMergers;
  SDMergersRes? get dataMergers => _dataMergers;

  int _openMergers = -1;
  int get openMergers => _openMergers;

  openMergersIndex(index) {
    _openMergers = index;
    notifyListeners();
  }

  setStatusMergers(status) {
    _statusMergers = status;
    notifyListeners();
  }

  Future getSDMergers({
    bool reset = false,
  }) async {
    if (_selectedStock == '') return;
    if (reset) {
      _dataMergers = null;
    }
    try {
      setStatusMergers(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        // 'symbol': _selectedStock,
        'symbol': kDebugMode ? 'MTAC' : _selectedStock,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sdMergers,
        request: request,
      );
      if (response.status) {
        _dataMergers = SDMergersResFromJson(jsonEncode(response.data));
        _errorMergers = null;
      } else {
        _dataMergers = null;
        _errorMergers = response.message;
      }
    } catch (e) {
      _dataMergers = null;
      _errorMergers = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.sdMergers}: $e');
    } finally {
      setStatusMergers(Status.loaded);
    }
  }

  void updateTickerInfo({required String symbol, alertAdded, watchListAdded}) {

    if (_dataStocksAnalysis?.peersData?.data != null) {
      final index =
      _dataStocksAnalysis?.peersData?.data?.indexWhere((element) => element.symbol == symbol);
      if (index != null && index != -1) {
        if (alertAdded != null) {
          _dataStocksAnalysis?.peersData?.data![index].isAlertAdded = alertAdded;
        }
        if (watchListAdded != null) {
          _dataStocksAnalysis?.peersData?.data![index].isWatchlistAdded = watchListAdded;
        }
        notifyListeners();
      }
    }

    if (_data?.tickerDetail != null) {
      if (alertAdded != null) {
        _data?.tickerDetail?.isAlertAdded = alertAdded;
      }
      if (watchListAdded != null) {
        _data?.tickerDetail?.isWatchlistAdded = watchListAdded;
      }
      notifyListeners();
    }
  }

}

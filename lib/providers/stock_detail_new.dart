import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/stockDetailRes/chart.dart';
import 'package:stocks_news_new/modals/stockDetailRes/competitor.dart';
import 'package:stocks_news_new/modals/stockDetailRes/dividends.dart';
import 'package:stocks_news_new/modals/stockDetailRes/ownership.dart';
import 'package:stocks_news_new/modals/stockDetailRes/overview_graph.dart';
import 'package:stocks_news_new/modals/stockDetailRes/sd_insider_res.dart';
import 'package:stocks_news_new/modals/stockDetailRes/sd_news.dart';
import 'package:stocks_news_new/modals/stockDetailRes/sd_social_res.dart';
import 'package:stocks_news_new/modals/stockDetailRes/sec_filing_res.dart';
import 'package:stocks_news_new/modals/stockDetailRes/tab.dart';
import 'package:stocks_news_new/utils/utils.dart';

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

//---------------------------------------------------------------
//Overview DATA
  String? _errorOverview;
  String? get errorOverview => _errorOverview ?? Const.errSomethingWrong;

  Status _statusOverview = Status.ideal;
  Status get statusOverview => _statusOverview;

  bool get isLoadingOverview => _statusOverview == Status.loading;

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
  }) async {
    setStatusOverview(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.detailOverview,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _overviewRes = sdOverviewResFromJson(jsonEncode(response.data));
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
      );

      if (response.status) {
        _graphChart = sdOverviewGraphResFromJson(jsonEncode(response.data));
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
      Map request = {"symbol": symbol ?? ""};

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
}

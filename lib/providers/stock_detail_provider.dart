import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/analysis_res.dart';
import 'package:stocks_news_new/modals/stock_detail_graph.dart';
import 'package:stocks_news_new/modals/stock_details_mentions_res.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/modals/stocks_other_detail_res.dart';
import 'package:stocks_news_new/modals/technical_analysis_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/theme.dart';

//
class StockDetailProvider with ChangeNotifier {
  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading;
  String? get error => _error ?? Const.errSomethingWrong;
  AnalysisRes? _analysisRes;
  AnalysisRes? get analysisRes => _analysisRes;

  TechnicalAnalysisRes? _technicalAnalysisRes;
  TechnicalAnalysisRes? get technicalAnalysisRes => _technicalAnalysisRes;

  StocksOtherDetailsRes? _otherData;
  StocksOtherDetailsRes? get otherData => _otherData;

  bool analysisLoading = false;
  bool mentionLoading = false;
  bool tALoading = false;
  bool tabLoading = false;
  StockDetailsRes? _data;
  StockDetailsRes? get data => _data;
  StockDetailMentionRes? _dataMentions;
  StockDetailMentionRes? get dataMentions => _dataMentions;

  Status _statusGraph = Status.ideal;
  Status get statusGraph => _statusGraph;
  bool get isLoadingGraph => _statusGraph == Status.loading;

  bool get otherLoading => _status == Status.loading;

  List<StockDetailGraphData>? _graphChart;
  List<StockDetailGraphData>? get graphChart => _graphChart;

  List<StockDetailGraphData>? _extraData;
  List<StockDetailGraphData>? get extraData => _extraData;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  // bool selectedOne = false;
  // bool selectedTwo = false;

  // void selectType({int index = 0}) {
  //   if (index == 0) {
  //     selectedOne = !selectedOne;
  //   } else if (index == 1) {
  //     selectedTwo = !selectedTwo;
  //   }
  //   notifyListeners();
  // }

  void onTabChanged({
    required int index,
    required String symbol,
    String interval = "5min",
  }) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
      technicalAnalysisData(symbol: symbol, interval: interval, fromTab: true);
    }
  }

  void changeAlert(value) {
    _data?.isAlertAdded = value;
    notifyListeners();
  }

  void changeWatchList(value) {
    _data?.isWatchlistAdded = value;
    notifyListeners();
  }

  // void clear() {
  //   selectedOne = false;
  //   selectedTwo = false;
  //   notifyListeners();
  // }

  Future getStockDetails({required String symbol, loadOther = true}) async {
    _selectedIndex = 0;
    _data = null;
    if (loadOther) setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
      };
      ApiResponse response = await apiRequest(
        url: Apis.stockDetails,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _data = stockDetailsResFromJson(jsonEncode(response.data));

        // // Assign random colors to mentions
        // math.Random random = math.Random();
        // _data?.mentions?.forEach((mention) {
        //   // Generate a random color
        //   Color randomColor = Color.fromRGBO(
        //     random.nextInt(256),
        //     random.nextInt(256),
        //     random.nextInt(256),
        //     1,
        //   );
        //   mention.color = randomColor;
        // });
        if (loadOther) {
          getStockDetailsMentions(
            symbol: symbol,
            sectorSlug: _data?.companyInfo?.sectorSlug ?? '',
            price: _data?.keyStats?.priceWithoutCur,
          );
        }
      } else {
        _data = null;
        showErrorMessage(message: response.message);
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      log(e.toString());
      setStatus(Status.loaded);
    }
  }

  LineChartData avgData({String? from}) {
    List<StockDetailGraphData> reversedData =
        _graphChart?.reversed.toList() ?? [];

    List<FlSpot> spots = [];

    for (int i = 0; i < reversedData.length; i++) {
      spots.add(FlSpot(i.toDouble(), reversedData[i].close));
    }

    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: 20.0,
          showOnTopOfTheChartBoxArea: true,
          fitInsideHorizontally: false,
          tooltipMargin: 4,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map(
              (LineBarSpot touchedSpot) {
                return LineTooltipItem(
                  spots[touchedSpot.spotIndex].y.toStringAsFixed(2),
                  stylePTSansRegular(color: ThemeColors.blackShade),
                );
              },
            ).toList();
          },
          getTooltipColor: (touchedSpot) {
            return Colors.white;
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
          showTitles: true,
          getTitlesWidget: (value, meta) {
            int index = value.toInt();
            if (index >= 0 && index < (spots.length)) {
              return Padding(
                padding: EdgeInsets.only(top: 8.sp, left: 5.sp),
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
          // axisNameWidget: Text(
          //   "Price",
          //   style: stylePTSansRegular(fontSize: 15),
          // ),
          sideTitles: SideTitles(
            // interval: reversedData.length < 100 ? 1 : 5,
            reservedSize: 20,
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8.sp, left: 5.sp),
                child: Text(
                  "${value.round()}",
                  style: stylePTSansRegular(fontSize: 8),
                ),
              );

              // return Padding(
              //   padding: EdgeInsets.only(bottom: 8.sp, left: 5.sp),
              //   child: Text(
              //     "${value.round()}",
              //     style: stylePTSansRegular(fontSize: 8),
              //   ),
              // );
            },
          ),
        ),
      ),
      gridData: FlGridData(
        show: true, // Show grid
        // drawHorizontalLine: true,

        // drawVerticalLine: true,

        // checkToShowHorizontalLine: (value) {
        //   return true;
        // },

        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: ThemeColors.white.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: ThemeColors.white.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
      ),
      minX: 0,
      maxX: reversedData.length.toDouble() - 1,
      minY: reversedData
          .map((data) => data.close)
          .reduce((a, b) => a < b ? a : b),
      maxY: reversedData
          .map((data) => data.close)
          .reduce((a, b) => a > b ? a : b),
      baselineX: 50,
      baselineY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          color: (_data?.keyStats?.previousCloseNUM ?? 0) > spots.first.y
              ? ThemeColors.sos
              : ThemeColors.accent,
          isCurved: true,
          barWidth: 1.5,
          dotData: const FlDotData(
            show: false, // hide dots
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                (_data?.keyStats?.previousCloseNUM ?? 0) > spots.first.y
                    ? ThemeColors.sos.withOpacity(0.1)
                    : ThemeColors.accent.withOpacity(0.1),
                ThemeColors.background,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future getStockGraphData({
    required String symbol,
    String interval = '15M',
    showProgress = false,
    String? from,
  }) async {
    _statusGraph = Status.loading;
    notifyListeners();

    String newInterval = interval == "1M"
        ? "1min"
        : interval == "5M"
            ? "5min"
            : interval == "15M"
                ? "15min"
                : interval == "30M"
                    ? "30min"
                    : interval == "1H"
                        ? "1hour"
                        : "4hour";
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
        "interval": newInterval,
      };
      ApiResponse response = await apiRequest(
        url: Apis.newsAlertGraphData,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _graphChart = stockDetailGraphFromJson(jsonEncode(response.data)).data;
        notifyListeners();
        log(" in API reversed graphChart ${_graphChart?[0].close}");

        avgData(from: "API");
      } else {
        showErrorMessage(message: response.message);
      }
      _statusGraph = Status.loaded;

      notifyListeners();
    } catch (e) {
      log(e.toString());
      _statusGraph = Status.loaded;

      notifyListeners();
    }
  }

  Future getStockOtherDetails(
      {required String symbol, loadOther = true}) async {
    _otherData = null;

    setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
      };
      ApiResponse response = await apiRequest(
        url: Apis.getOtherData,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _otherData = stocksOtherDetailsFromJson(jsonEncode(response.data));
      } else {
        _otherData = null;
        showErrorMessage(message: response.message);
      }
      setStatus(Status.loaded);
    } catch (e) {
      _otherData = null;
      log(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future analysisData({required String symbol}) async {
    _analysisRes = null;
    analysisLoading = true;
    notifyListeners();
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
      };

      ApiResponse response = await apiRequest(
        url: Apis.stockAnalysis,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _analysisRes = analysisResFromJson(jsonEncode(response.data));
      } else {
        _analysisRes = null;
      }
      analysisLoading = false;
      notifyListeners();
    } catch (e) {
      _analysisRes = null;
      log(e.toString());
      _error = Const.errSomethingWrong;

      analysisLoading = false;
      notifyListeners();
    }
  }

  Future technicalAnalysisData({
    required String symbol,
    String interval = "5min",
    fromTab = false,
  }) async {
    _technicalAnalysisRes = null;
    if (!fromTab) {
      tALoading = true;
    } else {
      tabLoading = true;
    }

    notifyListeners();
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
        "interval": interval,
      };
      ApiResponse response = await apiRequest(
        url: Apis.technicalAnalysis,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _technicalAnalysisRes =
            technicalAnalysisResFromJson(jsonEncode(response.data));
      } else {
        _technicalAnalysisRes = null;
      }
      if (!fromTab) {
        tALoading = false;
      } else {
        tabLoading = false;
      }
      notifyListeners();
    } catch (e) {
      _error = Const.errSomethingWrong;

      _technicalAnalysisRes = null;
      log(e.toString());
      if (!fromTab) {
        tALoading = false;
      } else {
        tabLoading = false;
      }
      notifyListeners();
    }
  }

  Future getStockDetailsMentions({
    required String symbol,
    required String sectorSlug,
    required price,
  }) async {
    mentionLoading = true;
    notifyListeners();
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
        "sector_slug": sectorSlug,
        "price": "$price"
      };
      ApiResponse response = await apiRequest(
        url: Apis.stockDetailMention,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _dataMentions =
            stockDetailMentionResFromJson(jsonEncode(response.data));
        log("-- Mention log showing in stock provider -> ${_dataMentions?.mentions?.length}");
        // // Assign random colors to mentions
        math.Random random = math.Random();
        _dataMentions?.mentions?.forEach((mention) {
          // Generate a random color
          Color randomColor = Color.fromRGBO(
            random.nextInt(256),
            random.nextInt(256),
            random.nextInt(256),
            1,
          );

          mention.color = randomColor;
        });
      } else {
        _data = null;
        showErrorMessage(message: response.message);
      }
      mentionLoading = false;
      notifyListeners();
    } catch (e) {
      _error = Const.errSomethingWrong;

      _data = null;
      log(e.toString());
      mentionLoading = true;
      notifyListeners();
    }
  }

  Future createAlertSend({
    required String alertName,
    bool selectedOne = false,
    bool selectedTwo = false,
  }) async {
    setStatus(Status.loading);

    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "symbol": _data?.keyStats?.symbol ?? "",
      "alert_name": alertName,
      "sentiment_spike": selectedOne ? "yes" : "no",
      "mention_spike": selectedTwo ? "yes" : "no",
    };
    try {
      ApiResponse response =
          await apiRequest(url: Apis.createAlert, request: request);
      if (response.status) {
        data?.isAlertAdded = 1;

        // notifyListeners();
      }
      Navigator.pop(navigatorKey.currentContext!);
      Navigator.pop(navigatorKey.currentContext!);

      showErrorMessage(
          message: response.message,
          type: response.status ? SnackbarType.info : SnackbarType.error);
      setStatus(Status.loaded);
      return ApiResponse(status: response.status);
    } catch (e) {
      log(e.toString());
      setStatus(Status.loaded);

      showErrorMessage(message: Const.errSomethingWrong);
    }
  }

  Future addToWishList() async {
    setStatus(Status.loading);

    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "symbol": _data?.keyStats?.symbol ?? "",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.addWatchlist,
        request: request,
      );
      if (response.status) {
        data?.isWatchlistAdded = 1;
      }
      showErrorMessage(
          message: response.message,
          type: response.status ? SnackbarType.info : SnackbarType.error);

      setStatus(Status.loaded);
      return ApiResponse(status: response.status);
    } catch (e) {
      log(e.toString());
      setStatus(Status.loaded);

      showErrorMessage(message: Const.errSomethingWrong);
    }
  }
}

import 'dart:convert';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
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
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';

//
class StockDetailProvider with ChangeNotifier {
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  String? _errorOther;
  String? get errorOther => _errorOther ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading;
  AnalysisRes? _analysisRes;
  AnalysisRes? get analysisRes => _analysisRes;

  TechnicalAnalysisRes? _technicalAnalysisRes;
  TechnicalAnalysisRes? get technicalAnalysisRes => _technicalAnalysisRes;

  StocksOtherDetailsRes? _otherData;
  StocksOtherDetailsRes? get otherData => _otherData;
  String? graphError = '';

  bool otherLoading = false;
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

  // bool get otherLoading => _status == Status.loading;

  List<StockDetailGraph>? _graphChart;
  List<StockDetailGraph>? get graphChart => _graphChart;

  List<StockDetailGraph>? _extraData;
  List<StockDetailGraph>? get extraData => _extraData;
  final AudioPlayer _player = AudioPlayer();

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  int _graphIndex = 0;
  int get graphIndex => _graphIndex;

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

  Future getStockDetails(
      {required String symbol, loadOther = true, refresh = false}) async {
    _selectedIndex = 0;

    if (refresh) {
      _data = null;
      _analysisRes = null;
      _dataMentions = null;
      _technicalAnalysisRes = null;
      _otherData = null;
    }
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
        // showErrorMessage(message: response.message);
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  double calculateInterval(List<StockDetailGraph> data) {
    // Get the range of close prices
    double maxClose = data
        .map((e) => e.close)
        .reduce((max, value) => max > value ? max : value);
    double minClose = data
        .map((e) => e.close)
        .reduce((min, value) => min < value ? min : value);
    double closeRange = maxClose - minClose;

    return closeRange / 4.5;
  }

  LineChartData avgData({bool showDate = true}) {
    List<StockDetailGraph> reversedData = _graphChart?.reversed.toList() ?? [];

    List<FlSpot> spots = [];

    for (int i = 0; i < reversedData.length; i++) {
      spots.add(FlSpot(i.toDouble(), reversedData[i].close));
    }
    // double interval = (reversedData.length / 5).ceil().toDouble();
    // double interval = calculateInterval(reversedData);
    // double average = 0;

    // Calculate the average of the close values
    // if (reversedData.isNotEmpty) {
    //   double sum = 0;
    //   for (int i = 0; i < reversedData.length; i++) {
    //     sum += reversedData[i].close;
    //   }
    //   average = sum / reversedData.length;
    //   Utils().showLog("average => $average");
    // }
    // Utils().showLog("Length => ${reversedData.length}");
    // Utils().showLog("interval => $interval");
    Utils().showLog("previous Close => ${_data?.keyStats?.previousCloseNUM}");
    Utils().showLog("Newest Close => ${reversedData.last.close}");

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
                color: Colors.grey[400],
                strokeWidth: 1,
                dashArray: [5, 5],
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
          tooltipHorizontalOffset: 10,
          tooltipRoundedRadius: 10.0,
          showOnTopOfTheChartBoxArea: true,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          maxContentWidth: 300,
          tooltipPadding:
              EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
          tooltipMargin: 1,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map(
              (LineBarSpot touchedSpot) {
                return LineTooltipItem(
                  // children: [
                  //   TextSpan(
                  //     text: "\$${touchedSpot.y.toStringAsFixed(2)}",
                  //     style: styleGeorgiaBold(
                  //       // color: (_data?.keyStats?.previousCloseNUM ?? 0) >
                  //       //         spots.last.y
                  //       //     ? ThemeColors.sos
                  //       //     : ThemeColors.accent,
                  //       color: ThemeColors.accent,
                  //     ),
                  //   ),
                  //   const TextSpan(text: "\n"), // Add a new line

                  //   TextSpan(
                  //     text:
                  //         "Y: ${DateFormat('HH:mm').format(reversedData[touchedSpot.x.toInt()].date)}",
                  //     style: styleGeorgiaBold(
                  //         fontSize: 12, color: ThemeColors.background),
                  //   ),
                  // ],

                  !showDate
                      ? '\$${touchedSpot.y.toStringAsFixed(2)} | ${DateFormat('dd MMM, yyyy').format(reversedData[touchedSpot.x.toInt()].date)}'
                      : '\$${touchedSpot.y.toStringAsFixed(2)} | ${DateFormat('dd MMM').format(reversedData[touchedSpot.x.toInt()].date)}, ${DateFormat('h:mm a').format(reversedData[touchedSpot.x.toInt()].date)}',

                  stylePTSansBold(color: ThemeColors.white, fontSize: 10),
                );
              },
            ).toList();
          },
          getTooltipColor: (touchedSpot) {
            return Colors.transparent;
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
            // return Padding(
            //   padding: EdgeInsets.only(top: 8.sp, left: 5.sp),
            //   child: Text(
            //     "$value",
            //     style: stylePTSansRegular(fontSize: 8),
            //   ),
            // );
          },
        )),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            // interval: interval,
            reservedSize: 32,
            showTitles: false,
            getTitlesWidget: (double value, TitleMeta meta) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8.sp, left: 5.sp),
                child: Text(
                  value.toStringAsFixed(2),
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
          .map((data) => data.close)
          .reduce((a, b) => a < b ? a : b),
      maxY: reversedData
          .map((data) => data.close)
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
        // LineChartBarData(
        //   spots: [
        //     FlSpot(0, average),
        //     FlSpot(spots.length.toDouble() - 1, average)
        //   ],
        //   isCurved: false,
        //   barWidth: 1,
        //   color: ThemeColors.greyBorder,
        //   belowBarData: BarAreaData(show: false),
        //   dashArray: [5, 5],
        // ),
      ],
    );
  }

  Future getStockGraphData({
    required String symbol,
    String interval = '15M',
    String range = '1H',
    showProgress = false,
    bool clearData = true,
    String? from,
    index,
  }) async {
    if (clearData) _graphChart = null;

    _statusGraph = Status.loading;
    _graphIndex = index ?? 0;
    notifyListeners();

    // String newInterval = interval == "1M"
    //     ? "1min"
    //     : interval == "5M"
    //         ? "5min"
    //         : interval == "15M"
    //             ? "15min"
    //             : interval == "30M"
    //                 ? "30min"
    //                 : interval == "1H"
    //                     ? "1hour"
    //                     : "4hour";

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

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
        // "interval": newInterval,
        "range": newRange,
      };

      ApiResponse response = await apiRequest(
        url: Apis.newsAlertGraphData,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _graphChart = stockDetailGraphFromJson(jsonEncode(response.data));
        notifyListeners();
        Utils().showLog(" in API reversed graphChart ${_graphChart?[0].close}");
        avgData(showDate: newRange != "1Y");
        graphError = '';
      } else {
        graphError = response.message;
        // showErrorMessage(message: response.message);
      }
      _statusGraph = Status.loaded;

      notifyListeners();
    } catch (e) {
      Utils().showLog(e.toString());
      _statusGraph = Status.loaded;
      graphError = '';

      notifyListeners();
    }
  }

  Future getStockOtherDetails({
    required String symbol,
    loadOther = true,
    inAppMsgId,
  }) async {
    otherLoading = true;
    notifyListeners();
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
      };
      if (inAppMsgId != null) {
        request.addAll({"in_app_id": inAppMsgId!});
      }

      ApiResponse response = await apiRequest(
        url: Apis.getOtherData,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _otherData = stocksOtherDetailsFromJson(jsonEncode(response.data));
      } else {
        _otherData = null;
        _errorOther = response.message;
        // showErrorMessage(message: response.message);
      }
      otherLoading = false;
      notifyListeners();
    } catch (e) {
      otherLoading = false;
      _errorOther = Const.errSomethingWrong;

      notifyListeners();
      Utils().showLog(e.toString());
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
      Utils().showLog(e.toString());
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
      Utils().showLog(e.toString());
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
        Utils().showLog(
            "-- Mention Utils().showLog showing in stock provider -> ${_dataMentions?.mentions?.length}");
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
        // showErrorMessage(message: response.message);
      }
      mentionLoading = false;
      notifyListeners();
    } catch (e) {
      _error = Const.errSomethingWrong;

      _data = null;
      Utils().showLog(e.toString());
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
      ApiResponse response = await apiRequest(
        url: Apis.createAlert,
        request: request,
        showProgress: true,
      );
      if (response.status) {
        data?.isAlertAdded = 1;
        await _player.play(AssetSource(AudioFiles.alertWeathlist));

        navigatorKey.currentContext!
            .read<HomeProvider>()
            .setTotalsAlerts(response.data['total_alerts']);
        // notifyListeners();
      }
      Navigator.pop(navigatorKey.currentContext!);
      Navigator.pop(navigatorKey.currentContext!);

      // showErrorMessage(
      //     message: response.message,
      //     type: response.status ? SnackbarType.info : SnackbarType.error);
      setStatus(Status.loaded);
      return ApiResponse(status: response.status, data: response.data);
    } catch (e) {
      Utils().showLog(e.toString());
      setStatus(Status.loaded);

      // showErrorMessage(message: Const.errSomethingWrong);
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
        showProgress: false,
      );
      if (response.status) {
        data?.isWatchlistAdded = 1;
        await _player.play(AssetSource(AudioFiles.alertWeathlist));

        navigatorKey.currentContext!
            .read<HomeProvider>()
            .setTotalsWatchList(response.data['total_watchlist']);
      }
      // showErrorMessage(
      //     message: response.message,
      //     type: response.status ? SnackbarType.info : SnackbarType.error);

      setStatus(Status.loaded);
      return ApiResponse(status: response.status, data: response.data);
    } catch (e) {
      Utils().showLog(e.toString());
      setStatus(Status.loaded);

      // showErrorMessage(message: Const.errSomethingWrong);
    }
  }
}

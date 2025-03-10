import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/billionaires_detail.dart';
import 'package:stocks_news_new/models/billionaires_res.dart';
import 'package:stocks_news_new/models/crypto_detail_res.dart';
import 'package:stocks_news_new/models/crypto_watchlist_res.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/models/stockDetail/historical_chart.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';

class BillionairesManager extends ChangeNotifier{

  BillionairesRes? _billionairesRes;
  BillionairesRes? get billionairesRes=> _billionairesRes;

  BillionairesDetailRes? _billionairesDetailRes;
  BillionairesDetailRes? get billionairesDetailRes=> _billionairesDetailRes;

  CryptoDetailRes? _cryptoDetailRes;
  CryptoDetailRes? get cryptoDetailRes=> _cryptoDetailRes;


  MarketResData? _categoriesData;
  MarketResData? get categoriesData => _categoriesData;

  String? _error;
  Status _status = Status.ideal;
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  Status _statusCrypto = Status.ideal;
  bool get isLoadingCrypto => _statusCrypto == Status.loading || _statusCrypto == Status.ideal;


  CryptoWatchRes? _cryptoWatchRes;
  CryptoWatchRes? get cryptoWatchRes=> _cryptoWatchRes;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStatusCrypto(status) {
    _statusCrypto = status;
    notifyListeners();
  }

  Future onRefresh() async {
    getCryptoCurrencies();
  }


  Future<void> getTabs() async {
    try {
      setStatus(Status.loading);
      Map request = {};
      ApiResponse response = await apiRequest(
        url: Apis.cryptoTabs,
        request: request,
      );

      if (response.status) {
        _categoriesData = marketResDataFromJson(jsonEncode(response.data));
        _error = null;
         onScreenChange(0);
      } else {
        _categoriesData = null;
        _error = response.message;
      }
    } catch (e) {
      _categoriesData = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Error on ${Apis.newsCategories}: $e');
    } finally {
      setStatus(Status.loaded);
    }
  }


  Future getCryptoCurrencies() async {
    setStatusCrypto(Status.loading);
    try {
      Map request = {};
      ApiResponse response = await apiRequest(
        url: Apis.cryptoHome,
        showProgress: false,
        request: request,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _billionairesRes = billionairesResFromJson(jsonEncode(response.data));
      }
      else {
        _billionairesRes = null;
        _error = response.message;
      }
      setStatusCrypto(Status.loaded);
    } catch (e) {
      _billionairesRes = null;
      _error = Const.errSomethingWrong;
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      setStatusCrypto(Status.loaded);
    }
  }

  Future getBilDetail(String slug) async {
    setStatus(Status.loading);
    try {
      Map request = {
        'slug':slug
      };
      ApiResponse response = await apiRequest(
        url: Apis.cryptoBillionaireDetails,
        showProgress: false,
        request: request,
      );

      if (response.status) {
        _billionairesDetailRes = billionairesDetailResFromJson(jsonEncode(response.data));
      }
      else {
        _billionairesDetailRes = null;
        _error = response.message;
      }
      setStatus(Status.loaded);
    } catch (e) {
      _billionairesDetailRes = null;
      _error = Const.errSomethingWrong;
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      Utils().showLog('Error in ${Apis.cryptoBillionaireDetails+slug}: $e');
      setStatus(Status.loaded);
    }
  }

  Future getCryptoDetail(String symbol) async {
    setStatus(Status.loading);
    try {
      Map request = {
        'symbol': symbol,
      };
      ApiResponse response = await apiRequest(
        url: Apis.cryptoDetails,
        showProgress: false,
        request: request,
      );

      if (response.status) {
        _cryptoDetailRes = cryptoWatchResFromJson(jsonEncode(response.data));
      }
      else {
        _cryptoDetailRes = null;
        _error = response.message;
      }
      setStatus(Status.loaded);
    } catch (e) {
      _cryptoDetailRes = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.cryptoDetails}: $e');
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      setStatus(Status.loaded);
    }
  }


  String? _errorHistoricalC;
  String? get errorHistoricalC => _errorHistoricalC ?? Const.errSomethingWrong;

  Status _statusHistoricalC = Status.ideal;
  Status get statusHistoricalC => _statusHistoricalC;

  bool get isLoadingHistoricalC => _statusHistoricalC == Status.loading;

  List<HistoricalChartRes>? _dataHistoricalC;
  List<HistoricalChartRes>? get dataHistoricalC => _dataHistoricalC;

  setStatusHistoricalC(status) {
    _statusHistoricalC = status;
    notifyListeners();
  }

  //MARK: Line Chart
  LineChartData avgData({
    bool showDate = true,
    required List<HistoricalChartRes> reversedData,
  }) {
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

  Future getCrHistoricalC({String range = '1hour', bool reset = false,String? symbol}) async {
    if (symbol == '') return;
    if (reset) _dataHistoricalC = null;
    try {
      setStatusHistoricalC(Status.loading);
      Map request = {
        'symbol': symbol,
        'range': range,
      };

      ApiResponse response = await apiRequest(
        url: Apis.cryptoChart,
        request: request,
        showProgress: _dataHistoricalC != null,
      );
      if (response.status) {
        _dataHistoricalC = baseChartResFromJson(jsonEncode(response.data));
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


  Future getWatchList() async {
    setStatusCrypto(Status.loading);
    try {
      Map request = {};
      ApiResponse response = await apiRequest(
        url: Apis.cryptoWatchList,
        showProgress: false,
        request: request,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _cryptoWatchRes = cryptoWatchlistResFromJson(jsonEncode(response.data));
      }
      else {
        _cryptoWatchRes = null;
        _error = response.message;
      }
      setStatusCrypto(Status.loaded);
    } catch (e) {
      _cryptoWatchRes = null;
      _error = Const.errSomethingWrong;
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      setStatusCrypto(Status.loaded);
    }
  }

  Future requestAddToFav(String twitName) async {
    try {
      Map request = {
        "twitter_name":twitName
      };
      ApiResponse response = await apiRequest(
        url: Apis.addFav,
        showProgress: true,
        request: request,
      );
      if (response.status) {
        _billionairesDetailRes?.billionaireInfo?.isFavoritePersonAdded=1;
      }
      else {
        _error = response.message;
        TopSnackbar.show(
          message: response.message ?? '',
          type:ToasterEnum.error,
        );
      }
      notifyListeners();

    } catch (e) {
      _error = Const.errSomethingWrong;
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
    }
  }
  Future requestRemoveToFav(String twitName,{int? from}) async {
    try {
      Map request = {
        "twitter_name":twitName
      };
      ApiResponse response = await apiRequest(
        url: Apis.removeFav,
        showProgress: true,
        request: request,
      );
      if (response.status) {
        if(from==1){
          getWatchList();
        }
        else{
          _billionairesDetailRes?.billionaireInfo?.isFavoritePersonAdded=0;

        }
      }
      else {
        _error = response.message;
        TopSnackbar.show(
          message: response.message ?? '',
          type:ToasterEnum.error,
        );
      }
      notifyListeners();
    } catch (e) {
      _error = Const.errSomethingWrong;
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
    }
  }

  Future requestAddToWatch(String symbol) async {
    try {
      Map request = {
        "symbol":symbol
      };
      ApiResponse response = await apiRequest(
        url: Apis.addWatch,
        showProgress: true,
        request: request,
      );
      if (response.status) {
        _cryptoDetailRes?.cryptoInfo?.isCryptoAdded=1;
      }
      else {
        _error = response.message;
        TopSnackbar.show(
          message: response.message ?? '',
          type:ToasterEnum.error,
        );
      }
      notifyListeners();
    } catch (e) {
      _error = Const.errSomethingWrong;
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
    }
  }
  Future requestRemoveToWatch(String symbol) async {
    try {
      Map request = {
        "symbol":symbol
      };
      ApiResponse response = await apiRequest(
        url: Apis.removeWatch,
        showProgress: true,
        request: request,
      );
      if (response.status) {
        _cryptoDetailRes?.cryptoInfo?.isCryptoAdded=0;
      }
      else {
        _error = response.message;
        TopSnackbar.show(
          message: response.message ?? '',
          type:ToasterEnum.error,
        );
      }
      notifyListeners();
    } catch (e) {
      _error = Const.errSomethingWrong;
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
    }
  }

  int? selectedScreen=-1;
  onScreenChange(index) {
    if (selectedScreen != index) {
      selectedScreen = index;
      notifyListeners();
      switch (selectedScreen) {
        case 0:
          getCryptoCurrencies();
          break;

        case 1:
          getWatchList();
          break;

        case 2:
         // getInsidersData();
          break;
        default:
      }
      }
    }


  int? selectedInnerScreen=0;
  onScreenChangeInner(index) {
    if (selectedInnerScreen != index) {
      selectedInnerScreen = index;
      notifyListeners();
    }
  }
}
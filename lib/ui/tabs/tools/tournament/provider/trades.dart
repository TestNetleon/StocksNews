import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/modals/stockDetailRes/overview_graph.dart';
import 'package:stocks_news_new/modals/stock_screener_res.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/show_button_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/all_trades.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/ticker_detail.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/game_tournament_index.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/dayTraining/open/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';




class TournamentTradesProvider extends ChangeNotifier {
//MARK: All Trades
  KeyValueElementStockScreener? _selectedOverview;
  KeyValueElementStockScreener? get selectedOverview => _selectedOverview;

  TournamentAllTradesRes? _myTrades;
  TournamentAllTradesRes? get myTrades => _myTrades;

  Status _statusTrades = Status.ideal;
  Status get statusTrades => _statusTrades;

  bool get isLoadingTrades =>
      _statusTrades == Status.loading || _statusTrades == Status.ideal;

  String? _errorTrades;
  String? get errorTrades => _errorTrades ?? Const.errSomethingWrong;

  void setSelectedOverview(
    KeyValueElementStockScreener? data, {
    bool refresh = false,
    bool showProgress = false,
  }) {
    if (_selectedOverview != data) {
      _selectedOverview = data;
      notifyListeners();
      getTradesList(
        refresh: refresh,
        showProgress: showProgress,
      );
    }
  }

  void setStatusTrades(status) {
    _statusTrades = status;
    notifyListeners();
  }

  void redirectToTrade() {
    if (_myTrades?.tournamentBattleId != null) {
      Navigator.popUntil(
          navigatorKey.currentContext!, (route) => route.isFirst);
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => TournamentOpenIndex(),
        ),
      );
    } else {
      Navigator.popUntil(
          navigatorKey.currentContext!, (route) => route.isFirst);
      Navigator.pushNamed(
          navigatorKey.currentContext!,
          TradingLeagueIndex.path
      );

    }
  }

  /*void tickerDetailRedirection(String symbol) {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => StockDetail(symbol: symbol)),
    );
  }*/

  Future getTradesList({
    bool refresh = false,
    showProgress = false,
    String? typeOfTrade,
  }) async {
    if (refresh) {
      _myTrades = null;
      _selectedOverview = null;
    }

    setStatusTrades(Status.loading);

    try {
      LeagueManager manager = navigatorKey.currentContext!.read<LeagueManager>();

      Map request = {
        'tournament_battle_id':
            '${manager.detailRes?.tournamentBattleId ?? ''}',
        'type': typeOfTrade ??
            _selectedOverview?.key?.toString().toLowerCase() ??
            'all',
      };

      ApiResponse response = await apiRequest(
        url: Apis.tTradeList,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _myTrades = tournamentAllTradesResFromJson(jsonEncode(response.data));
        if (_myTrades?.data != null && _myTrades?.data?.isNotEmpty == true) {
          _startSseTrades();
        }

        if (refresh) {
          _selectedOverview = typeOfTrade != null
              ? _myTrades?.overview![1]
              : _myTrades?.overview?.first;
          _errorTrades = _selectedOverview?.value == 0
              ? _selectedOverview?.message ?? ""
              : "";
        } else {
          _errorTrades = _selectedOverview?.value == 0
              ? _selectedOverview?.message ?? ""
              : "";
        }
      } else {
        _myTrades = null;
        _errorTrades = response.message;
      }
      setStatusTrades(Status.loaded);
    } catch (e) {
      _myTrades = null;
      _errorTrades = Const.errSomethingWrong;
      Utils().showLog('Trades Overview Error: $e');
      setStatusTrades(Status.loaded);
    }
  }

  void _startSseTrades() {
    List<String>? symbols;
    if (_myTrades?.data != null && _myTrades?.data?.isNotEmpty == true) {
      symbols = _myTrades?.data
          ?.where((trade) => trade.status == 0 && trade.symbol != null)
          .map((trade) => trade.symbol!)
          .toList();
    }

    for (var data in _myTrades!.data!) {
      num currentPrice = data.price ?? 0;
      num orderPrice = data.orderPrice ?? 0;
      // num closePrice = data.closePrice ?? 0;
      if (data.status == 0) {
        if (symbols != null && symbols.isNotEmpty == true) {
          if (data.sType == StockType.buy) {
            data.orderChange = orderPrice == 0 || currentPrice == 0
                ? 0
                : (((currentPrice - orderPrice) / orderPrice) * 100);
            data.gainLoss = (currentPrice - orderPrice);
          } else {
            data.orderChange = currentPrice == 0 || orderPrice == 0
                ? 0
                : (((orderPrice - currentPrice) / currentPrice) * 100);
            data.gainLoss = (orderPrice - currentPrice);
          }
          // data.gainLoss = orderPrice == 0 || currentPrice == 0 ? 0 :(currentPrice - orderPrice);
          notifyListeners();

          SSEManager.instance.connectMultipleStocks(
            symbols: symbols,
            screen: SimulatorEnum.tournament,
          );

          SSEManager.instance.addListener(
            data.symbol ?? '',
            (stockData) {
              num? newPrice = stockData.price;

              if (newPrice != null) {
                if (data.sType == StockType.buy) {
                  data.orderChange =
                      (((newPrice - orderPrice) / orderPrice) * 100);
                  data.gainLoss = (newPrice - orderPrice);
                } else {
                  data.orderChange =
                      (((orderPrice - newPrice) / newPrice) * 100);
                  data.gainLoss = (orderPrice - newPrice);
                }
                //data.gainLoss = (newPrice - orderPrice);
                data.price = newPrice;
              }
              Utils().showLog(
                  'Symbol11 ${data.symbol}, ${data.orderChange}, ${data.gainLoss} ,${data.price}');
              notifyListeners();
            },
            SimulatorEnum.tournament,
          );
        }
        notifyListeners();
      } else {
        data.orderChange = data.changesPercentage;
        /* if (data.type == StockType.buy) {
          data.changesPercentage = closePrice == 0 ? 0 : (((orderPrice - closePrice) / closePrice) * 100);
        } else {
          data.changesPercentage = orderPrice == 0 ? 0 : (((closePrice - orderPrice) / orderPrice) * 100);
        }*/
      }
    }
  }

//MARK: BUY/SELL
  Future tradeBuySell({StockType type = StockType.buy, String? symbol}) async {
    try {
      LeagueManager manager = navigatorKey.currentContext!.read<LeagueManager>();

      Map request = {
        'symbol': symbol ?? _selectedStock?.symbol,
        'tournament_battle_id':
            '${_myTrades?.tournamentBattleId ?? manager.detailRes?.tournamentBattleId ?? ''}',
        'trade_type': type.name,
      };

      if (type == StockType.buy) {
        request['trade_type'] = 'buy';
      } else {
        request['trade_type'] = 'sell';
      }

      ApiResponse response = await apiRequest(
        url: Apis.tBuyOrSell,
        request: request,
        showProgress: true,
      );
      if (response.status) {
        getDetail(_selectedStock?.symbol ?? '', refresh: true);
      } else {
        //
        TopSnackbar.show(
          message: response.message??"",
          type: ToasterEnum.error,
        );
      }

      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog('');
      return ApiResponse(status: false);
    }
  }

  Future tradeCancle({
    bool cancleAll = false,
    num? tradeId,
    num? tournamentBattleId,
    String? ticker,
    bool callTickerDetail = true,
  }) async {
    try {
      LeagueManager manager = navigatorKey.currentContext!.read<LeagueManager>();

      Map request = {
        'ticker_symbol': ticker ?? _selectedStock?.symbol ?? '',
        'tournament_battle_id': (tournamentBattleId != null
            ? tournamentBattleId.toString()
            : '${_myTrades?.tournamentBattleId ?? manager.detailRes?.tournamentBattleId ?? ''}'),
        'trade_id': tradeId != null
            ? '$tradeId'
            : cancleAll
                ? 'all'
                : '${_detail[_selectedStock?.symbol]?.data?.showButton?.tradeId}'
      };
      ApiResponse response = await apiRequest(
        url: Apis.tCancle,
        request: request,
        showProgress: true,
      );
      if (response.status) {
        if (callTickerDetail) {
          getDetail(_selectedStock?.symbol ?? '', refresh: true);
        }
      } else {
        //
      }

      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog('');
      return ApiResponse(status: false);
    }
  }

//MARK: Stock Detail
  BaseTickerRes? _selectedStock;
  BaseTickerRes? get selectedStock => _selectedStock;

  // TournamentTickerDetailRes? _detail;
  // TournamentTickerDetailRes? get detail => _detail;

  Map<String, TournamentTickerHolder?> _detail = {};
  Map<String, TournamentTickerHolder?> get detail => _detail;

  void setSelectedStock({
    BaseTickerRes? stock,
    bool refresh = false,
    bool clearEverything = false,
  }) {
    if (clearEverything) {
      _detail = {};
      _activeTickers = {};
      notifyListeners();
    }

    if (stock != null) {
      _selectedStock = stock;
      notifyListeners();

      if (stock.symbol != null && stock.symbol != '') {
        getDetail(stock.symbol ?? '', refresh: refresh);
        getOverviewGraphData(symbol: stock.symbol);
      }
    }
  }

  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Set<String> _activeTickers = {};

  Future getDetail(String symbol, {bool refresh = false}) async {
    // Check if the ticker is already loaded and no refresh is needed
    if (_detail[symbol]?.data != null && !refresh) {
      _startSSE(symbol);
      Utils().showLog('Data for $symbol already fetched, returning...');
      return;
    }

    // Initialize the ticker entry in _detail
    _detail[symbol] = TournamentTickerHolder(
      data: null,
      error: null,
      loading: true,
    );
    setStatus(Status.loading);

    try {
      LeagueManager manager = navigatorKey.currentContext!.read<LeagueManager>();

      Map request = {
        "symbol": symbol,
        'tournament_battle_id':
            '${_myTrades?.tournamentBattleId ?? manager.detailRes?.tournamentBattleId ?? ''}',
      };

      // Fetch ticker details via API
      ApiResponse response = await apiRequest(
        url: Apis.tTickerDetail,
        request: request,
      );

      if (response.status) {
        // Parse and store API response
        _detail[symbol] = TournamentTickerHolder(
          data: tournamentTickerDetailResFromJson(jsonEncode(response.data)),
          error: null,
          loading: false,
        );

        _startSSE(symbol);
      } else {
        // Handle API error
        _detail[symbol] = TournamentTickerHolder(
          data: null,
          error: response.message,
          loading: false,
        );
      }

      setStatus(Status.loaded);
    } catch (e) {
      // Handle unexpected errors
      _detail[symbol] = TournamentTickerHolder(
        data: null,
        error: Const.errSomethingWrong,
        loading: false,
      );
      Utils().showLog('Error fetching details for $symbol: $e');
      setStatus(Status.loaded);
    }
  }

  void _startSSE(String symbol) {
    ShowButtonRes? buttonRes = _detail[symbol]?.data?.showButton;
    BaseTickerRes? tickerData = _detail[symbol]?.data?.ticker;

    if (buttonRes?.orderPrice != null) {
      num CP = tickerData?.price ?? 0;
      num OP = buttonRes?.orderPrice ?? 0;

      if (buttonRes?.orderType == StockType.buy.name) {
        buttonRes?.orderChange = (((CP - OP) / OP) * 100);
        Utils().showLog('Buy orderChange: ${buttonRes?.orderChange}');
      } else {
        buttonRes?.orderChange = (((OP - CP) / CP) * 100);
        Utils().showLog('Sell orderChange: ${buttonRes?.orderChange}');
      }
    }

    _activeTickers.add(symbol);
    Utils().showLog('Added $symbol to active tickers');

    try {
      SSEManager.instance.connectMultipleStocks(
        screen: SimulatorEnum.detail,
        symbols: _activeTickers.toList(),
      );

      SSEManager.instance.addListener(
        symbol,
        (stockData) {
          // Utils().showLog(
          //     'Streaming update for $symbol, Price: ${stockData.price}, Change: ${stockData.change}, Change%: ${stockData.changePercentage}');
          Utils().showLog('Tournament: ${stockData.toMap()}');
          tickerData?.price = stockData.price;
          tickerData?.change = stockData.change;
          tickerData?.changesPercentage = stockData.changePercentage;

          if (buttonRes?.orderPrice != null) {
            num CP = stockData.price ?? 0;
            num OP = buttonRes?.orderPrice ?? 0;

            if (buttonRes?.orderType == StockType.buy.name) {
              buttonRes?.orderChange = (((CP - OP) / OP) * 100);
              Utils().showLog('Buy orderChange: ${buttonRes?.orderChange}');
            } else {
              buttonRes?.orderChange = (((OP - CP) / CP) * 100);
            }
            Map<String, dynamic> logData = {
              'Symbol': symbol,
              'CurrentPrice': CP,
              'OrderPrice': OP,
              'OrderChange': buttonRes?.orderChange,
            };

            Utils().showLog('Ticker: $logData');
          } else {
            Utils().showLog('order price $symbol => ${buttonRes?.orderPrice}');
          }

          notifyListeners();
        },
        SimulatorEnum.detail,
      );
    } catch (e) {
      //
    }
  }

  Status _statusGraph = Status.ideal;
  Status get statusGraph => _statusGraph;

  bool get isLoadingGraph => _statusGraph == Status.loading;

  List<SdOverviewGraphRes>? _graphChart;
  List<SdOverviewGraphRes>? get graphChart => _graphChart;

  String? _errorGraph;
  String? get errorGraph => _errorGraph ?? Const.errSomethingWrong;

  Extra? _extraGraph;
  Extra? get extraGraph => _extraGraph;

  void clearAll() {
    _errorGraph = null;
  }

  void setStatusOverviewG(status) {
    _statusGraph = status;
    notifyListeners();
  }

  LineChartData avgData({
    bool showDate = true,
  }) {
    List<SdOverviewGraphRes> reversedData =
        _graphChart?.reversed.toList() ?? [];

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
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map(
                  (LineBarSpot touchedSpot) {
                return LineTooltipItem(
                  children: [
                    TextSpan(
                      text: "${touchedSpot.y.toStringAsFixed(2)}\n",
                      style: styleBaseBold(fontSize: 18, fontFamily: 'Roboto'),
                    ),
                    TextSpan(
                      text: !showDate
                          ? DateFormat('dd MMM, yyyy')
                          .format(reversedData[touchedSpot.x.toInt()].date)
                          : '${DateFormat('dd MMM').format(reversedData[touchedSpot.x.toInt()].date)}, ${DateFormat('h:mm a').format(reversedData[touchedSpot.x.toInt()].date)}',
                      style: styleBaseBold(
                          height: 1.5,
                          //  color: ThemeColors.primary,
                          fontSize: 13),
                    ),
                  ],
                  '',
                  styleBaseBold(fontSize: 10),
                );
              },
            ).toList();
          },
          getTooltipColor: (touchedSpot) {
            return ThemeColors.greyText;
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
        show: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: ThemeColors.black,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: ThemeColors.black,
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
            navigatorKey.currentContext!.read<UserManager>().user?.token ?? "",
        "symbol": symbol,
        "range": newRange,
      };

      ApiResponse response = await apiRequest(
        baseUrl: "https://app.stocks.news/api/v1",
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
}

class TournamentTickerHolder {
  TournamentTickerDetailRes? data;
  String? error;
  bool loading;

  TournamentTickerHolder({
    this.data,
    this.loading = true,
    this.error,
  });
}



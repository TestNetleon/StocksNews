import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../modals/stock_screener_res.dart';
import '../../providers/user_provider.dart';
import '../../routes/my_app.dart';
import '../../tradingSimulator/manager/sse.dart';
import '../../tradingSimulator/modals/trading_search_res.dart';
import '../../utils/constants.dart';
import '../models/all_trades.dart';
import '../models/ticker_detail.dart';

enum StockType { buy, sell, hold }

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

  Future getTradesList({
    bool refresh = false,
    showProgress = false,
  }) async {
    if (refresh) {
      _myTrades = null;
      _selectedOverview = null;
    }

    setStatusTrades(Status.loading);

    try {
      TournamentProvider provider =
          navigatorKey.currentContext!.read<TournamentProvider>();
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        'tournament_battle_id':
            '${provider.detailRes?.tournamentBattleId ?? ''}',
        'type': _selectedOverview?.key?.toString().toLowerCase() ?? 'all',
      };

      ApiResponse response = await apiRequest(
        url: Apis.tTradeList,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _myTrades = tournamentAllTradesResFromJson(jsonEncode(response.data));
        _errorTrades = null;
        if (refresh) {
          _selectedOverview = _myTrades?.overview?.first;
        } else {}
      } else {
        _myTrades = null;
        _errorTrades = null;
      }
      setStatusTrades(Status.loaded);
    } catch (e) {
      _myTrades = null;
      _errorTrades = null;
      Utils().showLog('Trades Overview Error: $e');
      setStatusTrades(Status.loaded);
    }
  }

//MARK: BUY/SELL
  Future tradeBuySell({StockType type = StockType.buy}) async {
    try {
      TournamentProvider provider =
          navigatorKey.currentContext!.read<TournamentProvider>();
      Map request = {
        'token':
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        'symbol': _selectedStock?.symbol,
        'tournament_battle_id':
            '${provider.detailRes?.tournamentBattleId ?? ''}',
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
      }

      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog('');
      return ApiResponse(status: false);
    }
  }

//MARK: CANCLE
  Future tradeCancle(
      {bool cancleAll = false, num? tradeId, String? ticker}) async {
    try {
      TournamentProvider provider =
          navigatorKey.currentContext!.read<TournamentProvider>();
      Map request = {
        'token':
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        'ticker_symbol': ticker ?? _selectedStock?.symbol ?? '',
        'tournament_battle_id':
            '${provider.detailRes?.tournamentBattleId ?? ''}',
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
        getDetail(_selectedStock?.symbol ?? '', refresh: true);
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
  TradingSearchTickerRes? _selectedStock;
  TradingSearchTickerRes? get selectedStock => _selectedStock;

  // TournamentTickerDetailRes? _detail;
  // TournamentTickerDetailRes? get detail => _detail;

  Map<String, TournamentTickerHolder?> _detail = {};
  Map<String, TournamentTickerHolder?> get detail => _detail;

  void setSelectedStock({
    TradingSearchTickerRes? stock,
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
      // Prepare the API request
      TournamentProvider provider =
          navigatorKey.currentContext!.read<TournamentProvider>();
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
        'tournament_battle_id':
            '${provider.detailRes?.tournamentBattleId ?? ''}',
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
    TradingSearchTickerRes? tickerData = _detail[symbol]?.data?.ticker;

    if (buttonRes?.orderPrice != null) {
      num CP = tickerData?.currentPrice ?? 0;
      num OP = buttonRes?.orderPrice ?? 0;

      if (buttonRes?.orderType == StockType.buy.name) {
        buttonRes?.orderChange = ((CP - OP) / OP) * 100;
        Utils().showLog('Buy orderChange: ${buttonRes?.orderChange}');
      } else {
        buttonRes?.orderChange = ((OP - CP) / CP) * 100;
        Utils().showLog('Sell orderChange: ${buttonRes?.orderChange}');
      }
    }

    if (_activeTickers.add(symbol)) {
      Utils().showLog('Added $symbol to active tickers');

      SSEManager.instance.connectMultipleStocks(
        screen: SimulatorEnum.detail,
        symbols: _activeTickers.toList(),
      );

      SSEManager.instance.addListener(symbol, (stockData) {
        Utils().showLog(
            'Streaming update for $symbol, Price: ${stockData.price}, Change: ${stockData.change}, Change%: ${stockData.changePercentage}');

        tickerData?.currentPrice = stockData.price;
        tickerData?.change = stockData.change;
        tickerData?.changesPercentage = stockData.changePercentage;

        if (buttonRes?.orderPrice != null) {
          num CP = stockData.price ?? 0;
          num OP = buttonRes?.orderPrice ?? 0;

          if (buttonRes?.orderType == StockType.buy.name) {
            buttonRes?.orderChange = ((CP - OP) / OP) * 100;
          } else {
            buttonRes?.orderChange = ((OP - CP) / CP) * 100;
          }
        }

        notifyListeners();
      });
    } else {
      Utils().showLog('$symbol is already in active tickers, skipping');
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

// class TournamentMyTradesHolder {
//   TournamentAllTradesRes? data;
//   String? error;
//   bool loading;

//   TournamentMyTradesHolder({
//     this.data,
//     this.loading = true,
//     this.error,
//   });
// }

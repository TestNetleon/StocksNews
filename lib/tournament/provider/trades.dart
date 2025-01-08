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
import '../models/ticker_detail.dart';

enum StockType { buy, sell, hold }

class TournamentTradesProvider extends ChangeNotifier {
  //MARK: Trades Overview
  List<KeyValueElementStockScreener>? _tradesOverview;
  List<KeyValueElementStockScreener>? get tradesOverview => _tradesOverview;

  Status _statusOverview = Status.ideal;
  Status get statusOverview => _statusOverview;

  bool get isLoadingOverview =>
      _statusOverview == Status.loading || _statusOverview == Status.ideal;

  String? _errorOverview;
  String? get errorOverview => _errorOverview ?? Const.errSomethingWrong;

  KeyValueElementStockScreener? _selectedOverview;
  KeyValueElementStockScreener? get selectedOverview => _selectedOverview;

  void setSelectedOverview(KeyValueElementStockScreener? data,
      {bool refresh = false}) {
    if (_selectedOverview != data) {
      _selectedOverview = data;
      notifyListeners();
      getTradesList(refresh: refresh);
    }
  }

  void setStatusOverview(status) {
    _statusOverview = status;
    notifyListeners();
  }

  Future getTradesOverview({bool resetIndex = false}) async {
    setStatusOverview(Status.loading);
    try {
      TournamentProvider provider =
          navigatorKey.currentContext!.read<TournamentProvider>();
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        'tournament_battle_id':
            '${provider.detailRes?.tournamentBattleId ?? ''}',
      };

      ApiResponse response = await apiRequest(
        url: Apis.tTradeOverview,
        request: request,
      );
      if (response.status) {
        _tradesOverview = (response.data as List)
            .map((item) => KeyValueElementStockScreener.fromJson(item))
            .toList();
        _errorOverview = null;
        if (resetIndex) setSelectedOverview(_tradesOverview?[0], refresh: true);
      } else {
        _tradesOverview = null;
        _errorOverview = response.message;
      }
      setStatusOverview(Status.loaded);
    } catch (e) {
      _tradesOverview = null;
      _errorOverview = Const.errSomethingWrong;
      Utils().showLog('trades overview $e');
      setStatusOverview(Status.loaded);
    }
  }

//MARK: All Trades

  final Map<String, TournamentMyTradesHolder> _myTrades = {};
  Map<String, TournamentMyTradesHolder>? get myTrades => _myTrades;

  Future getTradesList({bool refresh = false}) async {
    // if (_myTrades[_selectedOverview?.key]?.data != null && !refresh) {
    //   Utils().showLog('Data already exists, returning...');
    //   return;
    // }

    _myTrades[_selectedOverview?.key] = TournamentMyTradesHolder(
      data: null,
      error: null,
      loading: true,
    );
    notifyListeners();

    try {
      TournamentProvider provider =
          navigatorKey.currentContext!.read<TournamentProvider>();
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        'tournament_battle_id':
            '${provider.detailRes?.tournamentBattleId ?? ''}',
        'type': '${_selectedOverview?.key.toString().toLowerCase()}',
      };

      ApiResponse response = await apiRequest(
        url: Apis.tTradeList,
        request: request,
      );

      if (response.status) {
        _myTrades[_selectedOverview?.key] = TournamentMyTradesHolder(
          data: tradingSearchTickerResFromJson(jsonEncode(response.data)),
          error: null,
          loading: false,
        );
      } else {
        if (_myTrades[_selectedOverview?.key]?.data == null) {
          _myTrades[_selectedOverview?.key] = TournamentMyTradesHolder(
            data: null,
            error: response.message,
            loading: false,
          );
        }
      }
      notifyListeners();
    } catch (e) {
      _myTrades[_selectedOverview?.key] = TournamentMyTradesHolder(
        data: null,
        error: Const.errSomethingWrong,
        loading: false,
      );
      Utils().showLog('Trades Overview Error: $e');
      notifyListeners();
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
        'ticker_symbol': _selectedStock?.symbol,
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
  Future tradeCancle({bool cancleAll = false}) async {
    try {
      TournamentProvider provider =
          navigatorKey.currentContext!.read<TournamentProvider>();
      Map request = {
        'token':
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        'ticker_symbol': _selectedStock?.symbol,
        'tournament_battle_id':
            '${provider.detailRes?.tournamentBattleId ?? ''}',
        'trade_id': cancleAll
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

        // Add the symbol to active tickers only if it's not already present
        if (_activeTickers.add(symbol)) {
          Utils().showLog('Added $symbol to active tickers');

          // Connect to the streaming manager with updated tickers
          SSEManager.instance.connectMultipleStocks(
            screen: SimulatorEnum.detail,
            symbols: _activeTickers.toList(),
          );

          // Add a listener for the symbol
          SSEManager.instance.addListener(symbol, (stockData) {
            Utils().showLog(
                'Streaming update for $symbol, Price: ${stockData.price}, Change: ${stockData.change}, Change%: ${stockData.changePercentage}');

            // Update the _detail map with the streaming data
            _detail[symbol]?.data?.ticker?.currentPrice = stockData.price;
            _detail[symbol]?.data?.ticker?.change = stockData.change;
            _detail[symbol]?.data?.ticker?.changesPercentage =
                stockData.changePercentage;

            // Notify listeners to update the UI
            notifyListeners();
          });
        } else {
          Utils().showLog(
              '$symbol is already in active tickers, skipping re-addition.');
        }
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

class TournamentMyTradesHolder {
  List<TradingSearchTickerRes>? data;
  String? error;
  bool loading;

  TournamentMyTradesHolder({
    this.data,
    this.loading = true,
    this.error,
  });
}

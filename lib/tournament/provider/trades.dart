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
import '../../tradingSimulator/modals/trading_search_res.dart';
import '../../utils/constants.dart';
import '../models/ticker_detail.dart';

enum StockType { buy, sell }

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

  void setSelectedOverview(KeyValueElementStockScreener? data) {
    _selectedOverview = data;
    notifyListeners();
    getTradesList();
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
        if (resetIndex) setSelectedOverview(_tradesOverview?[0]);
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

  Future getTradesList() async {
    setStatus(Status.loading);
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
        url: Apis.tTradeList,
        request: request,
      );
      if (response.status) {
      } else {
        //
      }
      setStatus(Status.loaded);
    } catch (e) {
      Utils().showLog('trades overview $e');
      setStatus(Status.loaded);
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
        getDetail(request['ticker_symbol']);
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
  Future tradeCancle(request) async {
    try {
      ApiResponse response = await apiRequest(
        url: Apis.tCancle,
        request: request,
        showProgress: true,
      );
      if (response.status) {
        //
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

  TournamentTickerDetailRes? _detail;
  TournamentTickerDetailRes? get detail => _detail;

  void setSelectedStock({TradingSearchTickerRes? stock}) {
    if (stock != null) {
      _selectedStock = stock;
      notifyListeners();

      if (stock.symbol != null && stock.symbol != '') {
        getDetail(stock.symbol ?? '');
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

  Future getDetail(String symbol) async {
    TournamentProvider provider =
        navigatorKey.currentContext!.read<TournamentProvider>();
    setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
        'tournament_battle_id':
            '${provider.detailRes?.tournamentBattleId ?? ''}',
      };

      ApiResponse response = await apiRequest(
        url: Apis.tTickerDetail,
        request: request,
      );
      if (response.status) {
        _detail = tournamentTickerDetailResFromJson(jsonEncode(response.data));
        _error = null;
      } else {
        _detail = null;
        _error = response.message;
      }
      setStatus(Status.loaded);
    } catch (e) {
      _detail = null;
      _error = null;
      Utils().showLog('error $e');
      setStatus(Status.loaded);
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/modals/search_res.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/show_button_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/trades.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';


class TournamentSearchProvider extends ChangeNotifier {
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading;
  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  String? _error;
  String? get error => _error;

  List<BaseTickerRes>? _topSearch;
  List<BaseTickerRes>? get topSearch => _topSearch;

  Future getSearchDefaults() async {
    setStatus(Status.loading);
    try {
      TournamentProvider provider =
          navigatorKey.currentContext!.read<TournamentProvider>();
      TournamentTradesProvider tradesProvider =
          navigatorKey.currentContext!.read<TournamentTradesProvider>();
      Map request = {
        "token": navigatorKey.currentContext!.read<UserManager>().user?.token ?? "",
        "tournament_battle_id":
            '${tradesProvider.myTrades?.tournamentBattleId ?? provider.detailRes?.tournamentBattleId ?? ''}',
      };

      ApiResponse response = await apiRequest(
        url: Apis.tTickerList,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _topSearch = baseTickerResFromJson(jsonEncode(response.data));
        TournamentTradesProvider provider =
            navigatorKey.currentContext!.read<TournamentTradesProvider>();
        clearSearch();
        provider.setSelectedStock(
          stock: _topSearch?[0],
          refresh: true,
          clearEverything: true,
        );
      } else {
        _topSearch = null;
      }
      setStatus(Status.loaded);
    } catch (e) {
      _topSearch = null;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future getSearchDefaultsInSearch() async {
    Utils().showLog('called');
    setStatus(Status.loading);
    try {
      TournamentProvider provider =
          navigatorKey.currentContext!.read<TournamentProvider>();
      Map request = {
        "token": navigatorKey.currentContext!.read<UserManager>().user?.token ?? "",
        "tournament_battle_id":
            '${provider.detailRes?.tournamentBattleId ?? ''}',
      };

      ApiResponse response = await apiRequest(
        url: Apis.tTickerList,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _topSearch = baseTickerResFromJson(jsonEncode(response.data));
        TournamentTradesProvider provider =
            navigatorKey.currentContext!.read<TournamentTradesProvider>();
        clearSearch();

        provider.setSelectedStock(
          stock: _topSearch?[0],
          refresh: true,
          clearEverything: true,
        );
      } else {
        _topSearch = null;
      }
      setStatus(Status.loaded);
    } catch (e) {
      _topSearch = null;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  void _startSseTrades() {
    List<String>? symbols;
    if (_topSearch != null && _topSearch?.isNotEmpty == true) {
      symbols = _topSearch?.map((trade) => trade.symbol!).toList();
    }
    Utils().showLog('stream');
    if (_topSearch != null) {
      Utils().showLog('stream1');
      List<BaseTickerRes> dataTrade = _topSearch ?? [];

      for (var data in dataTrade) {
        Utils().showLog('stream2');
        num currentPrice = data.price ?? 0;
        num orderPrice = data.orderPrice ?? 0;

        if (symbols != null && symbols.isNotEmpty == true) {
          if (data.sType == StockType.buy) {
            data.orderChange = orderPrice == 0 || currentPrice == 0
                ? 0
                : (((currentPrice - orderPrice) / orderPrice) * 100);
          } else {
            data.orderChange = currentPrice == 0 || orderPrice == 0
                ? 0
                : (((orderPrice - currentPrice) / currentPrice) * 100);
          }

          notifyListeners();
          SSEManager.instance.connectMultipleStocks(
            symbols: symbols,
            screen: SimulatorEnum.detail,
          );

          SSEManager.instance.addListener(
            data.symbol ?? '',
            (stockData) {
              data.price = stockData.price;
              data.change = stockData.change;
              data.changesPercentage = stockData.changePercentage;
              num? newPrice = stockData.price;
              if (newPrice != null) {
                if (data.sType == StockType.buy) {
                  data.orderChange =
                      (((newPrice - orderPrice) / orderPrice) * 100);
                } else {
                  data.orderChange =
                      (((orderPrice - newPrice) / newPrice) * 100);
                }
              }
              Utils().showLog(
                  'Recent Activities ${data.symbol}, ${data.orderChange},${data.price}');
              notifyListeners();
            },
            SimulatorEnum.detail,
          );
        }
      }
    }
  }

  String? _errorSearch;
  String? get errorSearch => _errorSearch ?? Const.errSomethingWrong;

  Status _statusS = Status.ideal;
  Status get statusS => _statusS;
  bool get isLoadingS => _statusS == Status.loading;

  List<SearchRes>? _dataNew;
  List<SearchRes>? get dataNew => _dataNew;

  void setStatusSearch(status) {
    _statusS = status;
    notifyListeners();
  }

  void clearSearch() {
    _dataNew = null;
    _statusS = Status.ideal;
    notifyListeners();
  }

  Future searchSymbols(request, {showProgress = false}) async {
    setStatusSearch(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.tTickerSearch,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _dataNew = searchResFromJson(jsonEncode(response.data));
      } else {
        _dataNew = null;
      }
      setStatusSearch(Status.loaded);
    } catch (e) {
      _dataNew = null;

      Utils().showLog(e.toString());
      setStatusSearch(Status.loaded);
    }
  }

  StockDataManagerRes? _tappedStock;
  StockDataManagerRes? get tappedStock => _tappedStock;

  setTappedStock(StockDataManagerRes? stock, ShowButtonRes? showButton) {
    try {
      ShowButtonRes? buttonRes = showButton;
      _tappedStock = null;
      _tappedStock = stock;
      notifyListeners();

      SSEManager.instance.connectStock(
        symbol: stock?.symbol ?? "",
        screen: SimulatorEnum.tradeSheet,
      );

      SSEManager.instance.addListener(
        stock?.symbol ?? '',
        (data) {
          _tappedStock = data;
          _tappedStock?.price = data.price;
          _tappedStock?.change = data.change;
          _tappedStock?.changePercentage = data.changePercentage;
          if (buttonRes?.orderPrice != null) {
            num CP = data.price ?? 0;
            num OP = buttonRes?.orderPrice ?? 0;

            if (buttonRes?.orderType == StockType.buy.name) {
              buttonRes?.orderChange = (((CP - OP) / OP) * 100);
            } else {
              buttonRes?.orderChange = (((OP - CP) / CP) * 100);
            }
            Map<String, dynamic> logData = {
              'Symbol': stock?.symbol ?? '',
              'CurrentPrice': CP,
              'OrderPrice': OP,
              'OrderChange': buttonRes?.orderChange,
            };

            Utils().showLog('tradeSheet: $logData');
          }
          notifyListeners();
        },
        SimulatorEnum.tradeSheet,
      );
    } catch (e) {
      Utils().showLog('---$e');
    }
  }
}

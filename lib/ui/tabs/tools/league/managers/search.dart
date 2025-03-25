import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/search.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/trades.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/show_button_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class LeagueSearchManager extends ChangeNotifier {
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading;
  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  String? _error;
  String? get error => _error;

  BaseSearchRes? _tickersData;
  BaseSearchRes? get tickersData => _tickersData;

  Future getTickersList() async {
    setStatus(Status.loading);
    try {
      LeagueManager manager = navigatorKey.currentContext!.read<LeagueManager>();
      TradesManger tradesManger = navigatorKey.currentContext!.read<TradesManger>();
      Map request = {
        "tournament_battle_id": '${tradesManger.myTrades?.tournamentBattleId ?? manager.detailRes?.tournamentBattleId ?? ''}',
      };
      ApiResponse response = await apiRequest(
        url: Apis.tTickerList,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _tickersData = baseSearchResFromJson(jsonEncode(response.data));
        TradesManger tradesManger = navigatorKey.currentContext!.read<TradesManger>();
        tradesManger.setSelectedStock(
          stock: _tickersData?.symbols?.data?[0],
          refresh: true,
          clearEverything: true,
        );
        _error = null;
      } else {
        _tickersData = null;
        _error=response.message;
      }
    } catch (e) {
      _tickersData = null;
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
    }
    finally{
      setStatus(Status.loaded);

    }
  }

  Status _recentStatus = Status.ideal;
  Status get recentStatus => _recentStatus;
  bool get isLoadingRecent => _recentStatus == Status.loading;
  void setRecentStatus(status) {
    _recentStatus = status;
    notifyListeners();
  }

  String? _errorRecent;
  String? get errorRecent => _errorRecent;

  BaseSearchRes? _recentSearchData;
  BaseSearchRes? get recentSearchData => _recentSearchData;

  Future getSearchDefaults() async {
    try {
      setRecentStatus(Status.loading);
      LeagueManager manager = navigatorKey.currentContext!.read<LeagueManager>();
      TradesManger tradesManger = navigatorKey.currentContext!.read<TradesManger>();
      Map request = {
        "tournament_battle_id": '${tradesManger.myTrades?.tournamentBattleId ?? manager.detailRes?.tournamentBattleId ?? ''}',
      };
      ApiResponse response = await apiRequest(
        url: Apis.tTickerList,
        request: request,
      );

      if (response.status) {
        _recentSearchData = baseSearchResFromJson(jsonEncode(response.data));
        _errorRecent = null;
      } else {
        _recentSearchData = null;
        _errorRecent=response.message;
      }
    } catch (e) {
      _recentSearchData = null;
      _errorRecent = Const.errSomethingWrong;
      Utils().showLog('join error $e');
    }
    finally{
      setRecentStatus(Status.loaded);
    }
  }


  String? _errorSearch;
  String? get errorSearch => _errorSearch;

  Status _statusS = Status.ideal;
  Status get statusS => _statusS;
  bool get isLoadingS => _statusS == Status.loading;


  BaseSearchRes? _searchData;
  BaseSearchRes? get searchData => _searchData;



  void setStatusSearch(status) {
    _statusS = status;
    notifyListeners();
  }


  void clearSearch() {
    _searchData = null;
    _errorSearch = null;
    _errorRecent = null;
    _recentSearchData = null;
    notifyListeners();
  }


  Future searchSymbols(request) async {
    setStatusSearch(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.tTickerSearch,
        request: request,
      );
      if (response.status) {
        if (response.data != null) {
          _searchData = baseSearchResFromJson(jsonEncode(response.data));
        } else {
          _searchData = null;
        }
        _errorSearch = response.message;
      } else {
        _searchData = null;
        _errorSearch = null;
      }
    } catch (e) {
      _searchData = null;
      _errorSearch = Const.errSomethingWrong;
      Utils().showLog(e.toString());
    }
    finally{
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

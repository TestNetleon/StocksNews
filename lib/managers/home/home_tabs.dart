import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/market/most_bullish.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class HomeTabsManager extends ChangeNotifier {
  //MARK: Clear Data
  void clearAllData() {
    _dataTrending = null;
    _dataTopLosers = null;
    _dataTopLosers = null;
    notifyListeners();
  }

  //MARK: Trending
  String? _errorTrending;
  String? get errorTrending => _errorTrending ?? Const.errSomethingWrong;

  Status _statusTrending = Status.ideal;
  Status get statusTrending => _statusTrending;

  bool get isLoadingTrending =>
      _statusTrending == Status.loading || _statusTrending == Status.ideal;

  MarketDataRes? _dataTrending;
  MarketDataRes? get dataTrending => _dataTrending;

  //home trending visibility
  bool _homeTrendingLoaded = false;
  bool get homeTrendingLoaded => _homeTrendingLoaded;

  setTrendingLoaded(bool loaded) {
    _homeTrendingLoaded = loaded;
    if (!loaded) {
      _dataTrending = null;
      _errorTrending = null;
    }
    notifyListeners();
  }

  setStatusTrending(status) {
    _statusTrending = status;
    notifyListeners();
  }

  Future getHomeTrending() async {
    try {
      setStatusTrending(Status.loading);
      Map request = {"type": "actives"};
      ApiResponse response = await apiRequest(
        url: Apis.homeTrendingGainerLoser,
        request: request,
      );
      if (response.status) {
        _dataTrending = marketDataResFromJson(jsonEncode(response.data));
        _errorTrending = null;

        // ScriptsManager scriptsManager =
        //     navigatorKey.currentContext!.read<ScriptsManager>();
        // List<String> symbols = _dataTrending?.data
        //         ?.map((item) => item.symbol)
        //         .whereType<String>()
        //         .toList() ??
        //     [];

        // scriptsManager.runSymbolScripts(symbols: symbols, reset: true);
      } else {
        _dataTrending = null;
        _errorTrending = response.message;
      }
      setStatusTrending(Status.loaded);
    } catch (e) {
      _dataTrending = null;
      _errorTrending = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.myHome}: $e');
      setStatusTrending(Status.loaded);
    }
  }

  //MARK: TopGainers
  String? _errorTopGainers;
  String? get errorTopGainers => _errorTopGainers ?? Const.errSomethingWrong;

  Status _statusTopGainers = Status.ideal;
  Status get statusTopGainers => _statusTopGainers;

  bool get isLoadingTopGainers =>
      _statusTopGainers == Status.loading || _statusTopGainers == Status.ideal;

  MarketDataRes? _dataTopGainers;
  MarketDataRes? get dataTopGainers => _dataTopGainers;

  setStatusTopGainers(status) {
    _statusTopGainers = status;
    notifyListeners();
  }

  Future getHomeTopGainers() async {
    try {
      setStatusTopGainers(Status.loading);
      Map request = {"type": "gainers"};
      ApiResponse response = await apiRequest(
        url: Apis.homeTrendingGainerLoser,
        request: request,
      );
      if (response.status) {
        _dataTopGainers = marketDataResFromJson(jsonEncode(response.data));
        _errorTopGainers = null;
      } else {
        _dataTopGainers = null;
        _errorTopGainers = response.message;
      }
      setStatusTopGainers(Status.loaded);
    } catch (e) {
      _dataTopGainers = null;
      _errorTopGainers = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.myHome}: $e');
      setStatusTopGainers(Status.loaded);
    }
  }

  //MARK: TopLosers
  String? _errorTopLosers;
  String? get errorTopLosers => _errorTopLosers ?? Const.errSomethingWrong;

  Status _statusTopLosers = Status.ideal;
  Status get statusTopLosers => _statusTopLosers;

  bool get isLoadingTopLosers =>
      _statusTopLosers == Status.loading || _statusTopLosers == Status.ideal;

  MarketDataRes? _dataTopLosers;
  MarketDataRes? get dataTopLosers => _dataTopLosers;

  setStatusTopLosers(status) {
    _statusTopLosers = status;
    notifyListeners();
  }

  Future getHomeTopLosers() async {
    try {
      setStatusTopLosers(Status.loading);
      Map request = {"type": "losers"};
      ApiResponse response = await apiRequest(
        url: Apis.homeTrendingGainerLoser,
        request: request,
      );
      if (response.status) {
        _dataTopLosers = marketDataResFromJson(jsonEncode(response.data));
        _errorTopLosers = null;
      } else {
        _dataTopLosers = null;
        _errorTopLosers = response.message;
      }
      setStatusTopLosers(Status.loaded);
    } catch (e) {
      _dataTopLosers = null;
      _errorTopLosers = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.myHome}: $e');
      setStatusTopLosers(Status.loaded);
    }
  }

  //MARK: TopLosers
  void updateTickerInfo({required String symbol, alertAdded, watchListAdded}) {
    if (_dataTrending?.data != null) {
      final index = _dataTrending?.data
          ?.indexWhere((element) => element.symbol == symbol);
      if (index != null && index != -1) {
        if (alertAdded != null) {
          _dataTrending?.data![index].isAlertAdded = alertAdded;
        }
        if (watchListAdded != null) {
          _dataTrending?.data![index].isWatchlistAdded = watchListAdded;
        }
        notifyListeners();
      }
    }
    if (_dataTopGainers?.data != null) {
      final index = _dataTopGainers?.data
          ?.indexWhere((element) => element.symbol == symbol);
      if (index != null && index != -1) {
        if (alertAdded != null) {
          _dataTopGainers?.data![index].isAlertAdded = alertAdded;
        }
        if (watchListAdded != null) {
          _dataTopGainers?.data![index].isWatchlistAdded = watchListAdded;
        }
        notifyListeners();
      }
    }
    if (_dataTopLosers?.data != null) {
      final index = _dataTopLosers?.data
          ?.indexWhere((element) => element.symbol == symbol);
      if (index != null && index != -1) {
        if (alertAdded != null) {
          _dataTopLosers?.data![index].isAlertAdded = alertAdded;
        }
        if (watchListAdded != null) {
          _dataTopLosers?.data![index].isWatchlistAdded = watchListAdded;
        }
        notifyListeners();
      }
    }
  }
}

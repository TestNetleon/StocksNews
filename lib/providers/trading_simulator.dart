import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/route/my_app.dart';

import '../api/api_requester.dart';
import '../api/api_response.dart';
import '../api/apis.dart';
import '../modals/search_new.dart';
import '../modals/top_search_res.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import 'user_provider.dart';

class TradingSimulatorProvider extends ChangeNotifier {
  bool _isBuy = true;
  bool get isBuy => _isBuy;

  SimulatorBalanceRes userPortfolio = SimulatorBalanceRes(
    currentBalance: 100000,
    invested: 0,
  );

  List<SimulatorTradeRes> trades = [];

  void changeType(bool isBuy) {
    _isBuy = isBuy;
    notifyListeners();
  }

  void clearAll() {
    _isBuy = true;
    notifyListeners();
  }

  void buyStock(SimulatorTradeRes trade) {
    trades.add(trade);
    notifyListeners();
  }

  void sellStock(SimulatorTradeRes trade) {
    trades.add(trade);
    notifyListeners();
  }

  //  Top Search Trade
  List<TopSearch>? _topSearch;
  List<TopSearch>? get topSearch => _topSearch;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  void setStatusTop(status) {
    _status = status;
    notifyListeners();
  }

  Future getSearchDefaults() async {
    setStatusTop(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? ""
      };

      ApiResponse response = await apiRequest(
        url: Apis.getMostSearch,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _topSearch = topSearchFromJson(jsonEncode(response.data));
      } else {
        _topSearch = null;
        _error = response.message;
      }
      setStatusTop(Status.loaded);
    } catch (e) {
      _topSearch = null;
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatusTop(Status.loaded);
    }
  }

  // Search API
  void clearSearch() {
    _dataNew = null;
    notifyListeners();
  }

  SearchNewRes? _dataNew;
  SearchNewRes? get dataNew => _dataNew;

  Status _statusS = Status.ideal;
  Status get statusS => _statusS;

  bool get isLoadingS => _statusS == Status.loading;

  String? _errorS;
  String? get errorS => _errorS ?? Const.errSomethingWrong;

  void setStatusSearch(status) {
    _statusS = status;
    notifyListeners();
  }

  Future searchSymbols(request, {showProgress = false}) async {
    setStatusSearch(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.searchWithNews,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _dataNew = searchNewResFromJson(jsonEncode(response.data));
      } else {
        _dataNew = null;
        _errorS = response.message;
      }
      setStatusSearch(Status.loaded);
    } catch (e) {
      _dataNew = null;
      _errorS = Const.errSomethingWrong;

      Utils().showLog(e.toString());
      setStatusSearch(Status.loaded);
    }
  }
}

class SimulatorBalanceRes {
  num currentBalance;
  num invested;

  SimulatorBalanceRes({
    required this.currentBalance,
    required this.invested,
  });
}

class SimulatorTradeRes {
  String? image, name, price, change;
  num? changePercentage, invested, current, shares;
  DateTime? date;
  bool isBuy;

  SimulatorTradeRes({
    required this.isBuy,
    this.image,
    this.name,
    this.price,
    this.change,
    this.changePercentage,
    this.invested,
    this.current,
    this.shares,
    this.date,
  });
}

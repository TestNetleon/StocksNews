import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../../api/api_requester.dart';
import '../../api/api_response.dart';
import '../../api/apis.dart';
import '../../models/stockDetail/historical_chart.dart';
import '../../models/stockDetail/overview.dart';
import '../../models/stockDetail/tabs.dart';
import '../../routes/my_app.dart';
import '../../utils/constants.dart';
import '../user.dart';

class StocksDetailManager extends ChangeNotifier {
  //MARK: Stock Detail Tab
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading;

  StocksDetailRes? _data;
  StocksDetailRes? get data => _data;

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;

  MarketResData? _selectedTab;
  MarketResData? get selectedTab => _selectedTab;

  String? _selectedStock;
  String? get selectedStock => _selectedStock;

  onTabChange(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      _selectedTab = _data?.tabs?[index];
      notifyListeners();

      switch (index) {
        case 0:
          _dataHistoricalC = null;
          notifyListeners();
          getStocksDetailOverview();
          getStocksDetailHistoricalC();

          break;
        default:
      }
    }
  }

  Future getStocksDetailTab(String symbol) async {
    _data = null;
    _selectedIndex = -1;
    _selectedStock = symbol;
    if (symbol == '') return;
    try {
      setStatus(Status.loading);
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': symbol,
      };

      ApiResponse response = await apiRequest(
        url: Apis.stockDetailTab,
        request: request,
      );
      if (response.status) {
        _data = stocksDetailResFromJson(jsonEncode(response.data));
        onTabChange(0);
        _error = null;
      } else {
        _data = null;
        _error = response.message;
      }
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.stockDetailTab}: $e');
    } finally {
      setStatus(Status.loaded);
    }
  }

  //MARK: Stock Overview
  String? _errorOverview;
  String? get errorOverview => _errorOverview ?? Const.errSomethingWrong;

  Status _statusOverview = Status.ideal;
  Status get statusOverview => _statusOverview;

  bool get isLoadingOverview => _statusOverview == Status.loading;

  StocksDetailOverviewRes? _dataOverview;
  StocksDetailOverviewRes? get dataOverview => _dataOverview;

  setStatusOverview(status) {
    _statusOverview = status;
    notifyListeners();
  }

  Future getStocksDetailOverview() async {
    if (_selectedStock == '') return;
    try {
      setStatusOverview(Status.loading);
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _selectedStock,
      };

      ApiResponse response = await apiRequest(
        url: Apis.stockDetailOverview,
        request: request,
      );
      if (response.status) {
        _dataOverview =
            stocksDetailOverviewResFromJson(jsonEncode(response.data));
        _errorOverview = null;
      } else {
        _dataOverview = null;
        _errorOverview = response.message;
      }
    } catch (e) {
      _dataOverview = null;
      _errorOverview = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.stockDetailOverview}: $e');
    } finally {
      setStatusOverview(Status.loaded);
    }
  }

  //MARK: Stock Historical
  String? _errorHistoricalC;
  String? get errorHistoricalC => _errorHistoricalC ?? Const.errSomethingWrong;

  Status _statusHistoricalC = Status.ideal;
  Status get statusHistoricalC => _statusHistoricalC;

  bool get isLoadingHistoricalC => _statusHistoricalC == Status.loading;

  StocksDetailHistoricalChartRes? _dataHistoricalC;
  StocksDetailHistoricalChartRes? get dataHistoricalC => _dataHistoricalC;

  setStatusHistoricalC(status) {
    _statusHistoricalC = status;
    notifyListeners();
  }

  Future getStocksDetailHistoricalC({String range = '1hour'}) async {
    if (_selectedStock == '') return;

    try {
      setStatusHistoricalC(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _selectedStock,
        'range': range,
      };

      ApiResponse response = await apiRequest(
        url: Apis.stockDetailHistoricalC,
        request: request,
        showProgress: _dataHistoricalC != null,
      );
      if (response.status) {
        _dataHistoricalC =
            stocksDetailHistoricalChartResFromJson(jsonEncode(response.data));
        _errorHistoricalC = null;
      } else {
        _dataHistoricalC = null;
        _errorHistoricalC = response.message;
      }
    } catch (e) {
      _dataHistoricalC = null;
      _errorHistoricalC = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.stockDetailHistoricalC}: $e');
    } finally {
      setStatusHistoricalC(Status.loaded);
    }
  }
}

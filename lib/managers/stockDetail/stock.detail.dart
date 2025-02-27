import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/market/market_res.dart';

import '../../api/api_requester.dart';
import '../../api/api_response.dart';
import '../../api/apis.dart';
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

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  MarketResData? _selectedTab;
  MarketResData? get selectedTab => _selectedTab;
  onTabChange(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      _selectedTab = _data?.tabs?[index];
      notifyListeners();
    }
  }

  Future getStocksDetailTab(String symbol) async {
    _data = null;
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
    } finally {
      setStatus(Status.loaded);
    }
  }
}

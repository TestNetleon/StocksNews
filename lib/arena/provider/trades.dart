import 'package:flutter/material.dart';

import '../../tradingSimulator/modals/trading_search_res.dart';

enum StockType { bull, bear }

class TradesProvider extends ChangeNotifier {
  final List<TradingSearchTickerRes> _data = [];
  List<TradingSearchTickerRes> get data => _data;

  void addInTrade(TradingSearchTickerRes stock) {
    _data.add(stock);
    notifyListeners();
  }

  void closeStock(TradingSearchTickerRes stock) {
    int index = _data.indexWhere((element) => element.symbol == stock.symbol);

    if (index != -1) {
      _data[index] = TradingSearchTickerRes(
        symbol: _data[index].symbol,
        name: _data[index].name,
        image: _data[index].image,
        change: _data[index].change,
        type: _data[index].type,
        isOpen: false,
      );
      notifyListeners();
    }
  }

  void clearTrades() {
    _data.clear();
    notifyListeners();
  }
}

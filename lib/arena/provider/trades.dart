import 'package:flutter/material.dart';
import '../../tradingSimulator/modals/trading_search_res.dart';

enum StockType { bull, bear }

class TradesProvider extends ChangeNotifier {
  final List<TradingSearchTickerRes> _data = [];
  List<TradingSearchTickerRes> get data => _data;

  void addInTrade(TradingSearchTickerRes stock) {
    _data.add(stock);
    _updateTradeCounts();
    notifyListeners();
  }

  void closeStock(TradingSearchTickerRes stock) {
    int index = _data.indexWhere((element) => element.symbol == stock.symbol);

    if (index != -1) {
      // Update the stock to be closed
      TradingSearchTickerRes updatedStock = TradingSearchTickerRes(
        symbol: _data[index].symbol,
        name: _data[index].name,
        image: _data[index].image,
        change: _data[index].change,
        type: _data[index].type,
        isOpen: false,
      );

      // Remove the stock from its current position
      _data.removeAt(index);

      // Find the correct position to insert the stock
      int insertIndex = _data.indexWhere((item) => item.isOpen == false);
      if (insertIndex == -1) {
        // If no closed stocks exist, append at the end
        _data.add(updatedStock);
      } else {
        // Insert just above the first closed stock
        _data.insert(insertIndex, updatedStock);
      }

      // Update counts and notify listeners
      _updateTradeCounts();
      notifyListeners();
    }
  }

  void clearTrades() {
    _data.clear();
    _updateTradeCounts();
    notifyListeners();
  }

  final List<TradesTypeRes> _trades = [
    TradesTypeRes(
      name: 'All',
      total: 0,
    ),
    TradesTypeRes(
      name: 'Open',
      total: 0,
    ),
    TradesTypeRes(
      name: 'Closed',
      total: 0,
    ),
  ];
  List<TradesTypeRes> get trades => _trades;

  void _updateTradeCounts() {
    final openTrades = _data.where((trade) => trade.isOpen == true).length;
    final closedTrades = _data.where((trade) => trade.isOpen == false).length;

    _trades[0].total = _data.length; // All
    _trades[1].total = openTrades; // Open
    _trades[2].total = closedTrades; // Closed
    notifyListeners();
  }
}

class TradesTypeRes {
  String name;
  num? total;
  TradesTypeRes({
    required this.name,
    this.total,
  });
}

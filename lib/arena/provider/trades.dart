import 'package:flutter/material.dart';

enum StockType { bull, bear }

class TradesProvider extends ChangeNotifier {
  List<ArenaStockRes> _data = [];
  List<ArenaStockRes> get data => _data;

  void addInTrade(ArenaStockRes stock) {
    _data.add(stock);
    notifyListeners();
  }

  void closeStock(ArenaStockRes stock) {
    int index = _data.indexWhere((element) => element.symbol == stock.symbol);

    if (index != -1) {
      _data[index] = ArenaStockRes(
        symbol: _data[index].symbol,
        company: _data[index].company,
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

class ArenaStockRes {
  final String symbol;
  final String company;
  final String image;
  final num change;
  final StockType? type;
  bool isOpen;

  ArenaStockRes({
    required this.symbol,
    required this.company,
    required this.image,
    required this.change,
    this.type,
    this.isOpen = false,
  });
}

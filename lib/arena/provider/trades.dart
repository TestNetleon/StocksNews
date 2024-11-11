import 'package:flutter/material.dart';

enum StockType { bull, bear }

class TradesProvider extends ChangeNotifier {
  List<ArenaStockRes> _data = [];
  List<ArenaStockRes> get data => _data = [];

  void addInTrade(ArenaStockRes stock) {
    _data.add(stock);
    notifyListeners();
  }
}

class ArenaStockRes {
  final String symbol;
  final String company;
  final String image;
  final num change;
  final StockType type;
  final bool isOpen;
  ArenaStockRes({
    required this.symbol,
    required this.company,
    required this.image,
    required this.change,
    required this.type,
    this.isOpen = true,
  });
}

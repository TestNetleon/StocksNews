import 'dart:convert';

import '../../tournament/provider/trades.dart';

List<TradingSearchTickerRes> tradingSearchTickerResFromJson(String str) =>
    List<TradingSearchTickerRes>.from(
        json.decode(str).map((x) => TradingSearchTickerRes.fromJson(x)));

String tradingSearchTickerResToJson(List<TradingSearchTickerRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TradingSearchTickerRes {
  final String? symbol;
  final String? name;
  final String? image;
  String? price;
  final num? change;
  final num? changesPercentage;
  final StockType? type;
  bool? isOpen;
  final num? currentPrice;

  TradingSearchTickerRes({
    this.symbol,
    this.name,
    this.image,
    this.price,
    this.change,
    this.changesPercentage,
    this.isOpen = false,
    this.type,
    this.currentPrice,
  });

  factory TradingSearchTickerRes.fromJson(Map<String, dynamic> json) =>
      TradingSearchTickerRes(
        symbol: json["symbol"],
        name: json["name"],
        currentPrice: json['current_price'],
        image: json["image"],
        price: json["price"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "image": image,
        "price": price,
        "change": change,
        'current_price': currentPrice,
        "changesPercentage": changesPercentage,
      };
}

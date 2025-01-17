import 'dart:convert';

import '../../tournament/provider/trades.dart';

List<TradingSearchTickerRes> tradingSearchTickerResFromJson(String str) =>
    List<TradingSearchTickerRes>.from(
        json.decode(str).map((x) => TradingSearchTickerRes.fromJson(x)));

String tradingSearchTickerResToJson(List<TradingSearchTickerRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TradingSearchTickerRes {
  final int? id;
  final String? symbol;
  final String? name;
  final String? image;
  String? price;
  num? change;
  num? changesPercentage;
  final StockType? type;
  final int? status;
  num? currentPrice;
  num? orderPrice;
  num? closePrice;
  num? orderChange;

  TradingSearchTickerRes({
    this.orderPrice,
    this.closePrice,
    this.symbol,
    this.name,
    this.image,
    this.id,
    this.price,
    this.change,
    this.changesPercentage,
    this.status,
    this.type,
    this.currentPrice,
    this.orderChange,
  });

  factory TradingSearchTickerRes.fromJson(Map<String, dynamic> json) =>
      TradingSearchTickerRes(
        orderPrice: json['order_price'],
        closePrice: json['close_price'],
        orderChange: json['order_change'],
        symbol: json["symbol"],
        id: json['id'],
        name: json["name"],
        type: json['type'] != null
            ? StockTypeExtension.fromJson(json['type'])
            : null,
        currentPrice: json['current_price'],
        status: json['status'],
        image: json["image"],
        price: json["price"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
      );

  Map<String, dynamic> toJson() => {
        'order_price': orderPrice,
        'order)change': orderChange,
        'close_price': closePrice,
        "symbol": symbol,
        "name": name,
        "image": image,
        "price": price,
        'id': id,
        'status': status,
        "change": change,
        'type': type?.toJson(),
        'current_price': currentPrice,
        "changesPercentage": changesPercentage,
      };
}

extension StockTypeExtension on StockType {
  String toJson() {
    switch (this) {
      case StockType.buy:
        return "buy";
      case StockType.sell:
        return "sell";
      case StockType.hold:
        return "hold";
    }
  }

  static StockType fromJson(String value) {
    switch (value) {
      case "buy":
        return StockType.buy;
      case "sell":
        return StockType.sell;
      case "hold":
        return StockType.hold;
      default:
        throw ArgumentError("Invalid StockType value: $value");
    }
  }
}

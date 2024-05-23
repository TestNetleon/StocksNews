// To parse this JSON data, do
//
//     final pennyStocksRes = pennyStocksResFromJson(jsonString);

import 'dart:convert';

List<PennyStocksRes> pennyStocksResFromJson(String str) =>
    List<PennyStocksRes>.from(
        json.decode(str).map((x) => PennyStocksRes.fromJson(x)));

String pennyStocksResToJson(List<PennyStocksRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PennyStocksRes {
  final String? symbol;
  final String? name;
  final String? exchange;
  final String? price;
  final String? change;
  final num? changesPercentage;
  final String? volume;
  final String? image;
  final String? avgVolume;
  final String? dollarVolume;

  PennyStocksRes({
    this.symbol,
    this.name,
    this.exchange,
    this.price,
    this.change,
    this.changesPercentage,
    this.volume,
    this.image,
    this.avgVolume,
    this.dollarVolume,
  });

  factory PennyStocksRes.fromJson(Map<String, dynamic> json) => PennyStocksRes(
        symbol: json["symbol"],
        name: json["name"],
        exchange: json["exchange"],
        price: json["price"],
        image: json["image"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
        volume: json["volume"],
        avgVolume: json["avgVolume"],
        dollarVolume: json["dollarVolume"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "image": image,
        "exchange": exchange,
        "price": price,
        "change": change,
        "changesPercentage": changesPercentage,
        "volume": volume,
        "avgVolume": avgVolume,
        "dollarVolume": dollarVolume,
      };
}

// To parse this JSON data, do
//
//     final breakoutStocksRes = breakoutStocksResFromJson(jsonString);

import 'dart:convert';

List<BreakoutStocksRes> breakoutStocksResFromJson(String str) =>
    List<BreakoutStocksRes>.from(
        json.decode(str).map((x) => BreakoutStocksRes.fromJson(x)));

String breakoutStocksResToJson(List<BreakoutStocksRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BreakoutStocksRes {
  final dynamic symbol;
  final dynamic image;
  final dynamic name;
  final dynamic price;
  final dynamic priceChange;
  final dynamic percentageChange;
  final dynamic the50Day;
  final dynamic percentageMovingAverage;
  final dynamic volume;
  final dynamic avgVolume;

  BreakoutStocksRes({
    this.symbol,
    this.image,
    this.name,
    this.price,
    this.priceChange,
    this.percentageChange,
    this.the50Day,
    this.percentageMovingAverage,
    this.volume,
    this.avgVolume,
  });

  factory BreakoutStocksRes.fromJson(Map<String, dynamic> json) =>
      BreakoutStocksRes(
        symbol: json["symbol"],
        image: json["image"],
        name: json["name"],
        price: json["price"],
        priceChange: json["price_change"],
        percentageChange: json["percentage_change"],
        the50Day: json["50-Day"],
        percentageMovingAverage: json["percentageMovingAverage"],
        volume: json["volume"],
        avgVolume: json["avgVolume"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "image": image,
        "name": name,
        "price": price,
        "price_change": priceChange,
        "percentage_change": percentageChange,
        "50-Day": the50Day,
        "percentageMovingAverage": percentageMovingAverage,
        "volume": volume,
        "avgVolume": avgVolume,
      };
}

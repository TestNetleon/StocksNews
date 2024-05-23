// To parse this JSON data, do
//
//     final fifttTwoWeeksRes = fifttTwoWeeksResFromJson(jsonString);

import 'dart:convert';

List<FiftyTwoWeeksRes> fifttTwoWeeksResFromJson(String str) =>
    List<FiftyTwoWeeksRes>.from(
        json.decode(str).map((x) => FiftyTwoWeeksRes.fromJson(x)));

String fiftyTwoWeeksResToJson(List<FiftyTwoWeeksRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FiftyTwoWeeksRes {
  final String symbol;
  final String name;
  final String? price;
  final double? changesPercentage;
  final String? yearHigh;
  final String? yearLow;
  final String? previousClose;
  final String? dayLow;
  final String? dayHigh;
  final String? image;

  FiftyTwoWeeksRes({
    required this.symbol,
    required this.name,
    this.price,
    this.changesPercentage,
    this.yearHigh,
    this.yearLow,
    this.previousClose,
    this.dayLow,
    this.dayHigh,
    this.image,
  });

  factory FiftyTwoWeeksRes.fromJson(Map<String, dynamic> json) =>
      FiftyTwoWeeksRes(
        symbol: json["symbol"],
        name: json["name"],
        price: json["price"],
        changesPercentage: json["changesPercentage"]?.toDouble(),
        yearHigh: json["yearHigh"],
        yearLow: json["yearLow"],
        previousClose: json["previousClose"],
        dayLow: json["dayLow"],
        dayHigh: json["dayHigh"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "price": price,
        "changesPercentage": changesPercentage,
        "yearHigh": yearHigh,
        "yearLow": yearLow,
        "previousClose": previousClose,
        "dayLow": dayLow,
        "dayHigh": dayHigh,
        "image": image,
      };
}

// To parse this JSON data, do
//
//     final fifttTwoWeeksRes = fifttTwoWeeksResFromJson(jsonString);

import 'dart:convert';

List<FiftyTwoWeeksRes> fiftyTwoWeeksResFromJson(String str) =>
    List<FiftyTwoWeeksRes>.from(
        json.decode(str).map((x) => FiftyTwoWeeksRes.fromJson(x)));

String fiftyTwoWeeksResToJson(List<FiftyTwoWeeksRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FiftyTwoWeeksRes {
  final dynamic symbol;
  final dynamic name;
  final dynamic price;
  final dynamic changesPercentage;
  final dynamic yearHigh;
  final dynamic yearLow;
  final dynamic previousClose;
  final dynamic dayLow;
  final dynamic dayHigh;
  final dynamic image;
  final dynamic change;

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
    required this.change,
  });

  factory FiftyTwoWeeksRes.fromJson(Map<String, dynamic> json) =>
      FiftyTwoWeeksRes(
        symbol: json["symbol"],
        name: json["name"],
        price: json["price"],
        changesPercentage: json["changesPercentage"],
        yearHigh: json["yearHigh"],
        yearLow: json["yearLow"],
        previousClose: json["previousClose"],
        dayLow: json["dayLow"],
        dayHigh: json["dayHigh"],
        image: json["image"],
        change: json["change"],
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
        "change": change,
      };
}

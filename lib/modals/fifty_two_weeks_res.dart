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
  final dynamic yearHigh;
  final dynamic yearLow;
  final dynamic previousClose;
  final dynamic dayLow;
  final dynamic dayHigh;
  final dynamic image;
  final dynamic change;
  final dynamic changesPercentage;
  num? isAlertAdded;
  num? isWatchlistAdded;

  FiftyTwoWeeksRes({
    required this.symbol,
    required this.name,
    this.price,
    this.yearHigh,
    this.yearLow,
    this.previousClose,
    this.dayLow,
    this.dayHigh,
    this.image,
    required this.change,
    this.changesPercentage,
    this.isAlertAdded,
    this.isWatchlistAdded,
  });

  factory FiftyTwoWeeksRes.fromJson(Map<String, dynamic> json) =>
      FiftyTwoWeeksRes(
        symbol: json["symbol"],
        name: json["name"],
        price: json["price"],
        yearHigh: json["yearHigh"],
        yearLow: json["yearLow"],
        previousClose: json["previousClose"],
        dayLow: json["dayLow"],
        dayHigh: json["dayHigh"],
        image: json["image"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "price": price,
        "yearHigh": yearHigh,
        "yearLow": yearLow,
        "previousClose": previousClose,
        "dayLow": dayLow,
        "dayHigh": dayHigh,
        "image": image,
        "change": change,
        "changesPercentage": changesPercentage,
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
      };
}

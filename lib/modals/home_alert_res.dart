// To parse this JSON data, do
//
//     final homeAlertsRes = homeAlertsResFromJson(jsonString);

import 'dart:convert';

List<HomeAlertsRes> homeAlertsResFromJson(String str) =>
    List<HomeAlertsRes>.from(
        json.decode(str).map((x) => HomeAlertsRes.fromJson(x)));

String homeAlertsResToJson(List<HomeAlertsRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HomeAlertsRes {
  final String symbol;
  final String name;
  final String image;
  final String price;
  final String change;
  final num changesPercentage;
  final num previousClose;
  List<Chart>? chart;
  num? isAlertAdded;
  num? isWatchlistAdded;

  HomeAlertsRes({
    required this.symbol,
    required this.name,
    required this.image,
    required this.price,
    required this.change,
    required this.changesPercentage,
    required this.previousClose,
    this.chart,
    this.isAlertAdded,
    this.isWatchlistAdded,
  });

  factory HomeAlertsRes.fromJson(Map<String, dynamic> json) => HomeAlertsRes(
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        change: json["change"],
        previousClose: json["previousClose"],
        changesPercentage: json["changesPercentage"]?.toDouble(),
        chart: json["chart"] == null
            ? []
            : List<Chart>.from(json["chart"]!.map((x) => Chart.fromJson(x))),
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "image": image,
        "previousClose": previousClose,
        "price": price,
        "change": change,
        "changesPercentage": changesPercentage,
        "chart": chart == null
            ? []
            : List<dynamic>.from(chart!.map((x) => x.toJson())),
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
      };
}

class Chart {
  final DateTime date;
  final double close;
  // final double open;
  // final double low;
  // final double high;
  // final int volume;

  Chart({
    required this.date,
    // required this.open,
    // required this.low,
    // required this.high,
    required this.close,
    // required this.volume,
  });

  factory Chart.fromJson(Map<String, dynamic> json) => Chart(
        date: DateTime.parse(json["date"]),
        // open: json["open"]?.toDouble(),
        // low: json["low"]?.toDouble(),
        // high: json["high"]?.toDouble(),
        close: json["close"]?.toDouble(),
        // volume: json["volume"],
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        // "open": open,
        // "low": low,
        // "high": high,
        "close": close,
        // "volume": volume,
      };
}

// To parse this JSON data, do
//
//     final stockInFocusRes = stockInFocusResFromJson(jsonString);

import 'dart:convert';

import 'home_alert_res.dart';

StockInFocusRes stockInFocusResFromJson(String str) =>
    StockInFocusRes.fromJson(json.decode(str));

String stockInFocusResToJson(StockInFocusRes data) =>
    json.encode(data.toJson());

class StockInFocusRes {
  final String? lpUrl;
  final String? symbol;
  final String? name;
  final String? image;
  final String? price;
  final String? change;
  final double? changesPercentage;
  final double? previousClose;
  final List<Chart>? chart;

  StockInFocusRes({
    this.lpUrl,
    this.symbol,
    this.name,
    this.image,
    this.price,
    this.change,
    this.changesPercentage,
    this.previousClose,
    this.chart,
  });

  factory StockInFocusRes.fromJson(Map<String, dynamic> json) =>
      StockInFocusRes(
        lpUrl: json["lp_url"],
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        change: json["change"],
        changesPercentage: json["changesPercentage"]?.toDouble(),
        previousClose: json["previousClose"]?.toDouble(),
        chart: json["chart"] == null
            ? []
            : List<Chart>.from(json["chart"]!.map((x) => Chart.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lp_url": lpUrl,
        "symbol": symbol,
        "name": name,
        "image": image,
        "price": price,
        "change": change,
        "changesPercentage": changesPercentage,
        "previousClose": previousClose,
        "chart": chart == null
            ? []
            : List<dynamic>.from(chart!.map((x) => x.toJson())),
      };
}

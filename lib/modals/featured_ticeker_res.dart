// To parse this JSON data, do
//
//     final featuredTickerRes = featuredTickerResFromJson(jsonString);

import 'dart:convert';

import 'home_alert_res.dart';

FeaturedTickerRes featuredTickerResFromJson(String str) =>
    FeaturedTickerRes.fromJson(json.decode(str));

String featuredTickerResToJson(FeaturedTickerRes data) =>
    json.encode(data.toJson());

class FeaturedTickerRes {
  final int currentPage;
  List<HomeAlertsRes> data;
  final int lastPage;

  FeaturedTickerRes({
    required this.currentPage,
    required this.data,
    required this.lastPage,
  });

  factory FeaturedTickerRes.fromJson(Map<String, dynamic> json) =>
      FeaturedTickerRes(
        currentPage: json["current_page"],
        data: List<HomeAlertsRes>.from(
            json["data"].map((x) => HomeAlertsRes.fromJson(x))),
        lastPage: json["last_page"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "last_page": lastPage,
      };
}

class Datum {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final String price;
  final String change;
  final String changesPercentage;
  final double previousClose;
  final List<Chart> chart;

  Datum({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.price,
    required this.change,
    required this.changesPercentage,
    required this.previousClose,
    required this.chart,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
        previousClose: json["previousClose"]?.toDouble(),
        chart: List<Chart>.from(json["chart"].map((x) => Chart.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "symbol": symbol,
        "name": name,
        "image": image,
        "price": price,
        "change": change,
        "changesPercentage": changesPercentage,
        "previousClose": previousClose,
        "chart": List<dynamic>.from(chart.map((x) => x.toJson())),
      };
}

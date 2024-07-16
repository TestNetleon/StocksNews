// To parse this JSON data, do
//
//     final featuredWatchlistRes = featuredWatchlistResFromJson(jsonString);

import 'dart:convert';

import 'package:stocks_news_new/modals/home_alert_res.dart';

FeaturedWatchlistRes featuredWatchlistResFromJson(String str) =>
    FeaturedWatchlistRes.fromJson(json.decode(str));

String featuredWatchlistResToJson(FeaturedWatchlistRes data) =>
    json.encode(data.toJson());

class FeaturedWatchlistRes {
  final List<FeaturedTicker>? featuredTickers;
  final List<FeaturedTicker>? watchlist;

  FeaturedWatchlistRes({
    this.featuredTickers,
    this.watchlist,
  });

  factory FeaturedWatchlistRes.fromJson(Map<String, dynamic> json) =>
      FeaturedWatchlistRes(
        featuredTickers: json["featured_tickers"] == null
            ? []
            : List<FeaturedTicker>.from(json["featured_tickers"]!
                .map((x) => FeaturedTicker.fromJson(x))),
        watchlist: json["watchlist"] == null
            ? []
            : List<FeaturedTicker>.from(
                json["watchlist"]!.map((x) => FeaturedTicker.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "featured_tickers": featuredTickers == null
            ? []
            : List<dynamic>.from(featuredTickers!.map((x) => x.toJson())),
        "watchlist": watchlist == null
            ? []
            : List<dynamic>.from(watchlist!.map((x) => x.toJson())),
      };
}

class FeaturedTicker {
  final String? id;
  final String symbol;
  final String? name;
  final String? image;
  final String? price;
  final String? change;
  final num? changesPercentage;
  final num? previousClose;
  List<Chart>? chart;

  FeaturedTicker({
    this.id,
    required this.symbol,
    this.name,
    this.image,
    this.price,
    this.change,
    this.changesPercentage,
    this.previousClose,
    this.chart,
  });

  factory FeaturedTicker.fromJson(Map<String, dynamic> json) => FeaturedTicker(
        id: json["_id"],
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
        previousClose: json["previousClose"],
        chart: json["chart"] == null
            ? []
            : List<Chart>.from(json["chart"]!.map((x) => Chart.fromJson(x))),
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
        "chart": chart == null
            ? []
            : List<dynamic>.from(chart!.map((x) => x.toJson())),
      };
}

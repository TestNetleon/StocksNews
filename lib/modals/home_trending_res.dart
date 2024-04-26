// To parse this JSON data, do
//
//     final HomeTrendingRes = HomeTrendingResFromJson(jsonString);

import 'dart:convert';

import 'home_res.dart';

HomeTrendingRes homeTrendingResFromJson(String str) =>
    HomeTrendingRes.fromJson(json.decode(str));

String homeTrendingResToJson(HomeTrendingRes data) =>
    json.encode(data.toJson());

class HomeTrendingRes {
  final List<HomeTrendingData> trending;
  final List<Top> gainers;
  final List<Top> losers;

  HomeTrendingRes({
    required this.trending,
    required this.gainers,
    required this.losers,
  });

  factory HomeTrendingRes.fromJson(Map<String, dynamic> json) =>
      HomeTrendingRes(
        trending: List<HomeTrendingData>.from(
            json["trending"].map((x) => HomeTrendingData.fromJson(x))),
        gainers: List<Top>.from(json["gainers"].map((x) => Top.fromJson(x))),
        losers: List<Top>.from(json["losers"].map((x) => Top.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "trending": List<dynamic>.from(trending.map((x) => x.toJson())),
        "gainers": List<dynamic>.from(gainers.map((x) => x.toJson())),
        "losers": List<dynamic>.from(losers.map((x) => x.toJson())),
      };
}

class Top {
  final String name;
  final String symbol;
  final String price;
  final num changesPercentage;
  final String image;
  final bool gained;

  Top({
    required this.name,
    required this.symbol,
    required this.price,
    required this.changesPercentage,
    required this.image,
    this.gained = false,
  });

  factory Top.fromJson(Map<String, dynamic> json) => Top(
        name: json["name"],
        symbol: json["symbol"],
        price: json["price"],
        changesPercentage: json["changesPercentage"]?.toDouble(),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "symbol": symbol,
        "price": price,
        "changesPercentage": changesPercentage,
        "image": image,
      };
}

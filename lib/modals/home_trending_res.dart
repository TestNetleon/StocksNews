// To parse this JSON data, do
//
//     final HomeTrendingRes = HomeTrendingResFromJson(jsonString);

import 'dart:convert';

import 'home_res.dart';

HomeTrendingRes homeTrendingResFromJson(String str) =>
    HomeTrendingRes.fromJson(json.decode(str));

String homeTrendingResToJson(HomeTrendingRes data) =>
    json.encode(data.toJson());

//
class HomeTrendingRes {
  final List<HomeTrendingData> trending;
  final List<Top> gainers;
  final List<Top> losers;
  final List<Top> popular;

  final TextRes? text;

  HomeTrendingRes({
    required this.trending,
    required this.gainers,
    required this.losers,
    required this.popular,
    this.text,
  });

  factory HomeTrendingRes.fromJson(Map<String, dynamic> json) =>
      HomeTrendingRes(
        popular: List<Top>.from(json["actives"].map((x) => Top.fromJson(x))),
        text: json["text"] == null ? null : TextRes.fromJson(json["text"]),
        trending: List<HomeTrendingData>.from(
            json["trending"].map((x) => HomeTrendingData.fromJson(x))),
        gainers: List<Top>.from(json["gainers"].map((x) => Top.fromJson(x))),
        losers: List<Top>.from(json["losers"].map((x) => Top.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "trending": List<dynamic>.from(trending.map((x) => x.toJson())),
        "gainers": List<dynamic>.from(gainers.map((x) => x.toJson())),
        "actives": List<dynamic>.from(gainers.map((x) => x.toJson())),
        "losers": List<dynamic>.from(losers.map((x) => x.toJson())),
        "text": text?.toJson(),
      };
}

class TextRes {
  final String? trending;
  final String? gainers;
  final String? losers;
  final String? recentMentions;
  final String? hotStocks;
  final String? mostBullish;
  final String? mostBearish;
  final String? sectors;
  final String? generalNews;
  final String? now;
  final String? recently;
  final String? cap;
  final String? mentionText;
  final String? subTitle;
  final String? note;
  final String? other;
  final String? sentimentText;

  TextRes({
    this.trending,
    this.gainers,
    this.losers,
    this.recentMentions,
    this.hotStocks,
    this.mostBullish,
    this.mostBearish,
    this.sectors,
    this.generalNews,
    this.now,
    this.recently,
    this.sentimentText,
    this.subTitle,
    this.cap,
    this.mentionText,
    this.note,
    this.other,
  });

  factory TextRes.fromJson(Map<String, dynamic> json) => TextRes(
        trending: json["trending"],
        gainers: json["gainers"],
        losers: json["losers"],
        subTitle: json["sub_title"],
        mentionText: json["mentions_text"],
        recentMentions: json["recent_mentions"],
        hotStocks: json["hot_stocks"],
        mostBullish: json["most_bullish"],
        mostBearish: json["most_bearish"],
        sectors: json["sectors"],
        generalNews: json["general_news"],
        now: json["now"],
        note: json["note"],
        sentimentText: json["sentiment_text"],
        other: json["other"],
        recently: json["recently"],
        cap: json["cap"],
      );

  Map<String, dynamic> toJson() => {
        "trending": trending,
        "gainers": gainers,
        "losers": losers,
        "mentions_text": mentionText,
        "sentiment_text": sentimentText,
        "recent_mentions": recentMentions,
        "hot_stocks": hotStocks,
        "most_bullish": mostBullish,
        "most_bearish": mostBearish,
        "sub_title": subTitle,
        "sectors": sectors,
        "general_news": generalNews,
        "note": note,
        "other": other,
        "now": now,
        "recently": recently,
        "cap": cap,
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

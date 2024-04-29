// To parse this JSON data, do
//
//     final topTrendingRes = topTrendingResFromJson(jsonString);

import 'dart:convert';

TopTrendingRes topTrendingResFromJson(String str) =>
    TopTrendingRes.fromJson(json.decode(str));

String topTrendingResToJson(TopTrendingRes data) => json.encode(data.toJson());

class TopTrendingRes {
  final int? currentPage;
  final List<TopTrendingDataRes>? data;
  final int? lastPage;
//
  TopTrendingRes({
    this.currentPage,
    this.data,
    this.lastPage,
  });

  factory TopTrendingRes.fromJson(Map<String, dynamic> json) => TopTrendingRes(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<TopTrendingDataRes>.from(
                json["data"]!.map((x) => TopTrendingDataRes.fromJson(x))),
        lastPage: json["last_page"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "last_page": lastPage,
      };
}

class TopTrendingDataRes {
  final String symbol;
  final String? price;
  final String? image;
  final String name;
  final num? change;
  final num? changePercentage;

  final String? cap;
  final num? rank;
  final num? sentiment;
  final num? lastSentiment;
  num isAlertAdded;
  num isWatchlistAdded;

  TopTrendingDataRes({
    required this.symbol,
    this.price,
    this.image,
    required this.name,
    this.change,
    this.changePercentage,
    this.cap,
    this.rank,
    this.sentiment,
    this.lastSentiment,
    required this.isAlertAdded,
    required this.isWatchlistAdded,
  });

  factory TopTrendingDataRes.fromJson(Map<String, dynamic> json) =>
      TopTrendingDataRes(
          symbol: json["symbol"],
          price: json["price"],
          image: json["image"],
          name: json["name"],
          change: json["change"]?.toDouble(),
          cap: json["cap"],
          rank: json["rank"],
          sentiment: json["sentiment"],
          lastSentiment: json["last_sentiment"],
          isAlertAdded: json["is_alert_added"],
          changePercentage: json["changesPercentage"],
          isWatchlistAdded: json["is_watchlist_added"]);

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "price": price,
        "image": image,
        "name": name,
        "change": change,
        "cap": cap,
        "rank": rank,
        "sentiment": sentiment,
        "last_sentiment": lastSentiment,
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
        "changesPercentage": changePercentage,
      };
}

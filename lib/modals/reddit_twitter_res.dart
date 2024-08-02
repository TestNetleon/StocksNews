// To parse this JSON data, do
//
//     final socialSentimentsRes = socialSentimentsResFromJson(jsonString);

import 'dart:convert';

import 'package:stocks_news_new/modals/home_insider_res.dart';

import 'home_trending_res.dart';

SocialSentimentsRes socialSentimentsResFromJson(String str) =>
    SocialSentimentsRes.fromJson(json.decode(str));
//
String socialSentimentsResToJson(SocialSentimentsRes data) =>
    json.encode(data.toJson());

class SocialSentimentsRes {
  final List<SocialSentimentItemRes> data;
  final List<RecentMention>? recentMentions;
  final num avgSentiment;
  final num commentVolume;
  final num sentimentTrending;
  final TextRes? text;

  SocialSentimentsRes({
    required this.data,
    this.recentMentions,
    required this.avgSentiment,
    required this.commentVolume,
    required this.sentimentTrending,
    this.text,
  });

  factory SocialSentimentsRes.fromJson(Map<String, dynamic> json) =>
      SocialSentimentsRes(
        text: json["text"] == null ? null : TextRes.fromJson(json["text"]),
        data: List<SocialSentimentItemRes>.from(
            json["data"].map((x) => SocialSentimentItemRes.fromJson(x))),
        recentMentions: json["recent_mentions"] == null
            ? []
            : List<RecentMention>.from(
                json["recent_mentions"]!.map((x) => RecentMention.fromJson(x))),
        avgSentiment: json["avg_sentiment"],
        commentVolume: json["comment_volume"],
        sentimentTrending: json["sentiment_trending"],
      );

  Map<String, dynamic> toJson() => {
        "text": text?.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "recent_mentions": recentMentions == null
            ? []
            : List<dynamic>.from(recentMentions!.map((x) => x.toJson())),
        "avg_sentiment": avgSentiment,
        "comment_volume": commentVolume,
        "sentiment_trending": sentimentTrending,
      };
}

class SocialSentimentItemRes {
  final String symbol;
  final String image;
  final String name;
  final int totalMentions;
  final String recentMentions;
  num? isAlertAdded;
  num? isWatchlistAdded;

  SocialSentimentItemRes({
    required this.symbol,
    required this.image,
    required this.name,
    required this.totalMentions,
    required this.recentMentions,
    this.isAlertAdded,
    this.isWatchlistAdded,
  });

  factory SocialSentimentItemRes.fromJson(Map<String, dynamic> json) =>
      SocialSentimentItemRes(
        symbol: json["symbol"],
        image: json["image"],
        name: json["name"],
        totalMentions: json["total_mentions"],
        recentMentions: json["recent_mentions"],
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "image": image,
        "name": name,
        "total_mentions": totalMentions,
        "recent_mentions": recentMentions,
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
      };
}

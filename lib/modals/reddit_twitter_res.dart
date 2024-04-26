// To parse this JSON data, do
//
//     final socialSentimentsRes = socialSentimentsResFromJson(jsonString);

import 'dart:convert';

import 'package:stocks_news_new/modals/home_insider_res.dart';

SocialSentimentsRes socialSentimentsResFromJson(String str) =>
    SocialSentimentsRes.fromJson(json.decode(str));

String socialSentimentsResToJson(SocialSentimentsRes data) =>
    json.encode(data.toJson());

class SocialSentimentsRes {
  final List<SocialSentimentItemRes> data;
  final List<RecentMention>? recentMentions;
  final num avgSentiment;
  final num commentVolume;
  final num sentimentTrending;
  SocialSentimentsRes({
    required this.data,
    this.recentMentions,
    required this.avgSentiment,
    required this.commentVolume,
    required this.sentimentTrending,
  });

  factory SocialSentimentsRes.fromJson(Map<String, dynamic> json) =>
      SocialSentimentsRes(
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

  SocialSentimentItemRes({
    required this.symbol,
    required this.image,
    required this.name,
    required this.totalMentions,
    required this.recentMentions,
  });

  factory SocialSentimentItemRes.fromJson(Map<String, dynamic> json) =>
      SocialSentimentItemRes(
        symbol: json["symbol"],
        image: json["image"],
        name: json["name"],
        totalMentions: json["total_mentions"],
        recentMentions: json["recent_mentions"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "image": image,
        "name": name,
        "total_mentions": totalMentions,
        "recent_mentions": recentMentions,
      };
}

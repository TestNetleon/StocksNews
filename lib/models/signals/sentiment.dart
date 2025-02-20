import 'dart:convert';

import '../lock.dart';
import '../ticker.dart';

SignalSentimentRes signalSentimentResFromJson(String str) =>
    SignalSentimentRes.fromJson(json.decode(str));

String signalSentimentResToJson(SignalSentimentRes data) =>
    json.encode(data.toJson());

class SignalSentimentRes {
  final SignalMentionsRes? mostMentions;
  final SignalMentionsRes? recentMentions;
  final Sentiment? sentiment;
  final BaseLockInfoRes? lockInfo;

  SignalSentimentRes({
    this.mostMentions,
    this.recentMentions,
    this.sentiment,
    this.lockInfo,
  });

  factory SignalSentimentRes.fromJson(Map<String, dynamic> json) =>
      SignalSentimentRes(
        lockInfo: json["lock_info"] == null
            ? null
            : BaseLockInfoRes.fromJson(json["lock_info"]),
        mostMentions: json["most_mentions"] == null
            ? null
            : SignalMentionsRes.fromJson(json["most_mentions"]),
        recentMentions: json["recent_mentions"] == null
            ? null
            : SignalMentionsRes.fromJson(json["recent_mentions"]),
        sentiment: json["sentiment"] == null
            ? null
            : Sentiment.fromJson(json["sentiment"]),
      );

  Map<String, dynamic> toJson() => {
        "lock_info": lockInfo?.toJson(),
        "most_mentions": mostMentions?.toJson(),
        "recent_mentions": recentMentions?.toJson(),
        "sentiment": sentiment?.toJson(),
      };
}

class SignalMentionsRes {
  final String? title;
  final String? subTitle;
  final String? message;
  List<BaseTickerRes>? data;

  SignalMentionsRes({
    this.title,
    this.subTitle,
    this.data,
    this.message,
  });

  factory SignalMentionsRes.fromJson(Map<String, dynamic> json) =>
      SignalMentionsRes(
        title: json["title"],
        message: json['message'],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<BaseTickerRes>.from(
                json["data"]!.map((x) => BaseTickerRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        'message': message,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Sentiment {
  final num? avgSentiment;
  final num? commentVolume;
  final num? sentimentTrending;

  Sentiment({
    this.avgSentiment,
    this.commentVolume,
    this.sentimentTrending,
  });

  factory Sentiment.fromJson(Map<String, dynamic> json) => Sentiment(
        avgSentiment: json["avg_sentiment"],
        commentVolume: json["comment_volume"],
        sentimentTrending: json["sentiment_trending"],
      );

  Map<String, dynamic> toJson() => {
        "avg_sentiment": avgSentiment,
        "comment_volume": commentVolume,
        "sentiment_trending": sentimentTrending,
      };
}

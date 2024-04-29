import 'dart:convert';

HomeSentimentRes homeSentimentResFromJson(String str) =>
    HomeSentimentRes.fromJson(json.decode(str));

String homeSentimentResToJson(HomeSentimentRes data) =>
    json.encode(data.toJson());

class HomeSentimentRes {
  final num? avgSentiment;
  final num? commentVolume;
  final num? sentimentTrending;

  HomeSentimentRes({
    required this.avgSentiment,
    required this.commentVolume,
    required this.sentimentTrending,
  });
//
  factory HomeSentimentRes.fromJson(Map<String, dynamic> json) =>
      HomeSentimentRes(
        avgSentiment: json["avg_sentiment"],
        commentVolume: json["comment_volume_per"],
        sentimentTrending: json["sentiment_trending"],
      );

  Map<String, dynamic> toJson() => {
        "avg_sentiment": avgSentiment,
        "comment_volume_per": commentVolume,
        "sentiment_trending": sentimentTrending,
      };
}

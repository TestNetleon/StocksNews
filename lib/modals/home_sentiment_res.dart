import 'dart:convert';

HomeSentimentRes homeSentimentResFromJson(String str) =>
    HomeSentimentRes.fromJson(json.decode(str));

String homeSentimentResToJson(HomeSentimentRes data) =>
    json.encode(data.toJson());

class HomeSentimentRes {
  final num? avgSentiment;
  final num? commentVolume;
  final num? sentimentTrending;
  final String? text;

  HomeSentimentRes({
    required this.avgSentiment,
    required this.commentVolume,
    required this.sentimentTrending,
    this.text,
  });
//
  factory HomeSentimentRes.fromJson(Map<String, dynamic> json) =>
      HomeSentimentRes(
        avgSentiment: json["avg_sentiment"],
        commentVolume: json["comment_volume_per"],
        sentimentTrending: json["sentiment_trending"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "avg_sentiment": avgSentiment,
        "comment_volume_per": commentVolume,
        "sentiment_trending": sentimentTrending,
        "text": text,
      };
}

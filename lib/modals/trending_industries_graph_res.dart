import 'dart:convert';

TrendingIndustriesGraphRes trendingIndustriesGraphResFromJson(String str) =>
    TrendingIndustriesGraphRes.fromJson(json.decode(str));

String trendingIndustriesGraphResToJson(TrendingIndustriesGraphRes data) =>
    json.encode(data.toJson());

class TrendingIndustriesGraphRes {
  final List<String>? labels;
  final List<int>? totalMentions;
  final List<int>? positiveMentions;
  final List<int>? negativeMentions;
  final List<int>? neutralMentions;
//
  TrendingIndustriesGraphRes({
    this.labels,
    this.totalMentions,
    this.positiveMentions,
    this.negativeMentions,
    this.neutralMentions,
  });

  factory TrendingIndustriesGraphRes.fromJson(Map<String, dynamic> json) =>
      TrendingIndustriesGraphRes(
        labels: json["labels"] == null
            ? []
            : List<String>.from(json["labels"]!.map((x) => x)),
        totalMentions: json["total_mentions"] == null
            ? []
            : List<int>.from(json["total_mentions"]!.map((x) => x)),
        positiveMentions: json["positive_mentions"] == null
            ? []
            : List<int>.from(json["positive_mentions"]!.map((x) => x)),
        negativeMentions: json["negative_mentions"] == null
            ? []
            : List<int>.from(json["negative_mentions"]!.map((x) => x)),
        neutralMentions: json["neutral_mentions"] == null
            ? []
            : List<int>.from(json["neutral_mentions"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "labels":
            labels == null ? [] : List<dynamic>.from(labels!.map((x) => x)),
        "total_mentions": totalMentions == null
            ? []
            : List<dynamic>.from(totalMentions!.map((x) => x)),
        "positive_mentions": positiveMentions == null
            ? []
            : List<dynamic>.from(positiveMentions!.map((x) => x)),
        "negative_mentions": negativeMentions == null
            ? []
            : List<dynamic>.from(negativeMentions!.map((x) => x)),
        "neutral_mentions": neutralMentions == null
            ? []
            : List<dynamic>.from(neutralMentions!.map((x) => x)),
      };
}

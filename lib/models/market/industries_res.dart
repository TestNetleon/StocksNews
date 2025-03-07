import 'dart:convert';

import 'package:stocks_news_new/models/lock.dart';

IndustriesRes industriesResFromJson(String str) =>
    IndustriesRes.fromJson(json.decode(str));

String industriesResToJson(IndustriesRes data) => json.encode(data.toJson());

class IndustriesRes {
  final List<IndustriesData>? data;
  final int? totalPages;
  final BaseLockInfoRes? lockInfo;
  final HeadingLabel? heading;
  final MentionChart? chart;

  IndustriesRes({
    required this.data,
    required this.totalPages,
    this.lockInfo,
    this.heading,
    this.chart,
  });

  factory IndustriesRes.fromJson(Map<String, dynamic> json) => IndustriesRes(
        data: json["data"] == null
            ? null
            : List<IndustriesData>.from(
                json["data"].map((x) => IndustriesData.fromJson(x))),
        totalPages: json["total_pages"],
        lockInfo: json["lock_info"] == null
            ? null
            : BaseLockInfoRes.fromJson(json["lock_info"]),
        heading: json["heading"] == null
            ? null
            : HeadingLabel.fromJson(json["heading"]),
        chart:
            json["chart"] == null ? null : MentionChart.fromJson(json["chart"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total_pages": totalPages,
        "lock_info": lockInfo?.toJson(),
        "heading": heading?.toJson(),
        "chart": chart?.toJson(),
      };
}

class IndustriesData {
  final String? industry;
  final String? industrySlug;
  final String? image;
  final String? sentiment;
  final dynamic sentimentColor;
  final dynamic totalMentions;
  final dynamic percentageChange;
  final dynamic percentageColor;
  final dynamic positiveMentions;
  final dynamic negativeMentions;
  final dynamic neutralMentions;

  IndustriesData({
    required this.industry,
    required this.industrySlug,
    required this.image,
    required this.sentiment,
    required this.sentimentColor,
    required this.totalMentions,
    required this.percentageChange,
    required this.percentageColor,
    required this.positiveMentions,
    required this.negativeMentions,
    required this.neutralMentions,
  });

  factory IndustriesData.fromJson(Map<String, dynamic> json) => IndustriesData(
        industry: json["industry"],
        industrySlug: json["industry_slug"],
        image: json["image"],
        sentiment: json["sentiment"]!,
        sentimentColor: json["sentiment_color"],
        totalMentions: json["total_mentions"],
        percentageChange: json["percentage_change"],
        percentageColor: json["percentage_color"],
        positiveMentions: json["positive_mentions"],
        negativeMentions: json["negative_mentions"],
        neutralMentions: json["neutral_mentions"],
      );

  Map<String, dynamic> toJson() => {
        "industry": industry,
        "industry_slug": industrySlug,
        "image": image,
        "sentiment": sentiment,
        "sentiment_color": sentimentColor,
        "total_mentions": totalMentions,
        "percentage_change": percentageChange,
        "percentage_color": percentageColor,
        "positive_mentions": positiveMentions,
        "negative_mentions": negativeMentions,
        "neutral_mentions": neutralMentions,
      };
}

class HeadingLabel {
  final String? title;
  final String? sentiment;
  final String? mentions;

  HeadingLabel({
    required this.title,
    required this.sentiment,
    required this.mentions,
  });

  factory HeadingLabel.fromJson(Map<String, dynamic> json) => HeadingLabel(
        title: json["title"],
        sentiment: json["sentiment"],
        mentions: json["mentions"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sentiment": sentiment,
        "mentions": mentions,
      };
}

class MentionChart {
  final List<String>? labels;
  final List<int>? totalMentions;
  final List<int>? positiveMentions;
  final List<int>? negativeMentions;
  final List<int>? neutralMentions;

  MentionChart({
    this.labels,
    this.totalMentions,
    this.positiveMentions,
    this.negativeMentions,
    this.neutralMentions,
  });

  factory MentionChart.fromJson(Map<String, dynamic> json) => MentionChart(
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

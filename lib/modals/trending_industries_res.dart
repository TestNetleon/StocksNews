// To parse this JSON data, do
//
//     final trendingIndustriesRes = trendingIndustriesResFromJson(jsonString);

import 'dart:convert';

List<TrendingIndustriesRes> trendingIndustriesResFromJson(String str) =>
    List<TrendingIndustriesRes>.from(
        json.decode(str).map((x) => TrendingIndustriesRes.fromJson(x)));

String trendingIndustriesResToJson(List<TrendingIndustriesRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TrendingIndustriesRes {
  final String? industry;
  final String? industrySlug;
  final String? mentionType;
  final int? totalMentions;
  final double? mentionChange;
  final String? image;

  TrendingIndustriesRes({
    this.industry,
    this.industrySlug,
    this.mentionType,
    this.totalMentions,
    this.mentionChange,
    this.image,
  });

  factory TrendingIndustriesRes.fromJson(Map<String, dynamic> json) =>
      TrendingIndustriesRes(
        industry: json["industry"],
        industrySlug: json["industry_slug"],
        mentionType: json["mention_type"]!,
        totalMentions: json["total_mentions"],
        mentionChange: json["mention_change"]?.toDouble(),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "industry": industry,
        "industry_slug": industrySlug,
        "mention_type": mentionType,
        "total_mentions": totalMentions,
        "mention_change": mentionChange,
        "image": image,
      };
}

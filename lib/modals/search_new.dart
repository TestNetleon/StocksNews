// To parse this JSON data, do
//
//     final testMarksRes = testMarksResFromJson(jsonString);

import 'dart:convert';

import 'search_res.dart';

SearchNewRes searchNewResFromJson(String str) =>
    SearchNewRes.fromJson(json.decode(str));

String searchNewResToJson(SearchNewRes data) => json.encode(data.toJson());

class SearchNewRes {
  final List<SearchRes>? symbols;
  final List<SearchNewsRes>? news;

  SearchNewRes({
    this.symbols,
    this.news,
  });

  factory SearchNewRes.fromJson(Map<String, dynamic> json) => SearchNewRes(
        symbols: json["symbols"] == null
            ? []
            : List<SearchRes>.from(
                json["symbols"]!.map((x) => SearchRes.fromJson(x))),
        news: json["news"] == null
            ? []
            : List<SearchNewsRes>.from(
                json["news"]!.map((x) => SearchNewsRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "symbols": symbols == null
            ? []
            : List<dynamic>.from(symbols!.map((x) => x.toJson())),
        "news": news == null
            ? []
            : List<dynamic>.from(news!.map((x) => x.toJson())),
      };
}

class SearchNewsRes {
  final String? slug;
  final String? title;

  SearchNewsRes({
    this.slug,
    this.title,
  });

  factory SearchNewsRes.fromJson(Map<String, dynamic> json) => SearchNewsRes(
        slug: json["slug"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "slug": slug,
        "title": title,
      };
}

import 'dart:convert';
import 'package:stocks_news_new/models/ticker.dart';
import 'news.dart';

BaseSearchRes baseSearchResFromJson(String str) =>
    BaseSearchRes.fromJson(json.decode(str));

String baseSearchResToJson(BaseSearchRes data) => json.encode(data.toJson());

class BaseSearchRes {
  final SearchSymbolRes? symbols;
  final SearchNewsRes? news;

  BaseSearchRes({
    this.symbols,
    this.news,
  });

  factory BaseSearchRes.fromJson(Map<String, dynamic> json) => BaseSearchRes(
        symbols: json["symbols"] == null
            ? null
            : SearchSymbolRes.fromJson(json["symbols"]),
        news:
            json["news"] == null ? null : SearchNewsRes.fromJson(json["news"]),
      );

  Map<String, dynamic> toJson() => {
        "symbols": symbols?.toJson(),
        "news": news?.toJson(),
      };
}

class SearchNewsRes {
  final String? title;
  final String? subTitle;
  final List<BaseNewsRes>? data;

  SearchNewsRes({
    this.title,
    this.subTitle,
    this.data,
  });

  factory SearchNewsRes.fromJson(Map<String, dynamic> json) => SearchNewsRes(
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<BaseNewsRes>.from(
                json["data"]!.map((x) => BaseNewsRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SearchSymbolRes {
  final String? title;
  final String? subTitle;
  final List<BaseTickerRes>? data;

  SearchSymbolRes({
    this.title,
    this.subTitle,
    this.data,
  });

  factory SearchSymbolRes.fromJson(Map<String, dynamic> json) =>
      SearchSymbolRes(
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<BaseTickerRes>.from(
                json["data"]!.map((x) => BaseTickerRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

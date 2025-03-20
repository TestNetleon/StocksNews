import 'dart:convert';

import 'package:stocks_news_new/models/ticker.dart';

HomeViewMoreTickersRes homeViewMoreTickersResFromJson(String str) =>
    HomeViewMoreTickersRes.fromJson(json.decode(str));

String homeViewMoreTickersResToJson(HomeViewMoreTickersRes data) =>
    json.encode(data.toJson());

class HomeViewMoreTickersRes {
  final String? title;
  final List<BaseTickerRes>? data;
  final int? totalPages;

  HomeViewMoreTickersRes({
    this.title,
    this.data,
    this.totalPages,
  });

  factory HomeViewMoreTickersRes.fromJson(Map<String, dynamic> json) =>
      HomeViewMoreTickersRes(
        title: json['title'],
        data: json["data"] == null
            ? []
            : List<BaseTickerRes>.from(
                json["data"]!.map((x) => BaseTickerRes.fromJson(x))),
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total_pages": totalPages,
      };
}

import 'dart:convert';

import 'package:stocks_news_new/models/news.dart';

NewsRes newsResFromJson(String str) => NewsRes.fromJson(json.decode(str));

String newsResToJson(NewsRes data) => json.encode(data.toJson());

class NewsRes {
  final int? totalPages;
  final List<BaseNewsRes>? data;

  NewsRes({
    this.totalPages,
    this.data,
  });

  factory NewsRes.fromJson(Map<String, dynamic> json) => NewsRes(
        totalPages: json['total_pages'],
        data: json["data"] == null
            ? []
            : List<BaseNewsRes>.from(
                json["data"]!.map((x) => BaseNewsRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'total_pages': totalPages,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

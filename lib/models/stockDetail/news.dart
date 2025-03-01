import 'dart:convert';

import 'package:stocks_news_new/models/news.dart';

import 'overview.dart';

SDLatestNewsRes sdLatestNewsFromJson(String str) =>
    SDLatestNewsRes.fromJson(json.decode(str));

String sdLatestNewsToJson(SDLatestNewsRes data) => json.encode(data.toJson());

class SDLatestNewsRes {
  final String? title;
  final String? subTitle;
  final List<BaseNewsRes>? data;
  final BaseKeyValueRes? sentimentsPer;

  SDLatestNewsRes({
    this.title,
    this.subTitle,
    this.data,
    this.sentimentsPer,
  });

  factory SDLatestNewsRes.fromJson(Map<String, dynamic> json) =>
      SDLatestNewsRes(
        title: json["title"],
        subTitle: json["sub_title"],
        sentimentsPer: json["sentiments_per"] == null
            ? null
            : BaseKeyValueRes.fromJson(json["sentiments_per"]),
        data: json["data"] == null
            ? []
            : List<BaseNewsRes>.from(
                json["data"]!.map((x) => BaseNewsRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "sentiments_per": sentimentsPer?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

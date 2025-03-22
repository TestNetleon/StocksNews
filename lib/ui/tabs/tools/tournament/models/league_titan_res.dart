import 'dart:convert';

import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/trading_res.dart';

LeagueTitanRes leagueTitanResFromMap(String str) => LeagueTitanRes.fromMap(json.decode(str));

String leagueTitanResToMap(LeagueTitanRes data) => json.encode(data.toMap());

class LeagueTitanRes {
  final String? title;
  final String? subTitle;
  final int? totalPages;
  final List<KeyValueElement>? ranks;
  final List<TradingRes>? data;

  LeagueTitanRes({
    this.title,
    this.subTitle,
    this.totalPages,
    this.ranks,
    this.data,
  });

  factory LeagueTitanRes.fromMap(Map<String, dynamic> json) => LeagueTitanRes(
    title: json["title"],
    subTitle: json["sub_title"],
    totalPages: json["total_pages"],
    ranks: json["ranks"] == null ? null : List<KeyValueElement>.from(json["ranks"]!.map((x) => KeyValueElement.fromJson(x))),
    data: json["data"] == null ? null : List<TradingRes>.from(json["data"]!.map((x) => TradingRes.fromJson(x))),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "sub_title": subTitle,
    "total_pages": totalPages,
    "ranks": ranks == null ? null : List<dynamic>.from(ranks!.map((x) => x.toJson())),
    "data": data == null ? null: List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}


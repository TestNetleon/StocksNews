import 'dart:convert';

import 'package:stocks_news_new/models/ticker.dart';

import 'lock.dart';

MorningStarReportsRes morningStarReportsResFromJson(String str) =>
    MorningStarReportsRes.fromJson(json.decode(str));

String morningStarReportsResToJson(MorningStarReportsRes data) =>
    json.encode(data.toJson());

class MorningStarReportsRes {
  final String? title;
  final String? subTitle;
  final List<BaseTickerRes>? data;
  final BaseLockInfoRes? loginRequired;

  MorningStarReportsRes({
    this.title,
    this.subTitle,
    this.data,
    this.loginRequired,
  });

  factory MorningStarReportsRes.fromJson(Map<String, dynamic> json) =>
      MorningStarReportsRes(
        title: json["title"],
        loginRequired: json["login_required"] == null
            ? null
            : BaseLockInfoRes.fromJson(json["login_required"]),
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<BaseTickerRes>.from(
                json["data"]!.map((x) => BaseTickerRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "login_required": loginRequired?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

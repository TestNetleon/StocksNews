import 'dart:convert';

import 'package:stocks_news_new/models/lock.dart';

import 'ticker.dart';

ToolsCompareRes toolsCompareResFromJson(String str) =>
    ToolsCompareRes.fromJson(json.decode(str));

String toolsCompareResToJson(ToolsCompareRes data) =>
    json.encode(data.toJson());

class ToolsCompareRes {
  final String? title;
  final String? subTitle;
  final List<BaseTickerRes>? data;
  final BaseLockInfoRes? loginRequired;

  ToolsCompareRes({
    this.title,
    this.subTitle,
    this.data,
    this.loginRequired,
  });

  factory ToolsCompareRes.fromJson(Map<String, dynamic> json) =>
      ToolsCompareRes(
        title: json["title"],
        subTitle: json["sub_title"],
        loginRequired: json["login_required"] == null
            ? null
            : BaseLockInfoRes.fromJson(json["login_required"]),
        data: json["data"] == null
            ? []
            : List<BaseTickerRes>.from(
                json["data"]!.map((x) => BaseTickerRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "login_required": loginRequired?.toJson(),
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

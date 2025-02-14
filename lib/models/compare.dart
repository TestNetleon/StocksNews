import 'dart:convert';

import 'ticker.dart';

ToolsCompareRes toolsCompareResFromJson(String str) =>
    ToolsCompareRes.fromJson(json.decode(str));

String toolsCompareResToJson(ToolsCompareRes data) =>
    json.encode(data.toJson());

class ToolsCompareRes {
  final String? title;
  final String? subTitle;
  final List<BaseTickerRes>? data;

  ToolsCompareRes({
    this.title,
    this.subTitle,
    this.data,
  });

  factory ToolsCompareRes.fromJson(Map<String, dynamic> json) =>
      ToolsCompareRes(
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

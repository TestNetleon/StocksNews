import 'dart:convert';

import 'package:stocks_news_new/models/ticker.dart';

SDCompetitorsRes SDCompetitorsResFromJson(String str) =>
    SDCompetitorsRes.fromJson(json.decode(str));

String SDCompetitorsResToJson(SDCompetitorsRes data) =>
    json.encode(data.toJson());

class SDCompetitorsRes {
  final String? title;
  final String? subTitle;
  final List<BaseTickerRes>? data;

  SDCompetitorsRes({
    this.title,
    this.subTitle,
    this.data,
  });

  factory SDCompetitorsRes.fromJson(Map<String, dynamic> json) =>
      SDCompetitorsRes(
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

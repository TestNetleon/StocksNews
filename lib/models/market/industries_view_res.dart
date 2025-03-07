import 'dart:convert';

import 'package:stocks_news_new/models/ticker.dart';

IndustriesViewRes industriesViewResFromJson(String str) => IndustriesViewRes.fromMap(json.decode(str));

String industriesViewResToJson(IndustriesViewRes data) => json.encode(data.toMap());

class IndustriesViewRes {
  final String? title;
  final String? subTitle;
  final HeaderRes? header;
  final List<BaseTickerRes>? data;
  final int? totalPages;

  IndustriesViewRes({
    this.title,
    this.subTitle,
    this.header,
    this.data,
    this.totalPages,
  });

  factory IndustriesViewRes.fromMap(Map<String, dynamic> json) => IndustriesViewRes(
    title: json["title"],
    subTitle: json["sub_title"],
    header: json["header"] == null ? null : HeaderRes.fromMap(json["header"]),
    data: json["data"] == null ? [] : List<BaseTickerRes>.from(json["data"]!.map((x) => BaseTickerRes.fromJson(x))),
    totalPages: json["total_pages"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "sub_title": subTitle,
    "header": header?.toMap(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total_pages": totalPages,
  };
}

class HeaderRes {
  final String? title;
  final TotalMentions? totalMentions;
  final List<TotalMentions>? mentions;

  HeaderRes({
    this.title,
    this.totalMentions,
    this.mentions,
  });

  factory HeaderRes.fromMap(Map<String, dynamic> json) => HeaderRes(
    title: json["title"],
    totalMentions: json["total_mentions"] == null ? null : TotalMentions.fromMap(json["total_mentions"]),
    mentions: json["mentions"] == null ? [] : List<TotalMentions>.from(json["mentions"]!.map((x) => TotalMentions.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "total_mentions": totalMentions?.toMap(),
    "mentions": mentions == null ? [] : List<dynamic>.from(mentions!.map((x) => x.toMap())),
  };
}

class TotalMentions {
  final String? title;
  final int? colour;

  TotalMentions({
    this.title,
    this.colour,
  });

  factory TotalMentions.fromMap(Map<String, dynamic> json) => TotalMentions(
    title: json["title"],
    colour: json["colour"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "colour": colour,
  };
}

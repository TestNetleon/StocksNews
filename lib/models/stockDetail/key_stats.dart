// To parse this JSON data, do
//
//     final sdKeyStatsRes = sdKeyStatsResFromJson(jsonString);

import 'dart:convert';

import 'overview.dart';

SdKeyStatsRes sdKeyStatsResFromJson(String str) =>
    SdKeyStatsRes.fromJson(json.decode(str));

String sdKeyStatsResToJson(SdKeyStatsRes data) => json.encode(data.toJson());

class SdKeyStatsRes {
  final String? title;
  final String? subTitle;
  final List<BaseKeyValueRes>? data;
  final int? isAlertAdded;
  final int? isWatchlistAdded;

  SdKeyStatsRes({
    this.title,
    this.subTitle,
    this.data,
    this.isAlertAdded,
    this.isWatchlistAdded,
  });

  factory SdKeyStatsRes.fromJson(Map<String, dynamic> json) => SdKeyStatsRes(
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<BaseKeyValueRes>.from(
                json["data"]!.map((x) => BaseKeyValueRes.fromJson(x))),
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
      };
}

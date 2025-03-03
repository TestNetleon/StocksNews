import 'dart:convert';
import 'package:stocks_news_new/models/delete_data.dart';
import 'package:stocks_news_new/models/no_data.dart';
import 'package:stocks_news_new/models/ticker.dart';

WatchRes watchListResFromMap(String str) => WatchRes.fromMap(json.decode(str));

String watchListResToMap(WatchRes data) => json.encode(data.toMap());

class WatchRes {
  final String? title;
  final String? subTitle;
  final NoDataRes? noData;
  final List<BaseTickerRes>? watches;
  final DeleteBoxRes? deleteBox;
  final int? totalPages;

  WatchRes({
    this.title,
    this.subTitle,
    this.noData,
    this.watches,
    this.deleteBox,
    this.totalPages,
  });

  factory WatchRes.fromMap(Map<String, dynamic> json) => WatchRes(
    title: json["title"],
    subTitle: json["sub_title"],
    noData: json["no_data"] == null ? null : NoDataRes.fromMap(json["no_data"]),
    watches: json["data"] == null ? [] : List<BaseTickerRes>.from(json["data"]!.map((x) => BaseTickerRes.fromJson(x))),
    deleteBox: json["delete_box"] == null ? null : DeleteBoxRes.fromMap(json["delete_box"]),
    totalPages: json["total_pages"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "sub_title": subTitle,
    "no_data": noData?.toMap(),
    "data": watches == null ? [] : List<dynamic>.from(watches!.map((x) => x.toJson())),
    "delete_box": deleteBox?.toMap(),
    "total_pages": totalPages,
  };
}

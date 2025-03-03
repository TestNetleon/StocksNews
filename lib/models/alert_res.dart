import 'dart:convert';

import 'package:stocks_news_new/models/delete_data.dart';
import 'package:stocks_news_new/models/no_data.dart';
import 'package:stocks_news_new/models/ticker.dart';

AlertRes alertResFromJson(String str) => AlertRes.fromMap(json.decode(str));

String alertResToMap(AlertRes data) => json.encode(data.toMap());

class AlertRes {
  final String? title;
  final String? subTitle;
  final List<BaseTickerRes>? alerts;
  final DeleteBoxRes? deleteBox;
  final NoDataRes? noDataRes;
  final int? totalPages;

  AlertRes({
    this.title,
    this.subTitle,
    this.alerts,
    this.deleteBox,
    this.noDataRes,
    this.totalPages,
  });

  factory AlertRes.fromMap(Map<String, dynamic> json) => AlertRes(
    title: json["title"],
    subTitle: json["sub_title"],
    alerts: json["data"] == null ? [] : List<BaseTickerRes>.from(json["data"]!.map((x) => BaseTickerRes.fromJson(x))),
    deleteBox: json["delete_box"] == null ? null : DeleteBoxRes.fromMap(json["delete_box"]),
    noDataRes: json["no_data"] == null ? null : NoDataRes.fromMap(json["no_data"]),
    totalPages: json["total_pages"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "sub_title": subTitle,
    "data": alerts == null ? [] : List<dynamic>.from(alerts!.map((x) => x.toJson())),
    "delete_box": deleteBox?.toMap(),
    "no_data": noDataRes?.toMap(),
    "total_pages": totalPages,
  };
}


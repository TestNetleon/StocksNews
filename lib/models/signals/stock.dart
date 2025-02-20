import 'dart:convert';

import 'package:stocks_news_new/models/ticker.dart';

import '../lock.dart';

SignalSocksRes signalSocksResFromJson(String str) =>
    SignalSocksRes.fromJson(json.decode(str));

String signalSocksResToJson(SignalSocksRes data) => json.encode(data.toJson());

class SignalSocksRes {
  final String? title;
  final String? subTitle;
  final List<BaseTickerRes>? data;
  final int? totalPages;
  final BaseLockInfoRes? lockInfo;

  SignalSocksRes({
    this.title,
    this.subTitle,
    this.data,
    this.lockInfo,
    this.totalPages,
  });

  factory SignalSocksRes.fromJson(Map<String, dynamic> json) => SignalSocksRes(
        lockInfo: json["lock_info"] == null
            ? null
            : BaseLockInfoRes.fromJson(json["lock_info"]),
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<BaseTickerRes>.from(
                json["data"]!.map((x) => BaseTickerRes.fromJson(x))),
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "lock_info": lockInfo?.toJson(),
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total_pages": totalPages,
      };
}

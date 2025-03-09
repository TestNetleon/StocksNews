import 'dart:convert';

import 'package:stocks_news_new/models/my_home.dart';

import '../lock.dart';
import '../ticker.dart';

SignalInsidersRes signalInsidersResFromJson(String str) =>
    SignalInsidersRes.fromJson(json.decode(str));

String signalInsidersResToJson(SignalInsidersRes data) =>
    json.encode(data.toJson());

class SignalInsidersRes {
  final String? title;
  final String? subTitle;
  final List<AdditionalInfoRes>? additionalInfo;
  final List<InsiderTradeRes>? data;
  final int? totalPages;
  final BaseLockInfoRes? lockInfo;

  SignalInsidersRes({
    this.title,
    this.subTitle,
    this.data,
    this.totalPages,
    this.lockInfo,
    this.additionalInfo,
  });

  factory SignalInsidersRes.fromJson(Map<String, dynamic> json) =>
      SignalInsidersRes(
        lockInfo: json["lock_info"] == null
            ? null
            : BaseLockInfoRes.fromJson(json["lock_info"]),
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<InsiderTradeRes>.from(
                json["data"]!.map((x) => InsiderTradeRes.fromJson(x))),
        totalPages: json["total_pages"],
        additionalInfo: json["additional_info"] == null
            ? []
            : List<AdditionalInfoRes>.from(json["additional_info"]!
                .map((x) => AdditionalInfoRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lock_info": lockInfo?.toJson(),
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total_pages": totalPages,
        "additional_info": additionalInfo == null
            ? []
            : List<dynamic>.from(additionalInfo!.map((x) => x.toJson())),
      };
}

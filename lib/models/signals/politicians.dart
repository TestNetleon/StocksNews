import 'dart:convert';

import '../lock.dart';
import '../my_home_premium.dart';
import '../ticker.dart';

SignalPoliticiansRes signalPoliticiansResFromJson(String str) =>
    SignalPoliticiansRes.fromJson(json.decode(str));

String signalPoliticiansResToJson(SignalPoliticiansRes data) =>
    json.encode(data.toJson());

class SignalPoliticiansRes {
  final String? title;
  final List<PoliticianTradeRes>? data;
  final List<AdditionalInfoRes>? additionalInfo;
  final BaseLockInfoRes? lockInfo;
  final int? totalPages;

  SignalPoliticiansRes({
    this.title,
    this.data,
    this.additionalInfo,
    this.totalPages,
    this.lockInfo,
  });

  factory SignalPoliticiansRes.fromJson(Map<String, dynamic> json) =>
      SignalPoliticiansRes(
        lockInfo: json["lock_info"] == null
            ? null
            : BaseLockInfoRes.fromJson(json["lock_info"]),
        title: json["title"],
        data: json["data"] == null
            ? []
            : List<PoliticianTradeRes>.from(
                json["data"]!.map((x) => PoliticianTradeRes.fromJson(x))),
        totalPages: json["total_pages"],
        additionalInfo: json["additional_info"] == null
            ? []
            : List<AdditionalInfoRes>.from(json["additional_info"]!
                .map((x) => AdditionalInfoRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lock_info": lockInfo?.toJson(),
        "title": title,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total_pages": totalPages,
        "additional_info": additionalInfo == null
            ? []
            : List<dynamic>.from(additionalInfo!.map((x) => x.toJson())),
      };
}

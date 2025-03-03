import 'dart:convert';

import 'package:stocks_news_new/models/lock.dart';

CheckAlertLockRes checkAlertLockResFromJson(String str) =>
    CheckAlertLockRes.fromJson(json.decode(str));

String checkAlertLockResToJson(CheckAlertLockRes data) =>
    json.encode(data.toJson());

class CheckAlertLockRes {
  final BaseLockInfoRes? lockInfo;
  final AlertData? alertData;

  CheckAlertLockRes({
    required this.lockInfo,
    required this.alertData,
  });

  factory CheckAlertLockRes.fromJson(Map<String, dynamic> json) =>
      CheckAlertLockRes(
        lockInfo: json["lock_info"] == null
            ? null
            : BaseLockInfoRes.fromJson(json["lock_info"]),
        alertData: json["alert_data"] == null
            ? null
            : AlertData.fromJson(json["alert_data"]),
      );

  Map<String, dynamic> toJson() => {
        "lock_info": lockInfo?.toJson(),
        "alert_data": alertData?.toJson(),
      };
}

class AlertData {
  final String? title;
  final String? subTitle;
  final String? defaultValue;
  final Mention? sentiment;
  final Mention? mention;
  final List<String>? notes;

  AlertData({
    required this.title,
    required this.subTitle,
    required this.defaultValue,
    required this.sentiment,
    required this.mention,
    required this.notes,
  });

  factory AlertData.fromJson(Map<String, dynamic> json) => AlertData(
        title: json["title"],
        subTitle: json["sub_title"],
        defaultValue: json["default_value"],
        sentiment: json["sentiment"] == null
            ? null
            : Mention.fromJson(json["sentiment"]),
        mention:
            json["mention"] == null ? null : Mention.fromJson(json["mention"]),
        notes: json["notes"] == null
            ? null
            : List<String>.from(json["notes"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "default_value": defaultValue,
        "sentiment": sentiment?.toJson(),
        "mention": mention?.toJson(),
        "notes":
            notes == null ? null : List<dynamic>.from(notes!.map((x) => x)),
      };
}

class Mention {
  final String title;
  final String subTitle;

  Mention({
    required this.title,
    required this.subTitle,
  });

  factory Mention.fromJson(Map<String, dynamic> json) => Mention(
        title: json["title"],
        subTitle: json["sub_title"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
      };
}

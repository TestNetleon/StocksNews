import 'dart:convert';

RedeemListRes redeemListResFromJson(String str) =>
    RedeemListRes.fromJson(json.decode(str));

String redeemListResToJson(RedeemListRes data) => json.encode(data.toJson());

class RedeemListRes {
  final String? title;
  final Box? box;
  final List<RedeemData>? data;

  RedeemListRes({
    required this.title,
    required this.box,
    required this.data,
  });

  factory RedeemListRes.fromJson(Map<String, dynamic> json) => RedeemListRes(
        title: json["title"],
        box: json["box"] == null ? null : Box.fromJson(json["box"]),
        data: json["data"] == null
            ? null
            : List<RedeemData>.from(
                json["data"].map((x) => RedeemData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "box": box?.toJson(),
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Box {
  final String? title;
  final String? subTitle;
  final dynamic balance;

  Box({
    required this.title,
    required this.subTitle,
    required this.balance,
  });

  factory Box.fromJson(Map<String, dynamic> json) => Box(
        title: json["title"],
        subTitle: json["sub_title"],
        balance: json["balance"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "balance": balance,
      };
}

class RedeemData {
  final String? title;
  final String? type;
  final dynamic points;
  final dynamic targetPoints;
  final dynamic claimPoints;
  final bool? status;
  final String? text;

  RedeemData({
    required this.title,
    required this.type,
    required this.points,
    required this.targetPoints,
    required this.claimPoints,
    required this.status,
    required this.text,
  });

  factory RedeemData.fromJson(Map<String, dynamic> json) => RedeemData(
        title: json["title"],
        type: json["type"],
        points: json["points"],
        targetPoints: json["targetPoints"],
        claimPoints: json["claimPoints"],
        status: json["status"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "type": type,
        "points": points,
        "targetPoints": targetPoints,
        "claimPoints": claimPoints,
        "status": status,
        "text": text,
      };
}

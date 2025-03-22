import 'dart:convert';
import 'package:stocks_news_new/models/stockDetail/overview.dart';

LeagueTabRes leagueTabResFromMap(String str) => LeagueTabRes.fromMap(json.decode(str));

String leagueTabResToMap(LeagueTabRes data) => json.encode(data.toMap());

class LeagueTabRes {
  final String? title;
  final List<BaseKeyValueRes>? tab;
  final MyPosition? myPosition;

  LeagueTabRes({
    this.title,
    this.tab,
    this.myPosition,
  });

  factory LeagueTabRes.fromMap(Map<String, dynamic> json) => LeagueTabRes(
    title: json["title"],
    tab: json["tab"] == null ? [] : List<BaseKeyValueRes>.from(json["tab"]!.map((x) => BaseKeyValueRes.fromJson(x))),
    myPosition: json["my_position"] == null ? null : MyPosition.fromMap(json["my_position"]),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "tab": tab == null ? [] : List<dynamic>.from(tab!.map((x) => x.toJson())),
    "my_position": myPosition?.toMap(),
  };
}

class MyPosition {
  final num? position;
  final int? userId;
  final num? performance;
  final String? imageType;
  final String? userImage;
  final String? userName;
  final String? rank;
  final num? totalPoints;
  final num? totalTrades;
  final num? winRatio;
  final num? performancePoint;

  MyPosition({
    this.userId,
    this.userName,
    this.userImage,
    this.imageType,
    this.position,
    this.rank,
    this.totalPoints,
    this.totalTrades,
    this.winRatio,
    this.performance,
    this.performancePoint,
  });

  factory MyPosition.fromMap(Map<String, dynamic> json) => MyPosition(
    userId: json["user_id"],
    position: json["position"],
    performance: json["performance"],
    imageType: json["image_type"],
    userImage: json["user_image"],
    userName: json["user_name"],
    rank: json["rank"],
    totalPoints: json["total_points"],
    totalTrades: json["total_trades"],
    performancePoint: json["performance_point"],
    winRatio: json["win_ratio"],

  );

  Map<String, dynamic> toMap() => {
    "user_id": userId,
    "position": position,
    "performance": performance,
    "image_type": imageType,
    "user_image": userImage,
    "user_name": userName,
    "rank": rank,
    "total_points": totalPoints,
    "total_trades": totalTrades,
    "performance_point": performancePoint,
    "win_ratio": winRatio,
  };
}

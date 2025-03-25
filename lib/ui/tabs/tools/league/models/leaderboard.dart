import 'dart:convert';

import 'package:stocks_news_new/ui/tabs/tools/league/models/tab_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/trading_res.dart';

LeagueLeaderboardRes tournamentLeaderboardResFromJson(String str) =>
    LeagueLeaderboardRes.fromJson(json.decode(str));

String tournamentLeaderboardResToJson(LeagueLeaderboardRes data) =>
    json.encode(data.toJson());

class LeagueLeaderboardRes {
  final String? title;
  final String? subTitle;
  final int? totalPages;
  final List<TradingRes>? leaderboardByDate;
    final MyPosition? loginUserPosition;
  final bool? showLeaderboard;

  LeagueLeaderboardRes({
    this.title,
    this.subTitle,
    this.totalPages,
    this.leaderboardByDate,
    this.loginUserPosition,
    this.showLeaderboard,
  });

  factory LeagueLeaderboardRes.fromJson(Map<String, dynamic> json) =>
      LeagueLeaderboardRes(
        title: json["title"],
        subTitle: json["sub_title"],
        totalPages: json["total_pages"],
        leaderboardByDate: json["leaderboard"] == null
            ? []
            : List<TradingRes>.from(json["leaderboard"]!
                .map((x) => TradingRes.fromJson(x))),
        loginUserPosition: json["my_position"] == null
            ? null
            : MyPosition.fromMap(json["my_position"]),
        showLeaderboard: json['show_leaderboard'],
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "sub_title": subTitle,
    "total_pages": totalPages,
        "leaderboard": leaderboardByDate == null
            ? []
            : List<dynamic>.from(leaderboardByDate!.map((x) => x.toJson())),
        "my_position": loginUserPosition?.toMap(),
        "showLeaderboard": showLeaderboard,
      };
}


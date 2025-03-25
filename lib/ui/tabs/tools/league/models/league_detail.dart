import 'dart:convert';

import 'package:stocks_news_new/ui/tabs/tools/league/models/trading_res.dart';

LeagueDetailRes tournamentDetailResFromJson(String str) =>
    LeagueDetailRes.fromJson(json.decode(str));

String tournamentDetailResToJson(LeagueDetailRes data) =>
    json.encode(data.toJson());

class LeagueDetailRes {
  final String? title;
  final String? subTitle;
  final List<String>? tournamentRules;
  final List<LeaguePointRes>? tournamentPoints;
  final List<TradingRes>? todayLeaderboard;
  final String? showButton;
  final String? tournamentStartTime;
  final String? tournamentEndTime;
  final BattleTimeRes? battleTime;
  final num? tournamentBattleId;
  final String? name;
  final String? description;
  final String? point;
  final String? time;
  final bool? isMarketOpen;
  final bool? joined;
  final String? image;
  final String? leaderboardSubTitle;
  final String? leaderboardTitle;
  final String? tournamentLastDate;
  final String? tournamentNextDate;

  LeagueDetailRes({
    this.title,
    this.subTitle,
    this.tournamentRules,
    this.todayLeaderboard,
    this.tournamentPoints,
    this.showButton,
    this.tournamentStartTime,
    this.tournamentEndTime,
    this.battleTime,
    this.tournamentBattleId,
    this.name,
    this.description,
    this.point,
    this.time,
    this.isMarketOpen,
    this.joined,
    this.image,
    this.leaderboardSubTitle,
    this.leaderboardTitle,
    this.tournamentLastDate,
    this.tournamentNextDate,
  });

  factory LeagueDetailRes.fromJson(Map<String, dynamic> json) =>
      LeagueDetailRes(
        title: json["title"],
      subTitle: json["sub_title"],
        todayLeaderboard: json["today_leaderboard"] == null
            ? []
            : List<TradingRes>.from(json["today_leaderboard"]!
                .map((x) => TradingRes.fromJson(x))),
        joined: json['tournament_battle_joined'],

        image: json['image'],
        tournamentRules: json["tournament_rules"] == null
            ? []
            : List<String>.from(json["tournament_rules"]!.map((x) => x)),
        tournamentPoints: json["tournament_points"] == null
            ? []
            : List<LeaguePointRes>.from(json["tournament_points"]!
                .map((x) => LeaguePointRes.fromJson(x))),
        showButton: json["show_button"],
        tournamentStartTime: json["tournament_start_time"],
        tournamentEndTime: json["tournament_end_time"],
        battleTime: json["battle_time"] == null
            ? null
            : BattleTimeRes.fromJson(json["battle_time"]),
        tournamentBattleId: json["tournament_battle_id"],
        name: json["name"],
        description: json["description"],
        point: json["point"],
        time: json["time"],
        leaderboardSubTitle: json["leaderboard_sub_title"],
        leaderboardTitle: json["leaderboard_title"],
        isMarketOpen: json["isMarketOpen"],
        tournamentLastDate: json["tournament_last_date"],
        tournamentNextDate: json["tournament_next_date"],
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "sub_title": subTitle,
        'tournament_battle_joined': joined,
        "tournament_rules": tournamentRules == null
            ? []
            : List<dynamic>.from(tournamentRules!.map((x) => x)),
        "tournament_points": tournamentPoints == null
            ? []
            : List<dynamic>.from(tournamentPoints!.map((x) => x.toJson())),
        "show_button": showButton,
        "tournament_start_time": tournamentStartTime,
        "tournament_end_time": tournamentEndTime,
        'image': image,
        "battle_time": battleTime?.toJson(),
        "tournament_battle_id": tournamentBattleId,
        "name": name,
        "description": description,
        "point": point,
        "time": time,
        "leaderboard_title": leaderboardTitle,
        "leaderboard_sub_title": leaderboardSubTitle,
        "today_leaderboard": todayLeaderboard == null
            ? []
            : List<dynamic>.from(todayLeaderboard!.map((x) => x.toJson())),
        "isMarketOpen": isMarketOpen,
        "tournament_last_date": tournamentLastDate,
        "tournament_next_date": tournamentNextDate,
      };
}

class BattleTimeRes {
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? currentTime;

  BattleTimeRes({
    this.startTime,
    this.endTime,
    this.currentTime,
  });

  factory BattleTimeRes.fromJson(Map<String, dynamic> json) => BattleTimeRes(
        startTime: json["start_time"] == null
            ? null
            : DateTime.parse(json["start_time"]),
        endTime:
            json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
        currentTime: json["current_time"] == null
            ? null
            : DateTime.parse(json["current_time"]),
      );

  Map<String, dynamic> toJson() => {
        "start_time": startTime?.toUtc(),
        "end_time": endTime?.toUtc(),
        "current_time": currentTime?.toUtc(),
      };
}

class LeaguePointRes {
  final String? image;
  final String? positionText;
  final int? points;

  LeaguePointRes({
    this.image,
    this.positionText,
    this.points,
  });

  factory LeaguePointRes.fromJson(Map<String, dynamic> json) =>
      LeaguePointRes(
        image: json["image"],
        positionText: json["position_text"],
        points: json["points"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "position_text": positionText,
        "points": points,
      };
}

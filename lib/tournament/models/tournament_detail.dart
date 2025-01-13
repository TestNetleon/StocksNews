import 'dart:convert';

import 'leaderboard.dart';

TournamentDetailRes tournamentDetailResFromJson(String str) =>
    TournamentDetailRes.fromJson(json.decode(str));

String tournamentDetailResToJson(TournamentDetailRes data) =>
    json.encode(data.toJson());

class TournamentDetailRes {
  final List<String>? tournamentRules;
  // final LoginUserPositionRes? loginUserPosition;
  final List<TournamentPointRes>? tournamentPoints;
  final List<LeaderboardByDateRes>? todayLeaderboard;

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

  TournamentDetailRes({
    this.tournamentRules,
    this.todayLeaderboard,
    this.tournamentPoints,
    this.showButton,
    // this.loginUserPosition,
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
  });

  factory TournamentDetailRes.fromJson(Map<String, dynamic> json) =>
      TournamentDetailRes(
        // loginUserPosition: json["login_user_position"] == null
        //     ? null
        //     : LoginUserPositionRes.fromJson(json["login_user_position"]),
        todayLeaderboard: json["today_leaderboard"] == null
            ? []
            : List<LeaderboardByDateRes>.from(json["today_leaderboard"]!
                .map((x) => LeaderboardByDateRes.fromJson(x))),
        joined: json['tournament_battle_joined'],

        image: json['image'],
        tournamentRules: json["tournament_rules"] == null
            ? []
            : List<String>.from(json["tournament_rules"]!.map((x) => x)),
        tournamentPoints: json["tournament_points"] == null
            ? []
            : List<TournamentPointRes>.from(json["tournament_points"]!
                .map((x) => TournamentPointRes.fromJson(x))),
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
        isMarketOpen: json["isMarketOpen"],
      );

  Map<String, dynamic> toJson() => {
        'tournament_battle_joined': joined,
        // "login_user_position": loginUserPosition?.toJson(),
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
        "today_leaderboard": todayLeaderboard == null
            ? []
            : List<dynamic>.from(todayLeaderboard!.map((x) => x.toJson())),
        "isMarketOpen": isMarketOpen,
      };
}

class LoginUserPositionRes {
  final String? position;
  final num? totalChange;
  // final String? imageType;

  LoginUserPositionRes({
    this.position,
    this.totalChange,
    // this.imageType,
  });

  factory LoginUserPositionRes.fromJson(Map<String, dynamic> json) =>
      LoginUserPositionRes(
        position: json["position"],
        totalChange: json["total_change"],
      );

  Map<String, dynamic> toJson() => {
        "position": position,
        "total_change": totalChange,
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

class TournamentPointRes {
  final String? image;
  final String? positionText;
  final int? points;

  TournamentPointRes({
    this.image,
    this.positionText,
    this.points,
  });

  factory TournamentPointRes.fromJson(Map<String, dynamic> json) =>
      TournamentPointRes(
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

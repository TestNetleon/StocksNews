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
  final String? leaderboardSubTitle;
  final String? leaderboardTitle;
  final String? tournamentLastDate;
  final String? tournamentNextDate;

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
    this.leaderboardSubTitle,
    this.leaderboardTitle,
    this.tournamentLastDate,
    this.tournamentNextDate,
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
        leaderboardSubTitle: json["leaderboard_sub_title"],
        leaderboardTitle: json["leaderboard_title"],
        isMarketOpen: json["isMarketOpen"],
        tournamentLastDate: json["tournament_last_date"],
        tournamentNextDate: json["tournament_next_date"],
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

class LoginUserPositionRes {
  final num? position;
  final int? userId;
  final num? performance;
  final String? imageType;
  final String? userImage;
  final String? userName;

  LoginUserPositionRes({
    this.userId,
    this.position,
    this.performance,
    this.imageType,
    this.userImage,
    this.userName,
  });

  factory LoginUserPositionRes.fromJson(Map<String, dynamic> json) =>
      LoginUserPositionRes(
        userId: json["user_id"],
        position: json["position"],
        performance: json["performance"],
        imageType: json["image_type"],
        userImage: json["user_image"],
        userName: json["user_name"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "position": position,
        "performance": performance,
        "image_type": imageType,
        "user_image": userImage,
        "user_name": userName,
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

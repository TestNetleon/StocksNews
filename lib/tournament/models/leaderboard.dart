import 'dart:convert';

import 'package:stocks_news_new/tournament/models/tournament_detail.dart';

TournamentLeaderboardRes tournamentLeaderboardResFromJson(String str) =>
    TournamentLeaderboardRes.fromJson(json.decode(str));

String tournamentLeaderboardResToJson(TournamentLeaderboardRes data) =>
    json.encode(data.toJson());

class TournamentLeaderboardRes {
  final List<LeaderboardByDateRes>? leaderboardByDate;
  final LoginUserPositionRes? loginUserPosition;

  TournamentLeaderboardRes({
    this.leaderboardByDate,
    this.loginUserPosition,
  });

  factory TournamentLeaderboardRes.fromJson(Map<String, dynamic> json) =>
      TournamentLeaderboardRes(
        leaderboardByDate: json["leaderboard"] == null
            ? []
            : List<LeaderboardByDateRes>.from(json["leaderboard"]!
                .map((x) => LeaderboardByDateRes.fromJson(x))),
        loginUserPosition: json["login_user_position"] == null
            ? null
            : LoginUserPositionRes.fromJson(json["login_user_position"]),
      );

  Map<String, dynamic> toJson() => {
        "leaderboard": leaderboardByDate == null
            ? []
            : List<dynamic>.from(leaderboardByDate!.map((x) => x.toJson())),
        "login_user_position": loginUserPosition?.toJson(),
      };
}

List<LeaderboardByDateRes> leaderboardByDateResFromJson(String str) =>
    List<LeaderboardByDateRes>.from(
        json.decode(str).map((x) => LeaderboardByDateRes.fromJson(x)));

class LeaderboardByDateRes {
  final num? tournamentID;
  final String? tournamentName;
  final String? tournamentImage;
  final num? userId;
  final num? battleId;
  final String? userName;
  final String? userImage;
  final num? totalChange;
  final String? imageType;
  final num? position;
  final num? level;
  final num? totalPoints;
  final String? rank;
  final num? status;
  final String? date;
  final num? rewards;
  final num? joinUsers;
  final num? performance;

  LeaderboardByDateRes({
    this.userId,
    this.battleId,
    this.userName,
    this.userImage,
    this.totalChange,
    this.position,
    this.level,
    this.totalPoints,
    this.rank,
    this.date,
    this.imageType,
    this.rewards,
    this.status,
    this.tournamentID,
    this.tournamentName,
    this.tournamentImage,
    this.joinUsers,
    this.performance,
  });

  factory LeaderboardByDateRes.fromJson(Map<String, dynamic> json) =>
      LeaderboardByDateRes(
        imageType: json['image_type'],
        rank: json['rank'],
        userId: json["user_id"],
        battleId: json["battle_id"],
        userName: json["user_name"],
        userImage: json["user_image"],
        totalChange: json["total_change"],
        level: json['level'],
        position: json['position'],
        totalPoints: json['total_points'],
        date: json['date'],
        rewards: json['rewards'],
        status: json['status'],
        tournamentID: json['tournament_id'],
        tournamentImage: json['tournament_image'],
        tournamentName: json['tournament_name'],
        joinUsers: json['join_users'],
        performance: json['performance'],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "battle_id": battleId,
        "name": userName,
        'rank': rank,
        "image": userImage,
        "image_type": imageType,
        "total_change": totalChange,
        'level': level,
        'position': position,
        'total_points': totalPoints,
        'date': date,
        'rewards': rewards,
        'status': status,
        'tournament_id': tournamentID,
        'tournament_image': tournamentImage,
        'tournament_name': tournamentName,
        'join_users': joinUsers,
        'performance': performance,
      };
}

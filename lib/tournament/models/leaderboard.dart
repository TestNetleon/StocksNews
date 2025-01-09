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

class LeaderboardByDateRes {
  // final num? tournamentBattleId;
  // final DateTime? tournamentBattleDate;
  final num? userId;
  final String? name;
  final String? image;
  final num? avgTotalChange;
  // final num? position;
  final String? imageType;

  LeaderboardByDateRes({
    // this.tournamentBattleId,
    // this.tournamentBattleDate,
    this.userId,
    this.name,
    this.image,
    this.avgTotalChange,
    // this.position,
    this.imageType,
  });

  factory LeaderboardByDateRes.fromJson(Map<String, dynamic> json) =>
      LeaderboardByDateRes(
        // tournamentBattleId: json["tournament_battle_id"],
        imageType: json['image_type'],
        // tournamentBattleDate: json["tournament_battle_date"] == null
        //     ? null
        //     : DateTime.parse(json["tournament_battle_date"]),
        userId: json["user_id"],
        name: json["name"],
        image: json["image"],
        avgTotalChange: json["total_change"],
        // position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        // "tournament_battle_id": tournamentBattleId,
        // "tournament_battle_date":
        //     "${tournamentBattleDate!.year.toString().padLeft(4, '0')}-${tournamentBattleDate!.month.toString().padLeft(2, '0')}-${tournamentBattleDate!.day.toString().padLeft(2, '0')}",
        "user_id": userId,
        "name": name,
        "image": image,
        "image_type": imageType,
        "total_change": avgTotalChange,
        // "position": position,
      };
}

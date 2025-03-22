import 'dart:convert';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/tab_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/trading_res.dart';


TournamentLeaderboardRes tournamentLeaderboardResFromJson(String str) =>
    TournamentLeaderboardRes.fromJson(json.decode(str));

String tournamentLeaderboardResToJson(TournamentLeaderboardRes data) =>
    json.encode(data.toJson());

class TournamentLeaderboardRes {
  final List<TradingRes>? leaderboardByDate;
    final MyPosition? loginUserPosition;
  final bool? showLeaderboard;

  TournamentLeaderboardRes({
    this.leaderboardByDate,
    this.loginUserPosition,
    this.showLeaderboard,
  });

  factory TournamentLeaderboardRes.fromJson(Map<String, dynamic> json) =>
      TournamentLeaderboardRes(
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
        "leaderboard": leaderboardByDate == null
            ? []
            : List<dynamic>.from(leaderboardByDate!.map((x) => x.toJson())),
        "my_position": loginUserPosition?.toMap(),
        "showLeaderboard": showLeaderboard,
      };
}


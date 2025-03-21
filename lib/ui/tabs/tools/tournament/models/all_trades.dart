
import 'dart:convert';

import 'package:stocks_news_new/modals/stock_screener_res.dart';
import 'package:stocks_news_new/models/ticker.dart';


TournamentAllTradesRes tournamentAllTradesResFromJson(String str) =>
    TournamentAllTradesRes.fromJson(json.decode(str));

String tournamentAllTradesResToJson(TournamentAllTradesRes data) =>
    json.encode(data.toJson());

class TournamentAllTradesRes {
  final List<KeyValueElementStockScreener>? overview;
  final List<BaseTickerRes>? data;
  final int? tournamentBattleId;

  TournamentAllTradesRes({
    this.overview,
    this.data,
    this.tournamentBattleId,
  });

  factory TournamentAllTradesRes.fromJson(Map<String, dynamic> json) =>
      TournamentAllTradesRes(
        overview: json["overview"] == null
            ? []
            : List<KeyValueElementStockScreener>.from(json["overview"]!
                .map((x) => KeyValueElementStockScreener.fromJson(x))),
        data: json["data"] == null
            ? []
            : List<BaseTickerRes>.from(
                json["data"]!.map((x) => BaseTickerRes.fromJson(x))),
        tournamentBattleId: json["tournament_battle_id"],

      );

  Map<String, dynamic> toJson() => {
        "overview": overview == null
            ? []
            : List<dynamic>.from(overview!.map((x) => x.toJson())),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
    "tournament_battle_id": tournamentBattleId,

  };
}

class BattleId {
  final int? tournamentBattleId;
  final int? userId;

  BattleId({
    this.tournamentBattleId,
    this.userId,
  });

  factory BattleId.fromMap(Map<String, dynamic> json) => BattleId(
    tournamentBattleId: json["tournament_battle_id"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toMap() => {
    "tournament_battle_id": tournamentBattleId,
    "user_id": userId,
  };
}

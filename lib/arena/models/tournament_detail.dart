import 'dart:convert';

TournamentDetailRes tournamentDetailResFromJson(String str) =>
    TournamentDetailRes.fromJson(json.decode(str));

String tournamentDetailResToJson(TournamentDetailRes data) =>
    json.encode(data.toJson());

class TournamentDetailRes {
  final List<String>? tournamentRules;
  final List<TournamentPointRes>? tournamentPoints;
  final String? showButton;
  final String? tournamentStartTime;
  final String? tournamentEndTime;
  final BattleTimeRes? battleTime;
  final num? activeTournamentBattleId;
  final String? name;
  final String? description;
  final String? point;
  final String? time;
  final bool? isMarketOpen;

  TournamentDetailRes({
    this.tournamentRules,
    this.tournamentPoints,
    this.showButton,
    this.tournamentStartTime,
    this.tournamentEndTime,
    this.battleTime,
    this.activeTournamentBattleId,
    this.name,
    this.description,
    this.point,
    this.time,
    this.isMarketOpen,
  });

  factory TournamentDetailRes.fromJson(Map<String, dynamic> json) =>
      TournamentDetailRes(
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
        activeTournamentBattleId: json["active_tournament_battle_id"],
        name: json["name"],
        description: json["description"],
        point: json["point"],
        time: json["time"],
        isMarketOpen: json["isMarketOpen"],
      );

  Map<String, dynamic> toJson() => {
        "tournament_rules": tournamentRules == null
            ? []
            : List<dynamic>.from(tournamentRules!.map((x) => x)),
        "tournament_points": tournamentPoints == null
            ? []
            : List<dynamic>.from(tournamentPoints!.map((x) => x.toJson())),
        "show_button": showButton,
        "tournament_start_time": tournamentStartTime,
        "tournament_end_time": tournamentEndTime,
        "battle_time": battleTime?.toJson(),
        "active_tournament_battle_id": activeTournamentBattleId,
        "name": name,
        "description": description,
        "point": point,
        "time": time,
        "isMarketOpen": isMarketOpen,
      };
}

class BattleTimeRes {
  final DateTime? startTime;
  final DateTime? endTime;

  BattleTimeRes({
    this.startTime,
    this.endTime,
  });

  factory BattleTimeRes.fromJson(Map<String, dynamic> json) => BattleTimeRes(
        startTime: json["start_time"] == null
            ? null
            : DateTime.parse(json["start_time"]),
        endTime:
            json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
      );

  Map<String, dynamic> toJson() => {
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
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

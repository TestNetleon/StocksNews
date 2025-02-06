import 'dart:convert';

import 'leaderboard.dart';

TournamentRes tournamentResFromJson(String str) =>
    TournamentRes.fromJson(json.decode(str));

String tournamentResToJson(TournamentRes data) => json.encode(data.toJson());

class TournamentRes {
  final List<TournamentHeaderRes>? tournamentHeader;
  final List<TournamentDataRes>? tournaments;
  final TopTradingTitans? topTradingTitans;
  final String? heading;
  final String? subHeading;

  TournamentRes({
    this.tournamentHeader,
    this.tournaments,
    this.heading,
    this.subHeading,
    this.topTradingTitans,
  });

  factory TournamentRes.fromJson(Map<String, dynamic> json) => TournamentRes(
        tournamentHeader: json["tournament_header"] == null
            ? []
            : List<TournamentHeaderRes>.from(json["tournament_header"]!
                .map((x) => TournamentHeaderRes.fromJson(x))),
        tournaments: json["tournaments"] == null
            ? []
            : List<TournamentDataRes>.from(
                json["tournaments"]!.map((x) => TournamentDataRes.fromJson(x))),
        heading: json['heading'],
        subHeading: json['sub_heading'],
        topTradingTitans: json["top_trading_titans"] == null
            ? null
            : TopTradingTitans.fromJson(json["top_trading_titans"]),
      );

  Map<String, dynamic> toJson() => {
        "tournament_header": tournamentHeader == null
            ? []
            : List<dynamic>.from(tournamentHeader!.map((x) => x.toJson())),
        "tournaments": tournaments == null
            ? []
            : List<dynamic>.from(tournaments!.map((x) => x.toJson())),
        'heading': heading,
        'sub_heading': subHeading,
        "top_trading_titans": topTradingTitans?.toJson(),
      };
}

class TopTradingTitans {
  final String? title;
  final String? subTitle;
  final List<LeaderboardByDateRes>? data;

  TopTradingTitans({
    this.title,
    this.subTitle,
    this.data,
  });

  factory TopTradingTitans.fromJson(Map<String, dynamic> json) =>
      TopTradingTitans(
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<LeaderboardByDateRes>.from(
                json["data"]!.map((x) => LeaderboardByDateRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class TournamentHeaderRes {
  final String? label;
  final String? value;

  TournamentHeaderRes({
    this.label,
    this.value,
  });

  factory TournamentHeaderRes.fromJson(Map<String, dynamic> json) =>
      TournamentHeaderRes(
        label: json["label"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
      };
}

class TournamentDataRes {
  final String? name;
  final String? slug;
  final String? time;
  final String? image;
  final String? point;
  final String? pointText;
  final int? tournamentId;
  final String? description;

  TournamentDataRes({
    this.name,
    this.slug,
    this.time,
    this.image,
    this.point,
    this.pointText,
    this.tournamentId,
    this.description,
  });

  factory TournamentDataRes.fromJson(Map<String, dynamic> json) =>
      TournamentDataRes(
        name: json["name"],
        tournamentId: json['id'],
        slug: json["slug"],
        time: json["time"],
        image: json["image"],
        point: json["point"],
        description: json['description'],
        pointText: json['point_text'],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "id": tournamentId,
        "time": time,
        "image": image,
        "point": point,
        'point_text': pointText,
        'description': description,
      };
}

import 'dart:convert';

import 'package:stocks_news_new/ui/tabs/tools/tournament/models/leaderboard.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/tournament_detail.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/trading_res.dart';


TournamentRes tournamentResFromJson(String str) =>
    TournamentRes.fromJson(json.decode(str));

String tournamentResToJson(TournamentRes data) => json.encode(data.toJson());

class TournamentRes {
  final List<LeagueHeaderRes>? tournamentHeader;
  final List<LeagueHeaderResDataRes>? tournaments;
  final List<LeaguePointRes>? tournamentPoints;
  final TopTradingTitans? topTradingTitans;
  final String? heading;
  final String? subHeading;

  TournamentRes({
    this.tournamentHeader,
    this.tournaments,
    this.heading,
    this.subHeading,
    this.topTradingTitans,
    this.tournamentPoints,
  });

  factory TournamentRes.fromJson(Map<String, dynamic> json) => TournamentRes(
        tournamentHeader: json["tournament_header"] == null
            ? []
            : List<LeagueHeaderRes>.from(json["tournament_header"]!
                .map((x) => LeagueHeaderRes.fromJson(x))),
        tournaments: json["tournaments"] == null
            ? []
            : List<LeagueHeaderResDataRes>.from(
                json["tournaments"]!.map((x) => LeagueHeaderResDataRes.fromJson(x))),
        heading: json['heading'],
        subHeading: json['sub_heading'],
        topTradingTitans: json["top_trading_titans"] == null
            ? null
            : TopTradingTitans.fromJson(json["top_trading_titans"]),
        tournamentPoints: json["tournament_points"] == null
            ? []
            : List<LeaguePointRes>.from(json["tournament_points"]!
                .map((x) => LeaguePointRes.fromJson(x))),

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
        "tournament_points": tournamentPoints == null
            ? []
            : List<dynamic>.from(tournamentPoints!.map((x) => x.toJson())),

      };
}

class TopTradingTitans {
  final String? title;
  final String? subTitle;
  final List<TradingRes>? data;

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
            : List<TradingRes>.from(
                json["data"]!.map((x) => TradingRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class LeagueHeaderRes {
  final String? label;
  final String? value;

  LeagueHeaderRes({
    this.label,
    this.value,
  });

  factory LeagueHeaderRes.fromJson(Map<String, dynamic> json) =>
      LeagueHeaderRes(
        label: json["label"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
      };
}

class LeagueHeaderResDataRes {
  final String? name;
  final String? slug;
  final String? time;
  final String? image;
  final String? point;
  final String? pointText;
  final int? tournamentId;
  final String? description;

  LeagueHeaderResDataRes({
    this.name,
    this.slug,
    this.time,
    this.image,
    this.point,
    this.pointText,
    this.tournamentId,
    this.description,
  });

  factory LeagueHeaderResDataRes.fromJson(Map<String, dynamic> json) =>
      LeagueHeaderResDataRes(
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

import 'dart:convert';

TournamentRes tournamentResFromJson(String str) =>
    TournamentRes.fromJson(json.decode(str));

String tournamentResToJson(TournamentRes data) => json.encode(data.toJson());

class TournamentRes {
  final List<TournamentHeader>? tournamentHeader;
  final List<Tournament>? tournaments;

  TournamentRes({
    this.tournamentHeader,
    this.tournaments,
  });

  factory TournamentRes.fromJson(Map<String, dynamic> json) => TournamentRes(
        tournamentHeader: json["tournament_header"] == null
            ? []
            : List<TournamentHeader>.from(json["tournament_header"]!
                .map((x) => TournamentHeader.fromJson(x))),
        tournaments: json["tournaments"] == null
            ? []
            : List<Tournament>.from(
                json["tournaments"]!.map((x) => Tournament.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tournament_header": tournamentHeader == null
            ? []
            : List<dynamic>.from(tournamentHeader!.map((x) => x.toJson())),
        "tournaments": tournaments == null
            ? []
            : List<dynamic>.from(tournaments!.map((x) => x.toJson())),
      };
}

class TournamentHeader {
  final String? label;
  final String? value;

  TournamentHeader({
    this.label,
    this.value,
  });

  factory TournamentHeader.fromJson(Map<String, dynamic> json) =>
      TournamentHeader(
        label: json["label"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
      };
}

class Tournament {
  final String? name;
  final String? slug;
  final String? time;
  final String? image;
  final int? point;
  final int? tournamentId;

  Tournament({
    this.name,
    this.slug,
    this.time,
    this.image,
    this.point,
    this.tournamentId,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) => Tournament(
        name: json["name"],
        tournamentId: json['tournament_id'],
        slug: json["slug"],
        time: json["time"],
        image: json["image"],
        point: json["point"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "tournament_id": tournamentId,
        "time": time,
        "image": image,
        "point": point,
      };
}

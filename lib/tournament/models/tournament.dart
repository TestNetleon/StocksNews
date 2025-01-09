import 'dart:convert';

TournamentRes tournamentResFromJson(String str) =>
    TournamentRes.fromJson(json.decode(str));

String tournamentResToJson(TournamentRes data) => json.encode(data.toJson());

class TournamentRes {
  final List<TournamentHeaderRes>? tournamentHeader;
  final List<TournamentDataRes>? tournaments;

  TournamentRes({
    this.tournamentHeader,
    this.tournaments,
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
  final int? point;
  final int? tournamentId;

  TournamentDataRes({
    this.name,
    this.slug,
    this.time,
    this.image,
    this.point,
    this.tournamentId,
  });

  factory TournamentDataRes.fromJson(Map<String, dynamic> json) =>
      TournamentDataRes(
        name: json["name"],
        tournamentId: json['id'],
        slug: json["slug"],
        time: json["time"],
        image: json["image"],
        point: json["point"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "id": tournamentId,
        "time": time,
        "image": image,
        "point": point,
      };
}

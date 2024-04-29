import 'dart:convert';

SectorGraphRes sectorGraphResFromJson(String str) =>
    SectorGraphRes.fromJson(json.decode(str));

String sectorGraphResToJson(SectorGraphRes data) => json.encode(data.toJson());

class SectorGraphRes {
  final List<String>? dates;
  final List<double>? values;
//
  SectorGraphRes({
    this.dates,
    this.values,
  });

  factory SectorGraphRes.fromJson(Map<String, dynamic> json) => SectorGraphRes(
        dates: json["dates"] == null
            ? []
            : List<String>.from(json["dates"]!.map((x) => x)),
        values: json["values"] == null
            ? []
            : List<double>.from(json["values"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "dates": dates == null ? [] : List<dynamic>.from(dates!.map((x) => x)),
        "values":
            values == null ? [] : List<dynamic>.from(values!.map((x) => x)),
      };
}

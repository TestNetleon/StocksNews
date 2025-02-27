import 'dart:convert';

LegalInfoRes legalInfoResFromJson(String str) =>
    LegalInfoRes.fromJson(json.decode(str));

String legalInfoResToJson(LegalInfoRes data) => json.encode(data.toJson());

class LegalInfoRes {
  final String? title;

  final String? description;

  LegalInfoRes({
    this.title,
    this.description,
  });

  factory LegalInfoRes.fromJson(Map<String, dynamic> json) => LegalInfoRes(
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
      };
}

import 'dart:convert';

import 'store_info_res.dart';

BenefitsRes benefitsResFromJson(String str) =>
    BenefitsRes.fromJson(json.decode(str));

String benefitsResToJson(BenefitsRes data) => json.encode(data.toJson());

class BenefitsRes {
  final Earn earn;
  final Earn spend;

  BenefitsRes({
    required this.earn,
    required this.spend,
  });

  factory BenefitsRes.fromJson(Map<String, dynamic> json) => BenefitsRes(
        earn: Earn.fromJson(json["earn"]),
        spend: Earn.fromJson(json["spend"]),
      );

  Map<String, dynamic> toJson() => {
        "earn": earn.toJson(),
        "spend": spend.toJson(),
      };
}

class Earn {
  final String? title;
  final String? subTitle;
  final BannerRes? banner;
  final List<Point>? points;
  final List<Benefit>? faq;

  Earn({
    this.title,
    this.subTitle,
    this.banner,
    this.points,
    this.faq,
  });

  factory Earn.fromJson(Map<String, dynamic> json) => Earn(
        title: json["title"],
        subTitle: json["sub_title"],
        // faq: List<Benefit>.from(json["faq"].map((x) => Benefit.fromJson(x))),
        faq: json["faq"] == null
            ? []
            : List<Benefit>.from(json["faq"]!.map((x) => Benefit.fromJson(x))),

        banner:
            json["banner"] == null ? null : BannerRes.fromJson(json["banner"]),
        // points: List<Point>.from(json["points"].map((x) => Point.fromJson(x))),
        points: json["points"] == null
            ? []
            : List<Point>.from(json["points"]!.map((x) => Point.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "faq": faq == null
            ? null
            : List<dynamic>.from(faq!.map((x) => x.toJson())),
        "sub_title": subTitle,
        "banner": banner?.toJson(),
        // "points": List<dynamic>.from(points.map((x) => x.toJson())),
        "points": points == null
            ? []
            : List<dynamic>.from(points!.map((x) => x.toJson())),
      };
}

class BannerRes {
  final String? title;
  final String? subTitle;
  final String? text;

  BannerRes({
    this.title,
    this.subTitle,
    this.text,
  });

  factory BannerRes.fromJson(Map<String, dynamic> json) => BannerRes(
        title: json["title"],
        subTitle: json["sub_title"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "text": text,
      };
}

class Point {
  final String? key;
  final int? point;
  final String? text;
  final String? image;

  Point({
    this.key,
    this.point,
    this.text,
    this.image,
  });

  factory Point.fromJson(Map<String, dynamic> json) => Point(
        key: json["key"],
        point: json["point"],
        text: json["text"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "point": point,
        "text": text,
        "image": image,
      };
}

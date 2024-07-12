import 'dart:convert';

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
  final String title;
  final String subTitle;
  final BannerRes banner;
  final List<Point> points;

  Earn({
    required this.title,
    required this.subTitle,
    required this.banner,
    required this.points,
  });

  factory Earn.fromJson(Map<String, dynamic> json) => Earn(
        title: json["title"],
        subTitle: json["sub_title"],
        banner: BannerRes.fromJson(json["banner"]),
        points: List<Point>.from(json["points"].map((x) => Point.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "banner": banner.toJson(),
        "points": List<dynamic>.from(points.map((x) => x.toJson())),
      };
}

class BannerRes {
  final String title;
  final String subTitle;
  final String text;

  BannerRes({
    required this.title,
    required this.subTitle,
    required this.text,
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
  final String key;
  final int point;
  final String text;

  Point({
    required this.key,
    required this.point,
    required this.text,
  });

  factory Point.fromJson(Map<String, dynamic> json) => Point(
        key: json["key"],
        point: json["point"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "point": point,
        "text": text,
      };
}

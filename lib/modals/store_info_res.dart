import 'dart:convert';

StoreInfoRes storeInfoResFromJson(String str) =>
    StoreInfoRes.fromJson(json.decode(str));

String storeInfoResToJson(StoreInfoRes data) => json.encode(data.toJson());

class StoreInfoRes {
  final String title;
  final String subTitle;
  final List<Point> points;
  final List<Benefit>? benefits;
  final List<Benefit>? faq;

  StoreInfoRes({
    required this.title,
    required this.subTitle,
    required this.points,
    required this.benefits,
    required this.faq,
  });

  factory StoreInfoRes.fromJson(Map<String, dynamic> json) => StoreInfoRes(
        title: json["title"],
        subTitle: json["sub_title"],
        points: List<Point>.from(json["points"].map((x) => Point.fromJson(x))),
        benefits: List<Benefit>.from(
            json["benefits"].map((x) => Benefit.fromJson(x))),
        faq: List<Benefit>.from(json["faq"].map((x) => Benefit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "points": List<dynamic>.from(points.map((x) => x.toJson())),
        "benefits": benefits == null
            ? null
            : List<dynamic>.from(benefits!.map((x) => x.toJson())),
        "faq": faq == null
            ? null
            : List<dynamic>.from(faq!.map((x) => x.toJson())),
      };
}

class Benefit {
  final String id;
  final String question;
  final String answer;

  Benefit({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory Benefit.fromJson(Map<String, dynamic> json) => Benefit(
        id: json["_id"],
        question: json["question"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "question": question,
        "answer": answer,
      };
}

class Point {
  final String lookupKey;
  final String displayName;
  final String price;
  final int point;

  Point({
    required this.lookupKey,
    required this.displayName,
    required this.price,
    required this.point,
  });

  factory Point.fromJson(Map<String, dynamic> json) => Point(
        lookupKey: json["product_id"],
        displayName: json["display_name"],
        price: json["price"],
        point: json["point"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": lookupKey,
        "display_name": displayName,
        "price": price,
        "point": point,
      };
}

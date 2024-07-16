import 'dart:convert';

PlansRes plansResFromJson(String str) => PlansRes.fromJson(json.decode(str));

String plansResToJson(PlansRes data) => json.encode(data.toJson());

class PlansRes {
  final String? title;
  final String? subTitle;
  final List<Plan> plans;

  PlansRes({
    required this.title,
    required this.subTitle,
    required this.plans,
  });

  factory PlansRes.fromJson(Map<String, dynamic> json) => PlansRes(
        title: json["title"],
        subTitle: json["sub_title"],
        plans: List<Plan>.from(json["plans"].map((x) => Plan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "plans": List<dynamic>.from(plans.map((x) => x.toJson())),
      };
}

class Plan {
  final String name;
  final String? price;
  final String? point;
  final String? text;
  final List<String>? detail;

  Plan({
    required this.name,
    required this.price,
    required this.point,
    required this.detail,
    required this.text,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        name: json["name"],
        price: json["price"],
        point: json["point"],
        text: json["text"],
        detail: json["detail"] == null
            ? null
            : List<String>.from(json["detail"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "point": point,
        "text": text,
        "detail":
            detail == null ? null : List<dynamic>.from(detail!.map((x) => x)),
      };
}

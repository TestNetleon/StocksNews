import 'dart:convert';

import 'package:stocks_news_new/modals/faqs_res.dart';

MembershipInfoRes membershipInfoResFromJson(String str) =>
    MembershipInfoRes.fromJson(json.decode(str));

String membershipInfoResToJson(MembershipInfoRes data) =>
    json.encode(data.toJson());

class MembershipInfoRes {
  final String title;
  final String subTitle;
  final Plan plan;
  final List<Testimonial> testimonials;
  final List<FaQsRes> faq;

  MembershipInfoRes({
    required this.title,
    required this.subTitle,
    required this.plan,
    required this.testimonials,
    required this.faq,
  });

  factory MembershipInfoRes.fromJson(Map<String, dynamic> json) =>
      MembershipInfoRes(
        title: json["title"],
        subTitle: json["sub_title"],
        plan: Plan.fromJson(json["plan"]),
        testimonials: List<Testimonial>.from(
          json["testimonials"].map((x) => Testimonial.fromJson(x)),
        ),
        faq: List<FaQsRes>.from(json["faq"].map((x) => FaQsRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "plan": plan.toJson(),
        "testimonials": List<dynamic>.from(testimonials.map((x) => x.toJson())),
        "faq": List<dynamic>.from(faq.map((x) => x.toJson())),
      };
}

class Plan {
  final String name;
  final String price;
  final List<dynamic> options;

  Plan({
    required this.name,
    required this.price,
    required this.options,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        name: json["name"],
        price: json["price"],
        options: List<dynamic>.from(json["options"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "options": List<dynamic>.from(options.map((x) => x)),
      };
}

class Testimonial {
  final String id;
  final String text;
  final int rating;
  final String title;

  Testimonial({
    required this.id,
    required this.text,
    required this.rating,
    required this.title,
  });

  factory Testimonial.fromJson(Map<String, dynamic> json) => Testimonial(
        id: json["_id"],
        text: json["text"],
        rating: json["rating"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "text": text,
        "rating": rating,
        "title": title,
      };
}

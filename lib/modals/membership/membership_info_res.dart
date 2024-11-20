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
  final String? newTitle;
  final List<String>? newFeatures;
  final String? selectTitle;
  final String? selectSubTitle;
  final String? view_features;
  final String? featuredImage;
  final List<Plan>? plans;

  MembershipInfoRes({
    required this.title,
    required this.subTitle,
    required this.plan,
    required this.testimonials,
    required this.faq,
    this.newTitle,
    this.newFeatures,
    this.selectTitle,
    this.selectSubTitle,
    this.plans,
    this.view_features,
    this.featuredImage,
  });

  factory MembershipInfoRes.fromJson(Map<String, dynamic> json) =>
      MembershipInfoRes(
        title: json["title"],
        view_features: json['view_features'],
        featuredImage: json['featured_image'],
        subTitle: json["sub_title"],
        plan: Plan.fromJson(json["plan"]),
        testimonials: List<Testimonial>.from(
          json["testimonials"].map((x) => Testimonial.fromJson(x)),
        ),
        faq: List<FaQsRes>.from(json["faq"].map((x) => FaQsRes.fromJson(x))),
        newTitle: json["new_title"],
        newFeatures: json["new_features"] == null
            ? []
            : List<String>.from(json["new_features"]!.map((x) => x)),
        selectTitle: json["select_title"],
        selectSubTitle: json["select_sub_title"],
        plans: json["plans"] == null
            ? []
            : List<Plan>.from(json["plans"]!.map((x) => Plan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        'featured_image': featuredImage,
        'view_features': view_features,
        "plan": plan.toJson(),
        "testimonials": List<dynamic>.from(testimonials.map((x) => x.toJson())),
        "faq": List<dynamic>.from(faq.map((x) => x.toJson())),
        "new_title": newTitle,
        "new_features": newFeatures == null
            ? []
            : List<dynamic>.from(newFeatures!.map((x) => x)),
        "select_title": selectTitle,
        "select_sub_title": selectSubTitle,
        "plans": plans == null
            ? []
            : List<dynamic>.from(plans!.map((x) => x.toJson())),
      };
}

class Plan {
  final String name;
  String price;
  final String? type;
  final String? billed;
  final String? discount;

  final String? description;
  bool selected;
  String? activeText;
  final String? productId;
  final List<String>? features;

  Plan({
    required this.name,
    required this.price,
    this.description,
    this.type,
    this.discount,
    this.productId,
    this.billed,
    this.selected = false,
    this.features,
    this.activeText,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        name: json["name"],
        price: json["price"],
        discount: json['discount'],
        productId: json['product_id'],
        description: json["description"],
        type: json["type"],
        billed: json["billed"],
        activeText: json['active_text'],
        features: json["features"] == null
            ? []
            : List<String>.from(json["features"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "product_id": productId,
        'discount': discount,
        "description": description,
        "type": type,
        "active_text": activeText,
        "billed": billed,
        "features":
            features == null ? [] : List<dynamic>.from(features!.map((x) => x)),
      };
}

class Testimonial {
  // final String id;
  final String? text;
  final double? rating;
  final String? title;
  final String? name;

  Testimonial({
    // required this.id,
    required this.text,
    required this.rating,
    required this.title,
    required this.name,
  });

  factory Testimonial.fromJson(Map<String, dynamic> json) => Testimonial(
        // id: json["_id"],
        text: json["text"],
        rating: json["rating"] == null
            ? null
            : double.tryParse("""${json["rating"]}"""),
        title: json["title"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        // "_id": id,
        "text": text,
        "rating": rating,
        "title": title,
        "name": name,
      };
}

import 'dart:convert';

import 'package:purchases_flutter/purchases_flutter.dart';

MySubscriptionRes mySubscriptionResFromJson(String str) =>
    MySubscriptionRes.fromJson(json.decode(str));

String mySubscriptionResToJson(MySubscriptionRes data) =>
    json.encode(data.toJson());

class MySubscriptionRes {
  final String? title;
  final String? cardBtn;
  final String? btn;
  final NoSubscriptionRes? noSubscription;
  final List<ProductPlanRes>? monthlyPlan;
  final List<ProductPlanRes>? annualPlan;

  MySubscriptionRes({
    this.title,
    this.cardBtn,
    this.btn,
    this.noSubscription,
    this.monthlyPlan,
    this.annualPlan,
  });

  factory MySubscriptionRes.fromJson(Map<String, dynamic> json) =>
      MySubscriptionRes(
        title: json["title"],
        cardBtn: json["card_btn"],
        btn: json["btn"],
        noSubscription: json["no_subscription"] == null
            ? null
            : NoSubscriptionRes.fromJson(json["no_subscription"]),
        monthlyPlan: json["monthly_plan"] == null
            ? []
            : List<ProductPlanRes>.from(
                json["monthly_plan"]!.map((x) => ProductPlanRes.fromJson(x))),
        annualPlan: json["yearly_plan"] == null
            ? []
            : List<ProductPlanRes>.from(
                json["yearly_plan"]!.map((x) => ProductPlanRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "card_btn": cardBtn,
        "btn": btn,
        "no_subscription": noSubscription?.toJson(),
        "monthly_plan": monthlyPlan == null
            ? []
            : List<dynamic>.from(monthlyPlan!.map((x) => x.toJson())),
        "yearly_plan": annualPlan == null
            ? []
            : List<dynamic>.from(annualPlan!.map((x) => x.toJson())),
      };
}

class ProductPlanRes {
  final String? identifier;
  final String? title;
  final String? price;
  final String? text;
  final String? period;
  final List<String>? benefits;
  final String? popularBtn;
  StoreProduct? storeProduct;
  final bool? isActive;

  ProductPlanRes({
    this.identifier,
    this.title,
    this.price,
    this.period,
    this.text,
    this.isActive,
    this.benefits,
    this.popularBtn,
    this.storeProduct,
  });

  factory ProductPlanRes.fromJson(Map<String, dynamic> json) => ProductPlanRes(
        identifier: json["identifier"],
        title: json["title"],
        price: json["price"],
        text: json["text"],
        isActive: json['isActive'],
        period: json['period'],
        benefits: json["Benefits"] == null
            ? []
            : List<String>.from(json["Benefits"]!.map((x) => x)),
        popularBtn: json["popular_btn"],
      );

  Map<String, dynamic> toJson() => {
        "identifier": identifier,
        "title": title,
        "price": price,
        "text": text,
        "isActive": isActive,
        "period": period,
        "Benefits":
            benefits == null ? [] : List<dynamic>.from(benefits!.map((x) => x)),
        "popular_btn": popularBtn,
      };
}

class NoSubscriptionRes {
  final String? icon;
  final String? subTitle;
  final List<String>? text;
  final String? btnText;

  NoSubscriptionRes({
    this.icon,
    this.subTitle,
    this.text,
    this.btnText,
  });

  factory NoSubscriptionRes.fromJson(Map<String, dynamic> json) =>
      NoSubscriptionRes(
        icon: json["icon"],
        subTitle: json["sub_title"],
        text: json["text"] == null
            ? []
            : List<String>.from(json["text"]!.map((x) => x)),
        btnText: json["btn_text"],
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "sub_title": subTitle,
        "text": text == null ? [] : List<dynamic>.from(text!.map((x) => x)),
        "btn_text": btnText,
      };
}

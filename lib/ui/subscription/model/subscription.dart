import 'dart:convert';

import 'package:purchases_flutter/purchases_flutter.dart';

SubscriptionRes subscriptionResFromJson(String str) =>
    SubscriptionRes.fromJson(json.decode(str));

String subscriptionResToJson(SubscriptionRes data) =>
    json.encode(data.toJson());

class SubscriptionRes {
  final String? title;
  final String? btn;
  final NoSubscriptionRes? noSubscription;
  final List<ProductPlanRes>? monthlyPlan;
  final List<ProductPlanRes>? annualPlan;

  SubscriptionRes({
    this.title,
    this.btn,
    this.noSubscription,
    this.monthlyPlan,
    this.annualPlan,
  });

  factory SubscriptionRes.fromJson(Map<String, dynamic> json) =>
      SubscriptionRes(
        title: json["title"],
        btn: json["btn"],
        noSubscription: json["no_subscription"] == null
            ? null
            : NoSubscriptionRes.fromJson(json["no_subscription"]),
        monthlyPlan: json["monthly"] == null
            ? []
            : List<ProductPlanRes>.from(
                json["monthly"]!.map((x) => ProductPlanRes.fromJson(x))),
        annualPlan: json["yearly"] == null
            ? []
            : List<ProductPlanRes>.from(
                json["yearly"]!.map((x) => ProductPlanRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "btn": btn,
        "no_subscription": noSubscription?.toJson(),
        "monthly": monthlyPlan == null
            ? []
            : List<dynamic>.from(monthlyPlan!.map((x) => x.toJson())),
        "yearly": annualPlan == null
            ? []
            : List<dynamic>.from(annualPlan!.map((x) => x.toJson())),
      };
}

class ProductPlanRes {
  final String? productID;
  final String? displayName;
  String? price;
  final String? text;
  final String? periodText;
  final List<String>? features;
  final String? popularBtn;
  StoreProduct? storeProduct;
  final bool? isActive;
  final String? expirationDate;
  final String? cardBtn;

  ProductPlanRes({
    this.productID,
    this.displayName,
    this.price,
    this.periodText,
    this.text,
    this.isActive,
    this.features,
    this.popularBtn,
    this.storeProduct,
    this.cardBtn,
    this.expirationDate,
  });

  factory ProductPlanRes.fromJson(Map<String, dynamic> json) => ProductPlanRes(
        productID: json["product_id"],
        displayName: json["display_name"],
        price: json["price"],
        cardBtn: json['card_btn'],
        text: json["text"],
        isActive: json['isActive'],
        periodText: json['period_text'],
        features: json["features"] == null
            ? []
            : List<String>.from(json["features"]!.map((x) => x)),
        popularBtn: json["popular_btn"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productID,
        "display_name": displayName,
        "price": price,
        "text": text,
        "isActive": isActive,
        'card_btn': cardBtn,
        "period_text": periodText,
        "features":
            features == null ? [] : List<dynamic>.from(features!.map((x) => x)),
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

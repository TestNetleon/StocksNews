import 'dart:convert';

import 'subscription.dart';

MySubscriptionRes mySubscriptionResFromJson(String str) =>
    MySubscriptionRes.fromJson(json.decode(str));

String mySubscriptionResToJson(MySubscriptionRes data) =>
    json.encode(data.toJson());

class MySubscriptionRes {
  final PaymentHistory? paymentHistory;
  final ProductPlanRes? activeMembership;

  MySubscriptionRes({
    this.paymentHistory,
    this.activeMembership,
  });

  factory MySubscriptionRes.fromJson(Map<String, dynamic> json) =>
      MySubscriptionRes(
        paymentHistory: json["payment_history"] == null
            ? null
            : PaymentHistory.fromJson(json["payment_history"]),
        activeMembership: json["active_membership"] == null
            ? null
            : ProductPlanRes.fromJson(json["active_membership"]),
      );

  Map<String, dynamic> toJson() => {
        "payment_history": paymentHistory?.toJson(),
        "active_membership": activeMembership?.toJson(),
      };
}

class PaymentHistory {
  final String? title;
  final int? totalPages;
  final List<ProductPlanRes>? data;

  PaymentHistory({
    this.title,
    this.totalPages,
    this.data,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) => PaymentHistory(
        title: json["title"],
        totalPages: json["total_pages"],
        data: json["data"] == null
            ? []
            : List<ProductPlanRes>.from(
                json["data"]!.map((x) => ProductPlanRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "total_pages": totalPages,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

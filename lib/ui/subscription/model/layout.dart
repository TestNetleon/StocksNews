import 'dart:convert';

SubscriptionLayoutsRes subscriptionLayoutsResFromJson(String str) =>
    SubscriptionLayoutsRes.fromJson(json.decode(str));

String subscriptionLayoutsResToJson(SubscriptionLayoutsRes data) =>
    json.encode(data.toJson());

class SubscriptionLayoutsRes {
  final String? superWallLayout;
  final int? membershipLayout;

  SubscriptionLayoutsRes({
    this.superWallLayout,
    this.membershipLayout,
  });

  factory SubscriptionLayoutsRes.fromJson(Map<String, dynamic> json) =>
      SubscriptionLayoutsRes(
        superWallLayout: json["superwall_layout"],
        membershipLayout: json["membership_layout"],
      );

  Map<String, dynamic> toJson() => {
        "superwall_layout": superWallLayout,
        "membership_layout": membershipLayout,
      };
}

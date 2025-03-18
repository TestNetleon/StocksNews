import 'dart:convert';
import 'package:stocks_news_new/models/lock.dart';
import 'package:stocks_news_new/models/referral/referral_response.dart';

SubscriptionLayoutsRes subscriptionLayoutsResFromJson(String str) =>
    SubscriptionLayoutsRes.fromJson(json.decode(str));

String subscriptionLayoutsResToJson(SubscriptionLayoutsRes data) =>
    json.encode(data.toJson());

class SubscriptionLayoutsRes {
  final String? superWallLayout;
  final int? membershipLayout;
  final int? membershipPurchased;
  final BaseLockInfoRes? success;
  final ReferLogin? actionRequired;

  SubscriptionLayoutsRes({
    this.superWallLayout,
    this.success,
    this.actionRequired,
    this.membershipLayout,
    this.membershipPurchased,
  });

  factory SubscriptionLayoutsRes.fromJson(Map<String, dynamic> json) =>
      SubscriptionLayoutsRes(
        superWallLayout: json["superwall_layout"],
        membershipLayout: json["membership_layout"],
        actionRequired: json["action_required"] == null
            ? null
            : ReferLogin.fromJson(json["action_required"]),
        membershipPurchased: json['membership_purchased'],
        success: json["success"] == null
            ? null
            : BaseLockInfoRes.fromJson(json["success"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success?.toJson(),
        "action_required": actionRequired?.toJson(),
        "superwall_layout": superWallLayout,
        "membership_layout": membershipLayout,
        'membership_purchased': membershipPurchased,
      };
}

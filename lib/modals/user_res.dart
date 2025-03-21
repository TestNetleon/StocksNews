import 'dart:convert';

import 'package:stocks_news_new/models/my_home.dart';

UserRes userResFromJson(String str) => UserRes.fromJson(json.decode(str));

String userResToJson(UserRes data) => json.encode(data.toJson());

class UserRes {
  String? userId;
  String? email;
  String? phone;
  final String? roleId;
  final String? token;
  bool notificationSeen;
  String? image;
  String? name;
  String? referralCode;
  String? referralUrl;
  String? displayName;
  bool? signupStatus;
  final UserMembershipRes? membership;
  int? affiliateStatus;
  String? phoneCode;
  dynamic pointEarn;
  num? selfRank;
  final String? imageType;

  UserRes({
    this.imageType,
    this.email,
    this.membership,
    this.phone,
    this.roleId,
    this.token,
    this.userId,
    this.notificationSeen = false,
    this.image,
    this.name,
    this.referralCode,
    this.referralUrl,
    this.displayName,
    this.signupStatus = false,
    this.affiliateStatus,
    this.phoneCode,
    this.pointEarn,
    this.selfRank,
  });

  factory UserRes.fromJson(Map<String, dynamic> json) => UserRes(
        imageType: json['image_type'],
        email: json["email"],
        userId: json['_id'],
        phone: json["phone"],
        roleId: json["role_id"],
        membership: json["membership"] == null
            ? null
            : UserMembershipRes.fromJson(json["membership"]),
        token: json["token"],
        image: json["image"],
        name: json["name"],
        referralCode: json["referral_code"],
        referralUrl: json["referral_url"],
        displayName: json["display_name"],
        signupStatus: json["signupStatus"],
        affiliateStatus: json["affiliate_status"],
        phoneCode: json["phone_code"],
        pointEarn: json["point_earn"],
        selfRank: json['self_rank'],
      );

  Map<String, dynamic> toJson() => {
        'image_type': imageType,
        "email": email,
        "phone": phone,
        "_id": userId,
        "role_id": roleId,
        "token": token,
        "image": image,
        "name": name,
        "referral_code": referralCode,
        "referral_url": referralUrl,
        "display_name": displayName,
        "membership": membership?.toJson(),
        "signupStatus": signupStatus,
        "affiliate_status": affiliateStatus,
        "phone_code": phoneCode,
        "point_earn": pointEarn,
        "self_rank": selfRank,
      };
}

class UserMembershipRes {
  int? purchased;
  final String? displayName;
  final String? productID;
  final HomeLoginBoxRes? upgradeText;

  UserMembershipRes({
    this.purchased,
    this.displayName,
    this.productID,
    this.upgradeText,
  });

  factory UserMembershipRes.fromJson(Map<String, dynamic> json) =>
      UserMembershipRes(
        purchased: json["purchased"],
        displayName: json["display_name"],
        productID: json['product_id'],
        upgradeText: json["upgrade_text"] == null
            ? null
            : HomeLoginBoxRes.fromJson(json["upgrade_text"]),
      );

  Map<String, dynamic> toJson() => {
        "purchased": purchased,
        "display_name": displayName,
        'product_id': productID,
        "upgrade_text": upgradeText?.toJson(),
      };
}

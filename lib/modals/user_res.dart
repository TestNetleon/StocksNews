import 'dart:convert';

UserRes userResFromJson(String str) => UserRes.fromJson(json.decode(str));

String userResToJson(UserRes data) => json.encode(data.toJson());

class UserRes {
  String? userId;
  String? email;
  String? phone;
  final String? roleId;
  final int? emailOtp;
  final int? phoneOtp;
  String? username;
  final int? otp;
  final String? token;
  final String? type;
  bool notificationSeen;
  String? image;
  String? name;
  String? signUpSuccessful;
  String? yourAccountHasBeenCreated;
  String? referralCode;
  String? referralUrl;
  String? displayName;
  bool? signupStatus;
  // int? subscriptionPurchased;
  final UserMembershipRes? membership;

  UserRes({
    // this.subscriptionPurchased = 0,
    this.email,
    this.membership,
    this.phone,
    this.roleId,
    this.emailOtp,
    this.phoneOtp,
    this.otp,
    this.username,
    this.token,
    this.userId,
    this.type,
    this.notificationSeen = false,
    this.image,
    this.name,
    this.signUpSuccessful,
    this.yourAccountHasBeenCreated,
    this.referralCode,
    this.referralUrl,
    this.displayName,
    this.signupStatus = false,
  });

  factory UserRes.fromJson(Map<String, dynamic> json) => UserRes(
        email: json["email"],
        userId: json['_id'],
        phone: json["phone"],
        roleId: json["role_id"],
        emailOtp: json["email_otp"],
        phoneOtp: json["phone_otp"],
        // subscriptionPurchased: json["subscription_purchased"],
        username: json["username"],
        otp: json["otp"],
        membership: json["membership"] == null
            ? null
            : UserMembershipRes.fromJson(json["membership"]),
        token: json["token"],
        type: json["type"],
        image: json["image"],
        name: json["name"],
        signUpSuccessful: json["sign_up_successful"],
        yourAccountHasBeenCreated: json["your_account_has_been_created"],
        referralCode: json["referral_code"],
        referralUrl: json["referral_url"],
        displayName: json["display_name"],
        signupStatus: json["signupStatus"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "phone": phone,
        "_id": userId,
        "role_id": roleId,
        // "subscription_purchased": subscriptionPurchased,
        "email_otp": emailOtp,
        "phone_otp": phoneOtp,
        "username": username,
        "otp": otp,
        "token": token,
        "type": type,
        "image": image,
        "name": name,
        "sign_up_successful": signUpSuccessful,
        "your_account_has_been_created": yourAccountHasBeenCreated,
        "referral_code": referralCode,
        "referral_url": referralUrl,
        "display_name": displayName,
        "membership": membership?.toJson(),
        "signupStatus": signupStatus,
      };
}

class UserMembershipRes {
  final int? purchased;
  final String? displayName;

  final List<String>? permissions;

  UserMembershipRes({
    this.purchased,
    this.displayName,
    this.permissions,
  });

  factory UserMembershipRes.fromJson(Map<String, dynamic> json) =>
      UserMembershipRes(
        purchased: json["purchased"],
        displayName: json["display_name"],
        permissions: json["permissions"] == null
            ? []
            : List<String>.from(json["permissions"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "purchased": purchased,
        "display_name": displayName,
        "permissions": permissions == null
            ? []
            : List<dynamic>.from(permissions!.map((x) => x)),
      };
}

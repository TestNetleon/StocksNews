import 'dart:convert';

UserRes userResFromJson(String str) => UserRes.fromJson(json.decode(str));

String userResToJson(UserRes data) => json.encode(data.toJson());

class UserRes {
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

  UserRes({
    required this.email,
    required this.phone,
    required this.roleId,
    required this.emailOtp,
    required this.phoneOtp,
    required this.otp,
    required this.username,
    required this.token,
    required this.type,
    this.notificationSeen = false,
    this.image,
    this.name,
    this.signUpSuccessful,
    this.yourAccountHasBeenCreated,
    this.referralCode,
    this.referralUrl,
    this.displayName,
  });

  factory UserRes.fromJson(Map<String, dynamic> json) => UserRes(
        email: json["email"],
        phone: json["phone"],
        roleId: json["role_id"],
        emailOtp: json["email_otp"],
        phoneOtp: json["phone_otp"],
        username: json["username"],
        otp: json["otp"],
        token: json["token"],
        type: json["type"],
        image: json["image"],
        name: json["name"],
        signUpSuccessful: json["sign_up_successful"],
        yourAccountHasBeenCreated: json["your_account_has_been_created"],
        referralCode: json["referral_code"],
        referralUrl: json["referral_url"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "phone": phone,
        "role_id": roleId,
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
      };
}

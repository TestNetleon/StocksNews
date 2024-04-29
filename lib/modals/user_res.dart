import 'dart:convert';

UserRes userResFromJson(String str) => UserRes.fromJson(json.decode(str));

String userResToJson(UserRes data) => json.encode(data.toJson());

class UserRes {
  String? email;
  final String? phone;
  final String? roleId;
  final int? emailOtp;
  final int? phoneOtp;
  String? username;
  final int? otp;
  final String? token;
  final String? type;
  String? image;
  String? name;
//
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
    this.image,
    this.name,
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
      };
}

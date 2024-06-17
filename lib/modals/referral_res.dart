import 'dart:convert';

ReferralRes referralResFromJson(String str) =>
    ReferralRes.fromJson(json.decode(str));

String referralResToJson(ReferralRes data) => json.encode(data.toJson());

class ReferralRes {
  final String? title;
  final String? message;
  final String? shareText;
  final bool? shwReferral;

  ReferralRes({
    this.title,
    this.message,
    this.shareText,
    this.shwReferral,
  });

  factory ReferralRes.fromJson(Map<String, dynamic> json) => ReferralRes(
      title: json["title"],
      message: json["message"],
      shareText: json["share_text"],
      shwReferral: json['show_referral']);

  Map<String, dynamic> toJson() => {
        "title": title,
        "message": message,
        "share_text": shareText,
        "show_referral": shwReferral,
      };
}

import 'dart:convert';

ReferSuccessRes referSuccessResFromJson(String str) =>
    ReferSuccessRes.fromJson(json.decode(str));

String referSuccessResToJson(ReferSuccessRes data) =>
    json.encode(data.toJson());

class ReferSuccessRes {
  String referralUrl;
  String referralCode;
  String successTitle;
  String successSubTitle;

  ReferSuccessRes({
    required this.referralUrl,
    required this.referralCode,
    required this.successTitle,
    required this.successSubTitle,
  });

  factory ReferSuccessRes.fromJson(Map<String, dynamic> json) {
    return ReferSuccessRes(
      referralUrl: json['referral_url'],
      referralCode: json['referral_code'],
      successTitle: json['success_title'],
      successSubTitle: json['success_sub_title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referral_url': referralUrl,
      'referral_code': referralCode,
      'success_title': successTitle,
      'success_sub_title': successSubTitle,
    };
  }
}

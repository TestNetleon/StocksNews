import 'dart:convert';

ReferralRes referralResFromJson(String str) =>
    ReferralRes.fromJson(json.decode(str));

String referralResToJson(ReferralRes data) => json.encode(data.toJson());

class ReferralRes {
  final dynamic referralStatus;
  final String? title;
  final String? subTitle;
  final PointsSummary? pointsSummary;
  final ReferLogin? referLogin;

  ReferralRes({
    required this.referralStatus,
    required this.title,
    required this.subTitle,
    required this.pointsSummary,
    required this.referLogin,
  });

  factory ReferralRes.fromJson(Map<String, dynamic> json) => ReferralRes(
        referralStatus: json["referral_status"],
        title: json["title"],
        subTitle: json["sub_title"],
        pointsSummary: json["points_summary"] == null
            ? null
            : PointsSummary.fromJson(json["points_summary"]),
        referLogin: json["refer_login"] == null
            ? null
            : ReferLogin.fromJson(json["refer_login"]),
      );

  Map<String, dynamic> toJson() => {
        "referral_status": referralStatus,
        "title": title,
        "sub_title": subTitle,
        "points_summary": pointsSummary?.toJson(),
        "refer_login": referLogin?.toJson(),
      };
}

class PointsSummary {
  final String? title;
  final List<ReferralPointRes>? data;

  PointsSummary({
    required this.title,
    required this.data,
  });

  factory PointsSummary.fromJson(Map<String, dynamic> json) => PointsSummary(
        title: json["title"],
        data: json["data"] == null
            ? null
            : List<ReferralPointRes>.from(
                json["data"].map((x) => ReferralPointRes.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ReferralPointRes {
  final String? icon;
  final String? title;
  final dynamic value;
  final String? txnType;
  final String? text;

  ReferralPointRes({
    required this.icon,
    required this.title,
    required this.value,
    required this.txnType,
    required this.text,
  });

  factory ReferralPointRes.fromJson(Map<String, dynamic> json) =>
      ReferralPointRes(
        icon: json["icon"],
        title: json["title"],
        value: json["value"],
        txnType: json["txn_type"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "title": title,
        "value": value,
        "txn_type": txnType,
        "text": text,
      };
}

class ReferLogin {
  final String? title;
  final String? note;
  final String? subTitle;
  final String? btnText;
  final String? verifyBtnText;
  final String? text;

  ReferLogin({
    this.note,
    this.text,
    this.title,
    this.subTitle,
    this.btnText,
    this.verifyBtnText,
  });

  factory ReferLogin.fromJson(Map<String, dynamic> json) => ReferLogin(
        title: json["title"],
        note: json['note'],
        text: json['text'],
        subTitle: json["sub_title"],
        btnText: json["btn_text"],
        verifyBtnText: json["verify_btn_text"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        'note': note,
        'text': text,
        "sub_title": subTitle,
        "btn_text": btnText,
        "verify_btn_text": verifyBtnText,
      };
}

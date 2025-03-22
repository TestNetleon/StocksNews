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
  final PendingFriends? pendingFriends;
  final String? nudgeText;

  ReferralRes({
    required this.referralStatus,
    required this.title,
    required this.subTitle,
    required this.pointsSummary,
    required this.referLogin,
    required this.pendingFriends,
    required this.nudgeText,
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
        pendingFriends: json["pending_friends"] == null
            ? null
            : PendingFriends.fromJson(json["pending_friends"]),
        nudgeText: json["nudge_text"],
      );

  Map<String, dynamic> toJson() => {
        "referral_status": referralStatus,
        "title": title,
        "sub_title": subTitle,
        "points_summary": pointsSummary?.toJson(),
        "refer_login": referLogin?.toJson(),
        "pending_friends": pendingFriends?.toJson(),
        "nudge_text": nudgeText,
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

class PendingFriends {
  final String? title;
  final String? subTitle;
  final List<PendingFriendData>? data;

  PendingFriends({
    required this.title,
    required this.subTitle,
    required this.data,
  });

  factory PendingFriends.fromJson(Map<String, dynamic> json) => PendingFriends(
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? null
            : List<PendingFriendData>.from(
                json["data"].map((x) => PendingFriendData.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class PendingFriendData {
  final String? image;
  final String imageType;
  final dynamic displayName;
  final String? name;
  final String? email;
  final dynamic dbId;
  final dynamic phone;
  final dynamic points;
  final dynamic status;

  PendingFriendData({
    required this.image,
    required this.imageType,
    required this.displayName,
    required this.name,
    required this.email,
    required this.dbId,
    required this.phone,
    required this.points,
    required this.status,
  });

  factory PendingFriendData.fromJson(Map<String, dynamic> json) =>
      PendingFriendData(
        image: json["image"],
        imageType: json["image_type"],
        displayName: json["display_name"],
        name: json["name"],
        email: json["email"],
        dbId: json["db_id"],
        phone: json["phone"],
        points: json["points"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "image_type": imageType,
        "display_name": displayName,
        "name": name,
        "email": email,
        "db_id": dbId,
        "phone": phone,
        "points": points,
        "status": status,
      };
}

import 'dart:convert';

ReferralPointsRes referralPointsResFromJson(String str) =>
    ReferralPointsRes.fromJson(json.decode(str));

String referralPointsResToJson(ReferralPointsRes data) =>
    json.encode(data.toJson());

class ReferralPointsRes {
  final int? totalPages;
  final List<ReferralPoints>? data;

  ReferralPointsRes({
    required this.totalPages,
    required this.data,
  });

  factory ReferralPointsRes.fromJson(Map<String, dynamic> json) =>
      ReferralPointsRes(
        totalPages: json["total_pages"],
        data: json["data"] == null
            ? null
            : List<ReferralPoints>.from(
                json["data"].map((x) => ReferralPoints.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_pages": totalPages,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ReferralPoints {
  final dynamic id;
  final String? label;
  final String? txnDetail;
  final dynamic txnId;
  final String? title;
  final String? duration;
  final String? slug;
  final String? txnType;
  final String? icon;
  final dynamic earn;
  final dynamic spent;
  final String? createdAt;

  ReferralPoints({
    required this.id,
    required this.label,
    required this.txnDetail,
    required this.txnId,
    required this.title,
    required this.duration,
    required this.slug,
    required this.txnType,
    required this.icon,
    required this.earn,
    required this.spent,
    required this.createdAt,
  });

  factory ReferralPoints.fromJson(Map<String, dynamic> json) => ReferralPoints(
        createdAt: json["created_at"],
        id: json["id"],
        label: json["label"],
        txnDetail: json["txn_detail"],
        txnId: json["txn_id"],
        title: json["title"],
        duration: json["duration"],
        slug: json["slug"],
        txnType: json["txn_type"],
        icon: json["icon"],
        earn: json["earn"],
        spent: json["spent"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "id": id,
        "label": label,
        "txn_detail": txnDetail,
        "txn_id": txnId,
        "title": title,
        "duration": duration,
        "slug": slug,
        "txn_type": txnType,
        "icon": icon,
        "earn": earn,
        "spent": spent,
      };
}

import 'dart:convert';

List<AffiliateTransactionRes> affiliateTransactionResFromJson(String str) =>
    List<AffiliateTransactionRes>.from(
        json.decode(str).map((x) => AffiliateTransactionRes.fromJson(x)));

String affiliateTransactionResToJson(List<AffiliateTransactionRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AffiliateTransactionRes {
  final String? createdAt;
  final String? txnDetail;
  final dynamic txnId;
  final String? title;
  final String? slug;
  final String? txnType;
  final int? earn;
  final String? icon;
  final int? spent;
  final dynamic label;
  final dynamic duration;

  AffiliateTransactionRes({
    this.createdAt,
    this.txnDetail,
    this.txnId,
    this.title,
    this.slug,
    this.txnType,
    this.earn,
    this.spent,
    this.icon,
    this.label,
    this.duration,
  });

  factory AffiliateTransactionRes.fromJson(Map<String, dynamic> json) =>
      AffiliateTransactionRes(
        createdAt: json["created_at"],
        txnDetail: json["txn_detail"],
        txnId: json["txn_id"],
        title: json["title"],
        slug: json["slug"],
        txnType: json["txn_type"],
        earn: json["earn"],
        spent: json["spent"],
        icon: json["icon"],
        label: json["label"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "txn_detail": txnDetail,
        "txn_id": txnId,
        "title": title,
        "slug": slug,
        "txn_type": txnType,
        "earn": earn,
        "spent": spent,
        "icon": icon,
        "label": label,
        "duration": duration,
      };
}

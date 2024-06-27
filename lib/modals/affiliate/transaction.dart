import 'dart:convert';

List<AffiliateTransactionRes> affiliateTransactionResFromJson(String str) =>
    List<AffiliateTransactionRes>.from(
        json.decode(str).map((x) => AffiliateTransactionRes.fromJson(x)));

String affiliateTransactionResToJson(List<AffiliateTransactionRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AffiliateTransactionRes {
  final String? createdAt;
  final String? txnDetail;
  final int? earn;
  final int? spent;

  AffiliateTransactionRes({
    this.createdAt,
    this.txnDetail,
    this.earn,
    this.spent,
  });

  factory AffiliateTransactionRes.fromJson(Map<String, dynamic> json) =>
      AffiliateTransactionRes(
        createdAt: json["created_at"],
        txnDetail: json["txn_detail"],
        earn: json["earn"],
        spent: json["spent"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "txn_detail": txnDetail,
        "earn": earn,
        "spent": spent,
      };
}

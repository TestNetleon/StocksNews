import 'dart:convert';

List<MembershipRes> membershipResFromJson(String str) =>
    List<MembershipRes>.from(
        json.decode(str).map((x) => MembershipRes.fromJson(x)));

String membershipResToJson(List<MembershipRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MembershipRes {
  final String? displayName;

  final String? purchasedAt;
  final String? expirationAt;
  final String? transactionId;
  final String? price;
  final int? status;

  MembershipRes({
    this.displayName,
    this.purchasedAt,
    this.expirationAt,
    this.transactionId,
    this.price,
    this.status,
  });

  factory MembershipRes.fromJson(Map<String, dynamic> json) => MembershipRes(
        displayName: json["display_name"],
        purchasedAt: json["purchased_at"],
        expirationAt: json["expiration_at"],
        transactionId: json["transaction_id"],
        price: json["price"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "display_name": displayName,
        "purchased_at": purchasedAt,
        "expiration_at": expirationAt,
        "transaction_id": transactionId,
        "price": price,
        "status": status,
      };
}

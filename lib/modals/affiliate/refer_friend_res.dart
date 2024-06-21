import 'dart:convert';

List<AffiliateReferRes> affiliateReferResFromJson(String str) =>
    List<AffiliateReferRes>.from(
        json.decode(str).map((x) => AffiliateReferRes.fromJson(x)));

String affiliateReferResToJson(List<AffiliateReferRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AffiliateReferRes {
  final String? displayName;
  final String? name;
  final String? image;
  final String? email;
  final String? phone;
  final num? points;
  final num? status;
  double timer;
  final int? dbId;

  AffiliateReferRes({
    this.displayName,
    this.name,
    this.image,
    this.email,
    this.dbId,
    this.phone,
    this.points,
    this.status,
    this.timer = 0,
  });

  factory AffiliateReferRes.fromJson(Map<String, dynamic> json) =>
      AffiliateReferRes(
        displayName: json["display_name"],
        name: json["name"],
        image: json["image"],
        dbId: json["db_id"],
        email: json["email"],
        phone: json["phone"],
        points: json["points"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "display_name": displayName,
        "name": name,
        "image": image,
        "email": email,
        "db_id": dbId,
        "phone": phone,
        "points": points,
        "status": status,
      };
}

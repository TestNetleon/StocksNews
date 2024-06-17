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

  AffiliateReferRes({
    this.displayName,
    this.name,
    this.image,
    this.email,
    this.phone,
    this.points,
    this.status,
  });

  factory AffiliateReferRes.fromJson(Map<String, dynamic> json) =>
      AffiliateReferRes(
        displayName: json["display_name"],
        name: json["name"],
        image: json["image"],
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
        "phone": phone,
        "points": points,
        "status": status,
      };
}

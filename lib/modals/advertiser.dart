import 'dart:convert';

AdvertiserRes advertiserResFromJson(String str) =>
    AdvertiserRes.fromJson(json.decode(str));

String advertiserResToJson(AdvertiserRes data) => json.encode(data.toJson());

class AdvertiserRes {
  final String? id;
  final String? agreeUrl;

  AdvertiserRes({
    this.id,
    this.agreeUrl,
  });

  factory AdvertiserRes.fromJson(Map<String, dynamic> json) => AdvertiserRes(
        id: json["id"],
        agreeUrl: json["agree_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "agree_url": agreeUrl,
      };
}

import 'dart:convert';

MarketRes marketResFromJson(String str) => MarketRes.fromJson(json.decode(str));

String marketResToJson(MarketRes data) => json.encode(data.toJson());

class MarketRes {
  final List<MarketResData>? data;

  MarketRes({required this.data});

  factory MarketRes.fromJson(Map<String, dynamic> json) => MarketRes(
        data: json["data"] == null
            ? null
            : List<MarketResData>.from(
                json["data"].map((x) => MarketResData.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class MarketResData {
  final String? icon;
  final String? slug;
  final String? title;
  final List<MarketResData>? data;
  final List<dynamic>? filter;

  MarketResData({
    this.icon,
    this.slug,
    this.title,
    this.data,
    this.filter,
  });

  factory MarketResData.fromJson(Map<String, dynamic> json) => MarketResData(
        icon: json["icon"],
        slug: json["slug"],
        title: json["title"],
        data: json["data"] == null
            ? null
            : List<MarketResData>.from(
                json["data"].map((x) => MarketResData.fromJson(x)),
              ),
        filter: json["filter"] == null
            ? null
            : List<dynamic>.from(json["filter"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "slug": slug,
        "title": title,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "filter":
            filter == null ? null : List<dynamic>.from(filter!.map((x) => x)),
      };
}

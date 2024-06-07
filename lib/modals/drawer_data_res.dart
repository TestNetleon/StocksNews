// To parse this JSON data, do
//
//     final drawerDataRes = drawerDataResFromJson(jsonString);

import 'dart:convert';

DrawerDataRes drawerDataResFromJson(String str) =>
    DrawerDataRes.fromJson(json.decode(str));

String drawerDataResToJson(DrawerDataRes data) => json.encode(data.toJson());

class DrawerDataRes {
  final Rating? rating;

  DrawerDataRes({
    this.rating,
  });

  factory DrawerDataRes.fromJson(Map<String, dynamic> json) => DrawerDataRes(
        rating: json["rating"] == null ? null : Rating.fromJson(json["rating"]),
      );

  Map<String, dynamic> toJson() => {
        "rating": rating?.toJson(),
      };
}

class Rating {
  final String? title;
  final String? description;
  final String? url;

  Rating({
    this.title,
    this.description,
    this.url,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        title: json["title"],
        description: json["description"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "url": url,
      };
}

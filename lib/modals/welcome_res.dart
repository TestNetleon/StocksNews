// To parse this JSON data, do
//
//     final welcomeRes = welcomeResFromJson(jsonString);

import 'dart:convert';

List<WelcomeRes> welcomeResFromJson(String str) =>
    List<WelcomeRes>.from(json.decode(str).map((x) => WelcomeRes.fromJson(x)));

String welcomeResToJson(List<WelcomeRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WelcomeRes {
  final String title;
  final String colorText;
  final String description;

  WelcomeRes({
    required this.title,
    required this.colorText,
    required this.description,
  });

  factory WelcomeRes.fromJson(Map<String, dynamic> json) => WelcomeRes(
        title: json["title"],
        colorText: json["colorText"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "colorText": colorText,
        "description": description,
      };
}

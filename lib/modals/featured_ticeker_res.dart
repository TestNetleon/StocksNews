// To parse this JSON data, do
//
//     final featuredTickerRes = featuredTickerResFromJson(jsonString);

import 'dart:convert';

import 'home_alert_res.dart';

FeaturedTickerRes featuredTickerResFromJson(String str) =>
    FeaturedTickerRes.fromJson(json.decode(str));

String featuredTickerResToJson(FeaturedTickerRes data) =>
    json.encode(data.toJson());

class FeaturedTickerRes {
  // final int currentPage;
  List<HomeAlertsRes> data;
  final int lastPage;

  FeaturedTickerRes({
    // required this.currentPage,
    required this.data,
    required this.lastPage,
  });

  factory FeaturedTickerRes.fromJson(Map<String, dynamic> json) =>
      FeaturedTickerRes(
        // currentPage: json["current_page"],
        data: List<HomeAlertsRes>.from(
            json["data"].map((x) => HomeAlertsRes.fromJson(x))),
        lastPage: json["last_page"],
      );

  Map<String, dynamic> toJson() => {
        // "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "last_page": lastPage,
      };
}

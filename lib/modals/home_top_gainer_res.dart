import 'dart:convert';

import 'package:stocks_news_new/modals/home_trending_res.dart';

HomeTopGainerRes homeTrendingResFromJson(String str) =>
    HomeTopGainerRes.fromJson(json.decode(str));

String homeTrendingResToJson(HomeTopGainerRes data) =>
    json.encode(data.toJson());

//
class HomeTopGainerRes {
  final List<Top>? gainers;
  final TextRes? text;

  HomeTopGainerRes({
    required this.gainers,
    this.text,
  });

  factory HomeTopGainerRes.fromJson(Map<String, dynamic> json) =>
      HomeTopGainerRes(
        text: json["text"] == null ? null : TextRes.fromJson(json["text"]),
        gainers: json["ticker_info"] == null
            ? null
            : List<Top>.from(json["ticker_info"].map((x) => Top.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "text": text?.toJson(),
        "ticker_info": gainers == null
            ? null
            : List<dynamic>.from(gainers!.map((x) => x.toJson())),
      };
}

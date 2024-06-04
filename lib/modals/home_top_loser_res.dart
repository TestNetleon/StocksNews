import 'dart:convert';

import 'package:stocks_news_new/modals/home_trending_res.dart';

HomeTopLosersRes homeTrendingResFromJson(String str) =>
    HomeTopLosersRes.fromJson(json.decode(str));

String homeTrendingResToJson(HomeTopLosersRes data) =>
    json.encode(data.toJson());

class HomeTopLosersRes {
  final List<Top>? losers;
  final TextRes? text;

  HomeTopLosersRes({
    required this.losers,
    this.text,
  });

  factory HomeTopLosersRes.fromJson(Map<String, dynamic> json) =>
      HomeTopLosersRes(
        text: json["text"] == null ? null : TextRes.fromJson(json["text"]),
        losers: json["ticker_info"] == null
            ? null
            : List<Top>.from(json["ticker_info"].map((x) => Top.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "text": text?.toJson(),
        "ticker_info": losers == null
            ? null
            : List<dynamic>.from(losers!.map((x) => x.toJson())),
      };
}

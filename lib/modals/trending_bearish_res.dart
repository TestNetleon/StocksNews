import 'dart:convert';

import 'package:stocks_news_new/modals/trending_res.dart';

TrendingBearishRes trendingBearishResFromJson(String str) =>
    TrendingBearishRes.fromJson(json.decode(str));

String trendingBearishResToJson(TrendingBearishRes data) =>
    json.encode(data.toJson());

class TrendingBearishRes {
  final List<MostBullishData>? mostBearish;

  TrendingBearishRes({
    required this.mostBearish,
  });

  factory TrendingBearishRes.fromJson(Map<String, dynamic> json) =>
      TrendingBearishRes(
        mostBearish: json["most_bearish"] == null
            ? null
            : List<MostBullishData>.from(
                json["most_bearish"].map((x) => MostBullishData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "most_bearish": mostBearish == null
            ? null
            : List<dynamic>.from(mostBearish!.map((x) => x.toJson())),
      };
}

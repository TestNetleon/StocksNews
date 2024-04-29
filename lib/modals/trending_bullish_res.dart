import 'dart:convert';

import 'package:stocks_news_new/modals/trending_res.dart';

TrendingBullishRes trendingBullishResFromJson(String str) =>
    TrendingBullishRes.fromJson(json.decode(str));

String trendingBullishResToJson(TrendingBullishRes data) =>
    json.encode(data.toJson());

class TrendingBullishRes {
  final List<MostBullishData>? mostBullish;

  TrendingBullishRes({
    required this.mostBullish,
  });
//
  factory TrendingBullishRes.fromJson(Map<String, dynamic> json) =>
      TrendingBullishRes(
        mostBullish: json["most_bullish"] == null
            ? null
            : List<MostBullishData>.from(
                json["most_bullish"].map((x) => MostBullishData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "most_bullish": mostBullish == null
            ? null
            : List<dynamic>.from(mostBullish!.map((x) => x.toJson())),
      };
}

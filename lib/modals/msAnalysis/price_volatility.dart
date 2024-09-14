import 'dart:convert';

import 'package:stocks_news_new/modals/msAnalysis/radar_chart.dart';

MsPriceVolatilityRes msPriceVolatilityResFromJson(String str) =>
    MsPriceVolatilityRes.fromJson(json.decode(str));

String msPriceVolatilityResToJson(MsPriceVolatilityRes data) =>
    json.encode(data.toJson());

class MsPriceVolatilityRes {
  final int? volatility;
  final List<String>? keyHighlights;
  final List<MsRadarChartRes>? score;
  MsPriceVolatilityRes({
    this.volatility,
    this.keyHighlights,
    this.score,
  });

  factory MsPriceVolatilityRes.fromJson(Map<String, dynamic> json) =>
      MsPriceVolatilityRes(
        volatility: json["volatility"],
        score: json["score"] == null
            ? []
            : List<MsRadarChartRes>.from(
                json["score"]!.map((x) => MsRadarChartRes.fromJson(x))),
        keyHighlights: json["key_highlights"] == null
            ? []
            : List<String>.from(json["key_highlights"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "volatility": volatility,
        "score": score == null
            ? []
            : List<dynamic>.from(score!.map((x) => x.toJson())),
        "key_highlights": keyHighlights == null
            ? []
            : List<dynamic>.from(keyHighlights!.map((x) => x)),
      };
}

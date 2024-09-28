import 'dart:convert';

MsPriceVolatilityRes msPriceVolatilityResFromJson(String str) =>
    MsPriceVolatilityRes.fromJson(json.decode(str));

String msPriceVolatilityResToJson(MsPriceVolatilityRes data) =>
    json.encode(data.toJson());

class MsPriceVolatilityRes {
  // final int? volatility;
  // final List<String>? keyHighlights;
  // final List<MsRadarChartRes>? score;
  final num? stockVolatility;
  final num? industryVolatility;
  final String? text;
  MsPriceVolatilityRes({
    // this.volatility,
    // this.keyHighlights,
    // this.score,
    this.stockVolatility,
    this.industryVolatility,
    this.text,
  });

  factory MsPriceVolatilityRes.fromJson(Map<String, dynamic> json) =>
      MsPriceVolatilityRes(
        // volatility: json["volatility"],
        stockVolatility: json["stock_volatility"],
        industryVolatility: json["industry_volatility"],
        text: json["text"],
        // score: json["score"] == null
        //     ? []
        //     : List<MsRadarChartRes>.from(
        //         json["score"]!.map((x) => MsRadarChartRes.fromJson(x))),
        // keyHighlights: json["key_highlights"] == null
        //     ? []
        //     : List<String>.from(json["key_highlights"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        // "volatility": volatility,
        "stock_volatility": stockVolatility,
        "industry_volatility": industryVolatility,
        "text": text,
        // "score": score == null
        //     ? []
        //     : List<dynamic>.from(score!.map((x) => x.toJson())),
        // "key_highlights": keyHighlights == null
        //     ? []
        //     : List<dynamic>.from(keyHighlights!.map((x) => x)),
      };
}

import 'dart:convert';

AnalysisRes analysisResFromJson(String str) =>
    AnalysisRes.fromJson(json.decode(str));

String analysisResToJson(AnalysisRes data) => json.encode(data.toJson());

//
class AnalysisRes {
  final num fundamentalPercent;
  final num shortTermPercent;
  final num longTermPercent;
  final num valuationPercent;
  final num analystRankingPercent;
  final num overallPercent;
  final num setimentPercent;

  AnalysisRes({
    required this.fundamentalPercent,
    required this.shortTermPercent,
    required this.longTermPercent,
    required this.valuationPercent,
    required this.analystRankingPercent,
    required this.overallPercent,
    required this.setimentPercent,
  });

  factory AnalysisRes.fromJson(Map<String, dynamic> json) => AnalysisRes(
        fundamentalPercent: json["fundamental_percent"],
        shortTermPercent: json["short_term_percent"],
        longTermPercent: json["long_term_percent"],
        valuationPercent: json["valuation_percent"],
        analystRankingPercent: json["analyst_ranking_percent"],
        overallPercent: json["overall_percent"]?.toDouble(),
        setimentPercent: json["sentiment_percent"],
      );

  Map<String, dynamic> toJson() => {
        "fundamental_percent": fundamentalPercent,
        "short_term_percent": shortTermPercent,
        "long_term_percent": longTermPercent,
        "valuation_percent": valuationPercent,
        "analyst_ranking_percent": analystRankingPercent,
        "overall_percent": overallPercent,
        "sentiment_percent": setimentPercent,
      };
}

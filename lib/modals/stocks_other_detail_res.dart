// To parse this JSON data, do
//
//     final stocksOtherDetails = stocksOtherDetailsFromJson(jsonString);

import 'dart:convert';

StocksOtherDetailsRes stocksOtherDetailsFromJson(String str) =>
    StocksOtherDetailsRes.fromJson(json.decode(str));

String stocksOtherDetailsToJson(StocksOtherDetailsRes data) =>
    json.encode(data.toJson());

class StocksOtherDetailsRes {
  final Earning? earning;
  final Score? score;

  StocksOtherDetailsRes({
    this.earning,
    this.score,
  });

  factory StocksOtherDetailsRes.fromJson(Map<String, dynamic> json) =>
      StocksOtherDetailsRes(
        earning:
            json["earning"] == null ? null : Earning.fromJson(json["earning"]),
        score: json["score"] == null ? null : Score.fromJson(json["score"]),
      );

  Map<String, dynamic> toJson() => {
        "earning": earning?.toJson(),
        "score": score?.toJson(),
      };
}

class Earning {
  final String? title;
  final String? text;
  final List<EarningData>? data;

  Earning({
    this.title,
    this.text,
    this.data,
  });

  factory Earning.fromJson(Map<String, dynamic> json) => Earning(
        title: json["title"],
        text: json["text"],
        data: json["data"] == null
            ? []
            : List<EarningData>.from(
                json["data"]!.map((x) => EarningData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "text": text,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class EarningData {
  final String? quarter;
  final String? eps;
  final String? epsPercentChange;
  final String? epsArrowClass;
  final String? epsArrow;
  final String? revenue;
  final String? revenuePercentChange;
  final String? revenueArrowClass;
  final String? revenueArrow;

  EarningData({
    this.quarter,
    this.eps,
    this.epsPercentChange,
    this.epsArrowClass,
    this.epsArrow,
    this.revenue,
    this.revenuePercentChange,
    this.revenueArrowClass,
    this.revenueArrow,
  });

  factory EarningData.fromJson(Map<String, dynamic> json) => EarningData(
        quarter: json["quarter"],
        eps: json["eps"],
        epsPercentChange: json["eps_percent_change"],
        epsArrowClass: json["eps_arrow_class"],
        epsArrow: json["eps_arrow"],
        revenue: json["revenue"],
        revenuePercentChange: json["revenue_percent_change"],
        revenueArrowClass: json["revenue_arrow_class"],
        revenueArrow: json["revenue_arrow"],
      );

  Map<String, dynamic> toJson() => {
        "quarter": quarter,
        "eps": eps,
        "eps_percent_change": epsPercentChange,
        "eps_arrow_class": epsArrowClass,
        "eps_arrow": epsArrow,
        "revenue": revenue,
        "revenue_percent_change": revenuePercentChange,
        "revenue_arrow_class": revenueArrowClass,
        "revenue_arrow": revenueArrow,
      };
}

class Score {
  final String? title;
  final String? text;
  final ScoreData? data;

  Score({
    this.title,
    this.text,
    this.data,
  });

  factory Score.fromJson(Map<String, dynamic> json) => Score(
        title: json["title"],
        text: json["text"],
        data: json["data"] == null ? null : ScoreData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "text": text,
        "data": data?.toJson(),
      };
}

class ScoreData {
  final String? altmanZScore;
  final String? piotroskiScore;
  final String? grade;

  ScoreData({
    this.altmanZScore,
    this.piotroskiScore,
    this.grade,
  });

  factory ScoreData.fromJson(Map<String, dynamic> json) => ScoreData(
        altmanZScore: json["altmanZScore"],
        piotroskiScore: json["piotroskiScore"],
        grade: json["grade"],
      );

  Map<String, dynamic> toJson() => {
        "altmanZScore": altmanZScore,
        "piotroskiScore": piotroskiScore,
        "grade": grade,
      };
}

import 'dart:convert';

import 'overview.dart';

SDTechnicalAnalysisRes SDTechnicalAnalysisResFromJson(String str) =>
    SDTechnicalAnalysisRes.fromJson(json.decode(str));

String SDTechnicalAnalysisResToJson(SDTechnicalAnalysisRes data) =>
    json.encode(data.toJson());

class SDTechnicalAnalysisRes {
  final TechnicalAnalysisDataRes? summary;
  final TechnicalAnalysisDataRes? technicalIndicator;
  final TechnicalAnalysisDataRes? movingAverage;

  SDTechnicalAnalysisRes({
    this.summary,
    this.technicalIndicator,
    this.movingAverage,
  });

  factory SDTechnicalAnalysisRes.fromJson(Map<String, dynamic> json) =>
      SDTechnicalAnalysisRes(
        summary: json["summary"] == null
            ? null
            : TechnicalAnalysisDataRes.fromJson(json["summary"]),
        technicalIndicator: json["technical_indicator"] == null
            ? null
            : TechnicalAnalysisDataRes.fromJson(json["technical_indicator"]),
        movingAverage: json["moving_average"] == null
            ? null
            : TechnicalAnalysisDataRes.fromJson(json["moving_average"]),
      );

  Map<String, dynamic> toJson() => {
        "summary": summary?.toJson(),
        "technical_indicator": technicalIndicator?.toJson(),
        "moving_average": movingAverage?.toJson(),
      };
}

class TechnicalAnalysisDataRes {
  final String? title;
  final List<BaseKeyValueRes>? data;
  final String? subTitle;
  final TechnicalAnalysisOverviewRes? overview;

  TechnicalAnalysisDataRes({
    this.title,
    this.data,
    this.subTitle,
    this.overview,
  });

  factory TechnicalAnalysisDataRes.fromJson(Map<String, dynamic> json) =>
      TechnicalAnalysisDataRes(
        title: json["title"],
        data: json["data"] == null
            ? []
            : List<BaseKeyValueRes>.from(
                json["data"]!.map((x) => BaseKeyValueRes.fromJson(x))),
        subTitle: json["sub_title"],
        overview: json["overview"] == null
            ? null
            : TechnicalAnalysisOverviewRes.fromJson(json["overview"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "sub_title": subTitle,
        "overview": overview?.toJson(),
      };
}

class TechnicalAnalysisOverviewRes {
  final int? totalSell;
  final int? totalBuy;
  final int? indicator;
  final String type;

  TechnicalAnalysisOverviewRes({
    this.totalSell,
    this.totalBuy,
    this.indicator,
    required this.type,
  });

  factory TechnicalAnalysisOverviewRes.fromJson(Map<String, dynamic> json) =>
      TechnicalAnalysisOverviewRes(
        totalSell: json["total_sell"],
        totalBuy: json["total_buy"],
        indicator: json["indicator"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "total_sell": totalSell,
        "total_buy": totalBuy,
        "indicator": indicator,
        "type": type,
      };
}

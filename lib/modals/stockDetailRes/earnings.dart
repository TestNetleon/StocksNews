// To parse this JSON data, do
//
//     final sdEarningsRes = sdEarningsResFromJson(jsonString);

import 'dart:convert';

import 'package:stocks_news_new/modals/faqs_res.dart';

SdEarningsRes sdEarningsResFromJson(String str) =>
    SdEarningsRes.fromJson(json.decode(str));

String sdEarningsResToJson(SdEarningsRes data) => json.encode(data.toJson());

class SdEarningsRes {
  final List<EpsEstimate>? epsEstimates;
  final List<EarningHistory>? earningHistory;
  final List<SdTopRes>? top;
  final EarningDateInfo? earningDateInfo;
  final List<FaQsRes>? faq;

  SdEarningsRes({
    this.epsEstimates,
    this.earningHistory,
    this.top,
    this.earningDateInfo,
    this.faq,
  });

  factory SdEarningsRes.fromJson(Map<String, dynamic> json) => SdEarningsRes(
        epsEstimates: json["eps_estimates"] == null
            ? []
            : List<EpsEstimate>.from(
                json["eps_estimates"]!.map((x) => EpsEstimate.fromJson(x))),
        earningHistory: json["earning_history"] == null
            ? []
            : List<EarningHistory>.from(json["earning_history"]!
                .map((x) => EarningHistory.fromJson(x))),
        top: json["top"] == null
            ? []
            : List<SdTopRes>.from(
                json["top"]!.map((x) => SdTopRes.fromJson(x))),
        earningDateInfo: json["earning_date_info"] == null
            ? null
            : EarningDateInfo.fromJson(json["earning_date_info"]),
        faq: json["faq"] == null
            ? []
            : List<FaQsRes>.from(json["faq"]!.map((x) => FaQsRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "eps_estimates": epsEstimates == null
            ? []
            : List<dynamic>.from(epsEstimates!.map((x) => x.toJson())),
        "earning_history": earningHistory == null
            ? []
            : List<dynamic>.from(earningHistory!.map((x) => x.toJson())),
        "top":
            top == null ? [] : List<dynamic>.from(top!.map((x) => x.toJson())),
        "earning_date_info": earningDateInfo?.toJson(),
        "faq":
            faq == null ? [] : List<dynamic>.from(faq!.map((x) => x.toJson())),
      };
}

class EarningDateInfo {
  final String? key;
  final String? value;

  EarningDateInfo({
    this.key,
    this.value,
  });

  factory EarningDateInfo.fromJson(Map<String, dynamic> json) =>
      EarningDateInfo(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}

class EarningHistory {
  final String? date;
  final String? quarter;
  final String? consensusEstimate;
  final String? reportedEps;
  final BeatMiss? beatMiss;
  final String? revenueEstimate;
  final String? actualRevenue;

  EarningHistory({
    this.date,
    this.quarter,
    this.consensusEstimate,
    this.reportedEps,
    this.beatMiss,
    this.revenueEstimate,
    this.actualRevenue,
  });

  factory EarningHistory.fromJson(Map<String, dynamic> json) => EarningHistory(
        date: json["date"],
        quarter: json["quarter"],
        consensusEstimate: json["consensusEstimate"],
        reportedEps: json["reportedEPS"],
        beatMiss: json["beatMiss"] == null
            ? null
            : BeatMiss.fromJson(json["beatMiss"]),
        revenueEstimate: json["revenueEstimate"],
        actualRevenue: json["actualRevenue"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "quarter": quarter,
        "consensusEstimate": consensusEstimate,
        "reportedEPS": reportedEps,
        "beatMiss": beatMiss?.toJson(),
        "revenueEstimate": revenueEstimate,
        "actualRevenue": actualRevenue,
      };
}

class BeatMiss {
  final num? value;
  final String? type;

  BeatMiss({
    this.value,
    this.type,
  });

  factory BeatMiss.fromJson(Map<String, dynamic> json) => BeatMiss(
        value: json["value"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "type": type,
      };
}

class EpsEstimate {
  final String? quarter;
  final num? numberOfEstimates;
  final String? estimatedEpsLow;
  final String? estimatedEpsHigh;
  final String? estimatedEpsAvg;

  EpsEstimate({
    this.quarter,
    this.numberOfEstimates,
    this.estimatedEpsLow,
    this.estimatedEpsHigh,
    this.estimatedEpsAvg,
  });

  factory EpsEstimate.fromJson(Map<String, dynamic> json) => EpsEstimate(
        quarter: json["quarter"],
        numberOfEstimates: json["numberOfEstimates"],
        estimatedEpsLow: json["estimatedEpsLow"],
        estimatedEpsHigh: json["estimatedEpsHigh"],
        estimatedEpsAvg: json["estimatedEpsAvg"],
      );

  Map<String, dynamic> toJson() => {
        "quarter": quarter,
        "numberOfEstimates": numberOfEstimates,
        "estimatedEpsLow": estimatedEpsLow,
        "estimatedEpsHigh": estimatedEpsHigh,
        "estimatedEpsAvg": estimatedEpsAvg,
      };
}

class SdTopRes {
  final String? key;
  final dynamic value;
  final String? other;

  SdTopRes({
    this.key,
    this.value,
    this.other,
  });

  factory SdTopRes.fromJson(Map<String, dynamic> json) => SdTopRes(
        key: json["key"],
        value: json["value"],
        other: json["other"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
        "other": other,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

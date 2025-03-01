// To parse this JSON data, do
//
//     final SDEarningsRes = SDEarningsResFromJson(jsonString);

import 'dart:convert';

import 'package:stocks_news_new/models/stockDetail/overview.dart';

import '../faq.dart';

SDEarningsRes SDEarningsResFromJson(String str) =>
    SDEarningsRes.fromJson(json.decode(str));

String SDEarningsResToJson(SDEarningsRes data) => json.encode(data.toJson());

class SDEarningsRes {
  final List<BaseKeyValueRes>? top;
  final SDEpsEstimatesRes? epsEstimates;
  final SDEarningHistoryRes? earningHistory;
  final BaseFaqRes? faq;

  SDEarningsRes({
    this.top,
    this.epsEstimates,
    this.earningHistory,
    this.faq,
  });

  factory SDEarningsRes.fromJson(Map<String, dynamic> json) => SDEarningsRes(
        top: json["top"] == null
            ? []
            : List<BaseKeyValueRes>.from(
                json["top"]!.map((x) => BaseKeyValueRes.fromJson(x))),
        epsEstimates: json["eps_estimates"] == null
            ? null
            : SDEpsEstimatesRes.fromJson(json["eps_estimates"]),
        earningHistory: json["earning_history"] == null
            ? null
            : SDEarningHistoryRes.fromJson(json["earning_history"]),
        faq: json["faq"] == null ? null : BaseFaqRes.fromJson(json["faq"]),
      );

  Map<String, dynamic> toJson() => {
        "top":
            top == null ? [] : List<dynamic>.from(top!.map((x) => x.toJson())),
        "eps_estimates": epsEstimates?.toJson(),
        "earning_history": earningHistory?.toJson(),
        "faq": faq?.toJson(),
      };
}

class SDEarningHistoryRes {
  final String? title;
  final String? subTitle;
  final List<SDEarningHistoryDataRes>? data;

  SDEarningHistoryRes({
    this.title,
    this.subTitle,
    this.data,
  });

  factory SDEarningHistoryRes.fromJson(Map<String, dynamic> json) =>
      SDEarningHistoryRes(
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<SDEarningHistoryDataRes>.from(
                json["data"]!.map((x) => SDEarningHistoryDataRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SDEarningHistoryDataRes {
  final String? date;
  final String? quarter;
  final dynamic consensusEstimate;
  final String? reportedEps;
  final String? revenueEstimate;
  final String? actualRevenue;

  SDEarningHistoryDataRes({
    this.date,
    this.quarter,
    this.consensusEstimate,
    this.reportedEps,
    this.revenueEstimate,
    this.actualRevenue,
  });

  factory SDEarningHistoryDataRes.fromJson(Map<String, dynamic> json) =>
      SDEarningHistoryDataRes(
        date: json["date"],
        quarter: json["quarter"],
        consensusEstimate: json["consensusEstimate"],
        reportedEps: json["reportedEPS"],
        revenueEstimate: json["revenueEstimate"],
        actualRevenue: json["actualRevenue"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "quarter": quarter,
        "consensusEstimate": consensusEstimate,
        "reportedEPS": reportedEps,
        "revenueEstimate": revenueEstimate,
        "actualRevenue": actualRevenue,
      };
}

class SDEpsEstimatesRes {
  final String? title;
  final String? subTitle;
  final List<SDEpsEstimatesDataRes>? data;

  SDEpsEstimatesRes({
    this.title,
    this.subTitle,
    this.data,
  });

  factory SDEpsEstimatesRes.fromJson(Map<String, dynamic> json) =>
      SDEpsEstimatesRes(
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<SDEpsEstimatesDataRes>.from(
                json["data"]!.map((x) => SDEpsEstimatesDataRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SDEpsEstimatesDataRes {
  final String? quarter;
  final int? numberOfEstimates;
  final String? estimatedEpsLow;
  final String? estimatedEpsHigh;
  final String? estimatedEpsAvg;

  SDEpsEstimatesDataRes({
    this.quarter,
    this.numberOfEstimates,
    this.estimatedEpsLow,
    this.estimatedEpsHigh,
    this.estimatedEpsAvg,
  });

  factory SDEpsEstimatesDataRes.fromJson(Map<String, dynamic> json) =>
      SDEpsEstimatesDataRes(
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

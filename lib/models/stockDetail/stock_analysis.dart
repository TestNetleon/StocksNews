// To parse this JSON data, do
//
//     final sdStockAnalysisRes = sdStockAnalysisResFromJson(jsonString);

import 'dart:convert';

import 'package:stocks_news_new/models/ticker.dart';

SDStockAnalysisRes sdStockAnalysisResFromJson(String str) =>
    SDStockAnalysisRes.fromJson(json.decode(str));

String sdStockAnalysisResToJson(SDStockAnalysisRes data) =>
    json.encode(data.toJson());

class SDStockAnalysisRes {
  final String? title;
  final String? subTitle;
  final Data? data;
  final String? text;

  SDStockAnalysisRes({
    this.title,
    this.subTitle,
    this.data,
    this.text,
  });

  factory SDStockAnalysisRes.fromJson(Map<String, dynamic> json) =>
      SDStockAnalysisRes(
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data?.toJson(),
        "text": text,
      };
}

class Data {
  final PeersData? peersData;
  final num? fundamentalPercent;
  final num? shortTermPercent;
  final num? longTermPercent;
  final num? valuationPercent;
  final num? analystRankingPercent;
  final num? sentimentPercent;
  final num? overallPercent;

  Data({
    this.peersData,
    this.fundamentalPercent,
    this.shortTermPercent,
    this.longTermPercent,
    this.valuationPercent,
    this.analystRankingPercent,
    this.sentimentPercent,
    this.overallPercent,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        peersData: json["peers_data"] == null
            ? null
            : PeersData.fromJson(json["peers_data"]),
        fundamentalPercent: json["fundamental_percent"],
        shortTermPercent: json["short_term_percent"],
        longTermPercent: json["long_term_percent"],
        valuationPercent: json["valuation_percent"],
        analystRankingPercent: json["analyst_ranking_percent"],
        sentimentPercent: json["sentiment_percent"],
        overallPercent: json["overall_percent"],
      );

  Map<String, dynamic> toJson() => {
        "peers_data": peersData?.toJson(),
        "fundamental_percent": fundamentalPercent,
        "short_term_percent": shortTermPercent,
        "long_term_percent": longTermPercent,
        "valuation_percent": valuationPercent,
        "analyst_ranking_percent": analystRankingPercent,
        "sentiment_percent": sentimentPercent,
        "overall_percent": overallPercent,
      };
}

class PeersData {
  final String? title;
  final String? subTitle;
  final List<BaseTickerRes>? data;

  PeersData({
    this.title,
    this.subTitle,
    this.data,
  });

  factory PeersData.fromJson(Map<String, dynamic> json) => PeersData(
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<BaseTickerRes>.from(
                json["data"]!.map((x) => BaseTickerRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

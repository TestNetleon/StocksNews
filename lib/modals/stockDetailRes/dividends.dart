// To parse this JSON data, do
//
//     final sdDividendsRes = sdDividendsResFromJson(jsonString);

import 'dart:convert';

import 'package:stocks_news_new/modals/faqs_res.dart';
import 'package:stocks_news_new/modals/stockDetailRes/earnings.dart';

SdDividendsRes sdDividendsResFromJson(String str) =>
    SdDividendsRes.fromJson(json.decode(str));

String sdDividendsResToJson(SdDividendsRes data) => json.encode(data.toJson());

class SdDividendsRes {
  final List<SdTopRes>? top;
  final List<DividendHistory>? dividendHistory;
  final List<FaQsRes>? faq;

  SdDividendsRes({
    this.top,
    this.dividendHistory,
    this.faq,
  });

  factory SdDividendsRes.fromJson(Map<String, dynamic> json) => SdDividendsRes(
        top: json["top"] == null
            ? []
            : List<SdTopRes>.from(
                json["top"]!.map((x) => SdTopRes.fromJson(x))),
        dividendHistory: json["dividend_history"] == null
            ? []
            : List<DividendHistory>.from(json["dividend_history"]!
                .map((x) => DividendHistory.fromJson(x))),
        faq: json["faq"] == null
            ? []
            : List<FaQsRes>.from(json["faq"]!.map((x) => FaQsRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "top":
            top == null ? [] : List<dynamic>.from(top!.map((x) => x.toJson())),
        "dividend_history": dividendHistory == null
            ? []
            : List<dynamic>.from(dividendHistory!.map((x) => x.toJson())),
        "faq":
            faq == null ? [] : List<dynamic>.from(faq!.map((x) => x.toJson())),
      };
}

class DividendHistory {
  final String? announced;
  final String? amount;
  final String? dividendHistoryYield;
  final String? exDividendDate;
  final String? recordDate;
  final String? payableDate;

  DividendHistory({
    this.announced,
    this.amount,
    this.dividendHistoryYield,
    this.exDividendDate,
    this.recordDate,
    this.payableDate,
  });

  factory DividendHistory.fromJson(Map<String, dynamic> json) =>
      DividendHistory(
        announced: json["announced"],
        amount: json["amount"],
        dividendHistoryYield: json["yield"],
        exDividendDate: json["exDividendDate"],
        recordDate: json["recordDate"],
        payableDate: json["payableDate"],
      );

  Map<String, dynamic> toJson() => {
        "announced": announced,
        "amount": amount,
        "yield": dividendHistoryYield,
        "exDividendDate": exDividendDate,
        "recordDate": recordDate,
        "payableDate": payableDate,
      };
}

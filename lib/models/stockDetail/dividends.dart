import 'dart:convert';
import 'package:stocks_news_new/models/faq.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';

SDDividendsRes SDDividendsResFromJson(String str) =>
    SDDividendsRes.fromJson(json.decode(str));

String SDDividendsResToJson(SDDividendsRes data) => json.encode(data.toJson());

class SDDividendsRes {
  final List<BaseKeyValueRes>? top;
  final DividendsRes? dividendHistory;
  final BaseFaqRes? faq;

  SDDividendsRes({
    this.top,
    this.dividendHistory,
    this.faq,
  });

  factory SDDividendsRes.fromJson(Map<String, dynamic> json) => SDDividendsRes(
        top: json["top"] == null
            ? []
            : List<BaseKeyValueRes>.from(
                json["top"]!.map((x) => BaseKeyValueRes.fromJson(x))),
        dividendHistory: json["dividend_history"] == null
            ? null
            : DividendsRes.fromJson(json["dividend_history"]),
        faq: json["faq"] == null ? null : BaseFaqRes.fromJson(json["faq"]),
      );

  Map<String, dynamic> toJson() => {
        "top":
            top == null ? [] : List<dynamic>.from(top!.map((x) => x.toJson())),
        "dividend_history": dividendHistory?.toJson(),
        "faq": faq?.toJson(),
      };
}

class DividendsRes {
  final String? title;
  final String? subTitle;
  final List<DividendsDataRes>? data;

  DividendsRes({
    this.title,
    this.subTitle,
    this.data,
  });

  factory DividendsRes.fromJson(Map<String, dynamic> json) => DividendsRes(
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<DividendsDataRes>.from(
                json["data"]!.map((x) => DividendsDataRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DividendsDataRes {
  final String? announced;
  final String? amount;
  final String? datumYield;
  final String? exDividendDate;
  final String? recordDate;
  final String? payableDate;

  DividendsDataRes({
    this.announced,
    this.amount,
    this.datumYield,
    this.exDividendDate,
    this.recordDate,
    this.payableDate,
  });

  factory DividendsDataRes.fromJson(Map<String, dynamic> json) =>
      DividendsDataRes(
        announced: json["announced"],
        amount: json["amount"],
        datumYield: json["yield"],
        exDividendDate: json["exDividendDate"],
        recordDate: json["recordDate"],
        payableDate: json["payableDate"],
      );

  Map<String, dynamic> toJson() => {
        "announced": announced,
        "amount": amount,
        "yield": datumYield,
        "exDividendDate": exDividendDate,
        "recordDate": recordDate,
        "payableDate": payableDate,
      };
}

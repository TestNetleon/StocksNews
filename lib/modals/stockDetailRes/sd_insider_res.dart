// To parse this JSON data, do
//
//     final sdInsiderTradeRes = sdInsiderTradeResFromJson(jsonString);

import 'dart:convert';

import 'package:stocks_news_new/modals/stockDetailRes/earnings.dart';

import '../faqs_res.dart';

SdInsiderTradeRes sdInsiderTradeResFromJson(String str) =>
    SdInsiderTradeRes.fromJson(json.decode(str));

String sdInsiderTradeResToJson(SdInsiderTradeRes data) =>
    json.encode(data.toJson());

class SdInsiderTradeRes {
  final List<InsiderDatum>? insiderData;
  final List<CongressionalDatum>? congressionalData;
  final List<SdTopRes>? top;
  final List<FaQsRes> faq;
  final Title? title;

  SdInsiderTradeRes({
    this.insiderData,
    this.congressionalData,
    this.top,
    this.title,
    required this.faq,
  });

  factory SdInsiderTradeRes.fromJson(Map<String, dynamic> json) =>
      SdInsiderTradeRes(
        title: json["title"] == null ? null : Title.fromJson(json["title"]),
        insiderData: json["insider_data"] == null
            ? null
            : List<InsiderDatum>.from(
                json["insider_data"].map((x) => InsiderDatum.fromJson(x))),
        congressionalData: json["congressional_data"] == null
            ? null
            : List<CongressionalDatum>.from(json["congressional_data"]
                .map((x) => CongressionalDatum.fromJson(x))),
        top: json["top"] == null
            ? null
            : List<SdTopRes>.from(json["top"].map((x) => SdTopRes.fromJson(x))),
        faq: List<FaQsRes>.from(json["faq"].map((x) => FaQsRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title?.toJson(),
        "insider_data": insiderData == null
            ? null
            : List<dynamic>.from(insiderData!.map((x) => x.toJson())),
        "congressional_data": congressionalData == null
            ? null
            : List<dynamic>.from(congressionalData!.map((x) => x.toJson())),
        "top": top == null
            ? null
            : List<dynamic>.from(top!.map((x) => x.toJson())),
        "faq": List<dynamic>.from(faq.map((x) => x.toJson())),
      };
}

class Title {
  final String? insiderTrade;
  final String? congressTrade;
  final String? faq;

  Title({
    this.insiderTrade,
    this.congressTrade,
    this.faq,
  });

  factory Title.fromJson(Map<String, dynamic> json) => Title(
        insiderTrade: json["insider_trade"],
        congressTrade: json["congress_trade"],
        faq: json["faq"],
      );

  Map<String, dynamic> toJson() => {
        "insider_trade": insiderTrade,
        "congress_trade": congressTrade,
        "faq": faq,
      };
}

class CongressionalDatum {
  final String? name;
  final String? price;
  final String? type;
  final String? dateFiled;
  final String? dateTraded;
  final dynamic amount;

  CongressionalDatum({
    this.name,
    this.price,
    this.type,
    this.dateFiled,
    this.dateTraded,
    this.amount,
  });

  factory CongressionalDatum.fromJson(Map<String, dynamic> json) =>
      CongressionalDatum(
        name: json["name"],
        price: json["price"],
        type: json["type"],
        dateFiled: json["dateFiled"],
        dateTraded: json["dateTraded"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "type": type,
        "dateFiled": dateFiled,
        "dateTraded": dateTraded,
        "amount": amount,
      };
}

class InsiderDatum {
  final String? name;
  final String? companySlug;
  final String? reportingSlug;
  final String? designation;
  final String? transactionType;
  final String? shares;
  final String? price;
  final String? totalTxn;
  final String? shareAfterTxn;
  final String? transactionDate;
  final String? filingDate;
  final String? detail;
  final String? companyName;
  final String? reportingName;

  InsiderDatum({
    this.name,
    this.companySlug,
    this.reportingSlug,
    this.designation,
    this.transactionType,
    this.shares,
    this.price,
    this.totalTxn,
    this.shareAfterTxn,
    this.transactionDate,
    this.filingDate,
    this.detail,
    this.companyName,
    this.reportingName,
  });

  factory InsiderDatum.fromJson(Map<String, dynamic> json) => InsiderDatum(
      name: json["name"],
      companySlug: json["companySlug"],
      reportingSlug: json["reportingSlug"],
      designation: json["designation"],
      transactionType: json["transactionType"],
      shares: json["shares"],
      price: json["price"],
      totalTxn: json["total_txn"],
      shareAfterTxn: json["share_after_txn"],
      transactionDate: json["transactionDate"],
      filingDate: json["filingDate"],
      detail: json["detail"],
      companyName: json["companyName"],
      reportingName: json["reportingName"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "companySlug": companySlug,
        "reportingSlug": reportingSlug,
        "designation": designation,
        "transactionType": transactionType,
        "shares": shares,
        "price": price,
        "total_txn": totalTxn,
        "share_after_txn": shareAfterTxn,
        "transactionDate": transactionDate,
        "filingDate": filingDate,
        "detail": detail,
        "companyName": companyName,
        "reportingName": reportingName
      };
}

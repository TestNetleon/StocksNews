import 'dart:convert';

import 'package:stocks_news_new/modals/faqs_res.dart';
import 'package:stocks_news_new/modals/stockDetailRes/earnings.dart';

SdOwnershipRes sdOwnershipResFromJson(String str) =>
    SdOwnershipRes.fromJson(json.decode(str));

String sdOwnershipResToJson(SdOwnershipRes data) => json.encode(data.toJson());

class SdOwnershipRes {
  final List<SdTopRes>? top;
  final List<OwnershipList>? ownershipList;
  final List<FaQsRes>? faq;

  SdOwnershipRes({
    required this.top,
    required this.ownershipList,
    required this.faq,
  });

  factory SdOwnershipRes.fromJson(Map<String, dynamic> json) => SdOwnershipRes(
        top: json["top"] == null
            ? null
            : List<SdTopRes>.from(json["top"].map((x) => SdTopRes.fromJson(x))),
        ownershipList: json["ownership_list"] == null
            ? null
            : List<OwnershipList>.from(
                json["ownership_list"].map((x) => OwnershipList.fromJson(x))),
        faq: json["faq"] == null
            ? null
            : List<FaQsRes>.from(json["faq"].map((x) => FaQsRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "top": top == null
            ? null
            : List<dynamic>.from(top!.map((x) => x.toJson())),
        "ownership_list": ownershipList == null
            ? null
            : List<dynamic>.from(ownershipList!.map((x) => x.toJson())),
        "faq": faq == null
            ? null
            : List<dynamic>.from(faq!.map((x) => x.toJson())),
      };
}

class OwnershipList {
  final dynamic reprtingDate;
  final dynamic investorName;
  final dynamic sharesNumber;
  final dynamic marketValue;
  final dynamic changePercent;
  final dynamic ownership;

  OwnershipList({
    required this.reprtingDate,
    required this.investorName,
    required this.sharesNumber,
    required this.marketValue,
    required this.changePercent,
    required this.ownership,
  });

  factory OwnershipList.fromJson(Map<String, dynamic> json) => OwnershipList(
        reprtingDate: json["reprting_date"],
        investorName: json["investorName"],
        sharesNumber: json["sharesNumber"],
        marketValue: json["marketValue"],
        changePercent: json["change_percent"],
        ownership: json["ownership"],
      );

  Map<String, dynamic> toJson() => {
        "reprting_date": reprtingDate,
        "investorName": investorName,
        "sharesNumber": sharesNumber,
        "marketValue": marketValue,
        "change_percent": changePercent,
        "ownership": ownership,
      };
}

import 'dart:convert';

import 'package:stocks_news_new/models/faq.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';

SDOwnershipRes SDOwnershipResFromJson(String str) =>
    SDOwnershipRes.fromJson(json.decode(str));

String SDOwnershipResToJson(SDOwnershipRes data) => json.encode(data.toJson());

class SDOwnershipRes {
  final String? title;
  final String? subTitle;
  final List<BaseKeyValueRes>? top;
  final OwnershipListRes? ownershipList;
  final BaseFaqRes? faq;

  SDOwnershipRes({
    this.title,
    this.subTitle,
    this.top,
    this.ownershipList,
    this.faq,
  });

  factory SDOwnershipRes.fromJson(Map<String, dynamic> json) => SDOwnershipRes(
        title: json["title"],
        subTitle: json["sub_title"],
        top: json["top"] == null
            ? []
            : List<BaseKeyValueRes>.from(
                json["top"]!.map((x) => BaseKeyValueRes.fromJson(x))),
        ownershipList: json["ownership_list"] == null
            ? null
            : OwnershipListRes.fromJson(json["ownership_list"]),
        faq: json["faq"] == null ? null : BaseFaqRes.fromJson(json["faq"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "top":
            top == null ? [] : List<dynamic>.from(top!.map((x) => x.toJson())),
        "ownership_list": ownershipList?.toJson(),
        "faq": faq?.toJson(),
      };
}

class OwnershipListRes {
  final String? title;
  final String? subTitle;
  final List<OwnershipDataRes>? data;

  OwnershipListRes({
    this.title,
    this.subTitle,
    this.data,
  });

  factory OwnershipListRes.fromJson(Map<String, dynamic> json) =>
      OwnershipListRes(
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<OwnershipDataRes>.from(
                json["data"]!.map((x) => OwnershipDataRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class OwnershipDataRes {
  final String? reportingDate;
  final String? investorName;
  final String? sharesNumber;
  final String? marketValue;
  final num? changePercent;
  final String? ownership;

  OwnershipDataRes({
    this.reportingDate,
    this.investorName,
    this.sharesNumber,
    this.marketValue,
    this.changePercent,
    this.ownership,
  });

  factory OwnershipDataRes.fromJson(Map<String, dynamic> json) =>
      OwnershipDataRes(
        reportingDate: json["reporting_date"],
        investorName: json["investorName"],
        sharesNumber: json["sharesNumber"],
        marketValue: json["marketValue"],
        changePercent: json["change_percent"],
        ownership: json["ownership"],
      );

  Map<String, dynamic> toJson() => {
        "reporting_date": reportingDate,
        "investorName": investorName,
        "sharesNumber": sharesNumber,
        "marketValue": marketValue,
        "change_percent": changePercent,
        "ownership": ownership,
      };
}

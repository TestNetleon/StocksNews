// To parse this JSON data, do
//
//     final SDMergersRes = SDMergersResFromJson(jsonString);

import 'dart:convert';

SDMergersRes SDMergersResFromJson(String str) =>
    SDMergersRes.fromJson(json.decode(str));

String SDMergersResToJson(SDMergersRes data) => json.encode(data.toJson());

class SDMergersRes {
  final String? title;
  final String? subTitle;
  final List<MergersDataRes>? mergersList;

  SDMergersRes({
    this.title,
    this.subTitle,
    this.mergersList,
  });

  factory SDMergersRes.fromJson(Map<String, dynamic> json) => SDMergersRes(
        title: json["title"],
        subTitle: json["sub_title"],
        mergersList: json["mergers_list"] == null
            ? []
            : List<MergersDataRes>.from(
                json["mergers_list"]!.map((x) => MergersDataRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "mergers_list": mergersList == null
            ? []
            : List<dynamic>.from(mergersList!.map((x) => x.toJson())),
      };
}

class MergersDataRes {
  final String? targetedCompanyName;
  final String? symbol;
  final String? transactionDate;
  final String? acceptanceTime;
  final String? link;

  MergersDataRes({
    this.targetedCompanyName,
    this.symbol,
    this.transactionDate,
    this.acceptanceTime,
    this.link,
  });

  factory MergersDataRes.fromJson(Map<String, dynamic> json) => MergersDataRes(
        targetedCompanyName: json["targetedCompanyName"],
        symbol: json["symbol"],
        transactionDate: json["transactionDate"],
        acceptanceTime: json["acceptanceTime"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "targetedCompanyName": targetedCompanyName,
        "symbol": symbol,
        "transactionDate": transactionDate,
        "acceptanceTime": acceptanceTime,
        "link": link,
      };
}

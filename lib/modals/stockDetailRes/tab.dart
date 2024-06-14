// To parse this JSON data, do
//
//     final stockDetailTabRes = stockDetailTabResFromJson(jsonString);

import 'dart:convert';

import '../stock_details_res.dart';

StockDetailTabRes stockDetailTabResFromJson(String str) =>
    StockDetailTabRes.fromJson(json.decode(str));

String stockDetailTabResToJson(StockDetailTabRes data) =>
    json.encode(data.toJson());

class StockDetailTabRes {
  final KeyStats? keyStats;
  final List<DetailTab>? tabs;
  final CompanyInfo? companyInfo;
  String? shareUrl;
  int? isAlertAdded;
  int? isWatchListAdded;

  StockDetailTabRes({
    this.keyStats,
    this.tabs,
    this.companyInfo,
    this.isAlertAdded,
    this.shareUrl,
    this.isWatchListAdded,
  });

  factory StockDetailTabRes.fromJson(Map<String, dynamic> json) =>
      StockDetailTabRes(
        keyStats: json["key_stats"] == null
            ? null
            : KeyStats.fromJson(json["key_stats"]),
        shareUrl: json["share_url"],
        companyInfo: json["company_info"] == null
            ? null
            : CompanyInfo.fromJson(json["company_info"]),
        tabs: json["tabs"] == null
            ? []
            : List<DetailTab>.from(
                json["tabs"]!.map((x) => DetailTab.fromJson(x))),
        isAlertAdded: json["is_alert_added"],
        isWatchListAdded: json["is_watchlist_added"],
      );

  Map<String, dynamic> toJson() => {
        "key_stats": keyStats?.toJson(),
        "company_info": companyInfo?.toJson(),
        "tabs": tabs == null
            ? []
            : List<dynamic>.from(tabs!.map((x) => x.toJson())),
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchListAdded,
      };
}

class DetailTab {
  final String? name;

  DetailTab({
    this.name,
  });

  factory DetailTab.fromJson(Map<String, dynamic> json) => DetailTab(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

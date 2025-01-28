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
  final bool? showAnalysis;
  String? marketType;
  String? marketTime;
  final ExtendedHoursDataRes? extendedHoursData;
  final bool? showExtendedHoursData;

  StockDetailTabRes({
    this.keyStats,
    this.tabs,
    this.companyInfo,
    this.showAnalysis,
    this.isAlertAdded,
    this.shareUrl,
    this.isWatchListAdded,
    this.marketType,
    this.marketTime,
    this.extendedHoursData,
    this.showExtendedHoursData
  });

  factory StockDetailTabRes.fromJson(Map<String, dynamic> json) =>
      StockDetailTabRes(
        keyStats: json["key_stats"] == null
            ? null
            : KeyStats.fromJson(json["key_stats"]),
        shareUrl: json["share_url"],
        showAnalysis: json['show_analysis'],
        companyInfo: json["company_info"] == null
            ? null
            : CompanyInfo.fromJson(json["company_info"]),
        tabs: json["tabs"] == null
            ? []
            : List<DetailTab>.from(
                json["tabs"]!.map((x) => DetailTab.fromJson(x))),
        isAlertAdded: json["is_alert_added"],
        isWatchListAdded: json["is_watchlist_added"],
        extendedHoursData: json["ExtendedHoursData"] == null ? null : ExtendedHoursDataRes.fromMap(json["ExtendedHoursData"]),
        showExtendedHoursData: json["showExtendedHoursData"],

      );

  Map<String, dynamic> toJson() => {
        "key_stats": keyStats?.toJson(),
        "company_info": companyInfo?.toJson(),
        'show_analysis': showAnalysis,
        "tabs": tabs == null
            ? []
            : List<dynamic>.from(tabs!.map((x) => x.toJson())),
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchListAdded,
        "showExtendedHoursData": showExtendedHoursData,
    "ExtendedHoursData": extendedHoursData?.toMap(),

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

class ExtendedHoursDataRes {
  final bool? isHoliday;
  final bool? isMarketOpen;
  String? extendedHoursType;
  String? extendedHoursTime;
  final String? extendedHoursDate;
  final bool? checkPostMarket;
  final bool? checkPreMarket;
  final String? dateTime;
  num? extendedHoursPrice;
  num? extendedHoursChange;
  num? last;
  num? change;
  num? percentChange;
  num? extendedHoursPercentChange;

  ExtendedHoursDataRes({
    this.isHoliday,
    this.isMarketOpen,
    this.extendedHoursType,
    this.extendedHoursTime,
    this.extendedHoursDate,
    this.checkPostMarket,
    this.checkPreMarket,
    this.dateTime,
    this.extendedHoursPrice,
    this.extendedHoursChange,
    this.extendedHoursPercentChange,
    this.last,
    this.change,
    this.percentChange,
  });

  factory ExtendedHoursDataRes.fromMap(Map<String, dynamic> json) => ExtendedHoursDataRes(
    isHoliday: json["isHoliday"],
    isMarketOpen: json["isMarketOpen"],
    extendedHoursType: json["ExtendedHoursType"],
    extendedHoursTime: json["ExtendedHoursTime"],
    extendedHoursDate: json["ExtendedHoursDate"],
    checkPostMarket: json["checkPostMarket"],
    checkPreMarket: json["checkPreMarket"],
    dateTime: json["dateTime"],
    extendedHoursPrice: json["ExtendedHoursPrice"],
    extendedHoursChange: json["ExtendedHoursChange"],
    extendedHoursPercentChange: json["ExtendedHoursPercentChange"],
    last: json["Last"],
    change: json["Change"],
    percentChange: json["PercentChange"],
  );

  Map<String, dynamic> toMap() => {
    "isHoliday": isHoliday,
    "isMarketOpen": isMarketOpen,
    "ExtendedHoursType": extendedHoursType,
    "ExtendedHoursTime": extendedHoursTime,
    "ExtendedHoursDate": extendedHoursDate,
    "checkPostMarket": checkPostMarket,
    "checkPreMarket": checkPreMarket,
    "dateTime": dateTime,
    "ExtendedHoursPrice": extendedHoursPrice,
    "ExtendedHoursChange": extendedHoursChange,
    "ExtendedHoursPercentChange": extendedHoursPercentChange,
    "Last": last,
    "Change": change,
    "PercentChange": percentChange,
  };
}

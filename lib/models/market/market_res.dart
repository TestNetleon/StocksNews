import 'dart:convert';

import 'package:stocks_news_new/models/stockDetail/overview.dart';

MarketRes marketResFromJson(String str) => MarketRes.fromJson(json.decode(str));

String marketResToJson(MarketRes data) => json.encode(data.toJson());

class MarketRes {
  final List<MarketResData>? data;
  final MarketFilter? filter;

  MarketRes({
    required this.data,
    required this.filter,
  });

  factory MarketRes.fromJson(Map<String, dynamic> json) => MarketRes(
        data: json["data"] == null
            ? null
            : List<MarketResData>.from(
                json["data"].map((x) => MarketResData.fromJson(x)),
              ),
        filter: MarketFilter.fromJson(json["filter"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "filter": filter?.toJson(),
      };
}

class MarketResData {
  final String? icon;
  final String? slug;
  final String? title;
  final List<MarketResData>? data;
  final List<dynamic>? filter;
  final dynamic applyFilter;

  MarketResData({
    this.icon,
    this.slug,
    this.title,
    this.data,
    this.filter,
    this.applyFilter,
  });

  factory MarketResData.fromJson(Map<String, dynamic> json) => MarketResData(
        icon: json["icon"],
        slug: json["slug"],
        title: json["title"],
        data: json["data"] == null
            ? null
            : List<MarketResData>.from(
                json["data"].map((x) => MarketResData.fromJson(x)),
              ),
        filter: json["filter"] == null
            ? null
            : List<dynamic>.from(json["filter"].map((x) => x)),
        applyFilter: json["apply_filter"],
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "slug": slug,
        "title": title,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "filter":
            filter == null ? null : List<dynamic>.from(filter!.map((x) => x)),
        "apply_filter": applyFilter,
      };
}

class MarketFilter {
  final List<BaseKeyValueRes>? sorting;
  final List<BaseKeyValueRes>? exchange;
  final List<BaseKeyValueRes>? sectors;
  final List<BaseKeyValueRes>? industries;
  final List<BaseKeyValueRes>? marketCap;
  final List<BaseKeyValueRes>? marketRank;
  final List<BaseKeyValueRes>? analystConsensus;

  MarketFilter({
    required this.sorting,
    required this.exchange,
    required this.sectors,
    required this.industries,
    required this.marketCap,
    required this.marketRank,
    required this.analystConsensus,
  });

  factory MarketFilter.fromJson(Map<String, dynamic> json) => MarketFilter(
        sorting: json["sorting"] == null
            ? null
            : List<BaseKeyValueRes>.from(
                json["sorting"].map((x) => BaseKeyValueRes.fromJson(x))),
        exchange: json["exchange_name"] == null
            ? null
            : List<BaseKeyValueRes>.from(
                json["exchange_name"].map((x) => BaseKeyValueRes.fromJson(x))),
        sectors: json["sector"] == null
            ? null
            : List<BaseKeyValueRes>.from(
                json["sector"].map((x) => BaseKeyValueRes.fromJson(x))),
        industries: json["industry"] == null
            ? null
            : List<BaseKeyValueRes>.from(
                json["industry"].map((x) => BaseKeyValueRes.fromJson(x))),
        marketCap: json["market_cap"] == null
            ? null
            : List<BaseKeyValueRes>.from(
                json["market_cap"].map((x) => BaseKeyValueRes.fromJson(x))),
        marketRank: json["marketRank"] == null
            ? null
            : List<BaseKeyValueRes>.from(
                json["marketRank"].map((x) => BaseKeyValueRes.fromJson(x))),
        analystConsensus: json["analystConsensus"] == null
            ? null
            : List<BaseKeyValueRes>.from(json["analystConsensus"]
                .map((x) => BaseKeyValueRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sorting": sorting == null
            ? null
            : List<dynamic>.from(sorting!.map((x) => x.toJson())),
        "exchange_name": exchange == null
            ? null
            : List<dynamic>.from(exchange!.map((x) => x.toJson())),
        "sector": sectors == null
            ? null
            : List<dynamic>.from(sectors!.map((x) => x.toJson())),
        "industry": industries == null
            ? null
            : List<dynamic>.from(industries!.map((x) => x.toJson())),
        "market_cap": marketCap == null
            ? null
            : List<dynamic>.from(marketCap!.map((x) => x.toJson())),
        "marketRank": marketRank == null
            ? null
            : List<dynamic>.from(marketRank!.map((x) => x.toJson())),
        "analystConsensus": analystConsensus == null
            ? null
            : List<dynamic>.from(analystConsensus!.map((x) => x.toJson())),
      };

  MarketFilter clone() {
    return MarketFilter.fromJson(json.decode(json.encode(this)));
  }
}

class MarketFilterParams {
  String? sorting;
  List<String>? exchange;
  List<String>? sectors;
  List<String>? industries;
  String? marketCap;
  List<String>? marketRank;
  List<String>? analystConsensus;

  MarketFilterParams({
    this.sorting,
    this.exchange,
    this.sectors,
    this.industries,
    this.marketCap,
    this.marketRank,
    this.analystConsensus,
  });
}

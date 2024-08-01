import 'dart:convert';

import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/modals/news_datail_res.dart';

TrendingRes trendingResFromJson(String str) =>
    TrendingRes.fromJson(json.decode(str));

String trendingResToJson(TrendingRes data) => json.encode(data.toJson());

class TrendingRes {
  final List<MostBullishData>? mostBullish;
  final List<MostBullishData>? mostBearish;
  final List<GeneralNew>? generalNews;
  final List<Sector>? sectors;
  final List<SectorsPerformance>? sectorsPerformance;
  final String? trendingSymbolList;
  final TextRes? text;

  TrendingRes({
    required this.mostBullish,
    required this.mostBearish,
    required this.generalNews,
    required this.sectors,
    required this.sectorsPerformance,
    this.trendingSymbolList,
    this.text,
  });

  factory TrendingRes.fromJson(Map<String, dynamic> json) => TrendingRes(
        mostBullish: json["most_bullish"] == null
            ? null
            : List<MostBullishData>.from(
                json["most_bullish"].map((x) => MostBullishData.fromJson(x))),
        mostBearish: json["most_bearish"] == null
            ? null
            : List<MostBullishData>.from(
                json["most_bearish"].map((x) => MostBullishData.fromJson(x))),
        generalNews: json["general_news"] == null
            ? null
            : List<GeneralNew>.from(
                json["general_news"].map((x) => GeneralNew.fromJson(x))),
        sectors: json["sectors"] == null
            ? null
            : List<Sector>.from(json["sectors"].map((x) => Sector.fromJson(x))),
        sectorsPerformance: json["sectorsPerformance"] == null
            ? null
            : List<SectorsPerformance>.from(json["sectorsPerformance"]
                .map((x) => SectorsPerformance.fromJson(x))),
        trendingSymbolList: json["symbols_list"],
        text: json["text"] == null ? null : TextRes.fromJson(json["text"]),
      );

  Map<String, dynamic> toJson() => {
        "most_bullish": mostBullish == null
            ? null
            : List<dynamic>.from(mostBullish!.map((x) => x.toJson())),
        "most_bearish": mostBearish == null
            ? null
            : List<dynamic>.from(mostBearish!.map((x) => x.toJson())),
        "general_news": generalNews == null
            ? null
            : List<dynamic>.from(generalNews!.map((x) => x.toJson())),
        "sectors": sectors == null
            ? null
            : List<dynamic>.from(sectors!.map((x) => x.toJson())),
        "sectorsPerformance": sectorsPerformance == null
            ? null
            : List<dynamic>.from(sectorsPerformance!.map((x) => x.toJson())),
        "symbols_list": trendingSymbolList,
        "text": text?.toJson(),
      };
}

class GeneralNew {
  final DateTime? publishedDate;
  final String? title;
  final String? slug;
  final String? image;
  final String? site;
  final String? text;
  final String? url;
  final List<DetailListType>? authors;

  GeneralNew({
    this.slug,
    this.publishedDate,
    this.title,
    this.image,
    this.site,
    this.text,
    this.url,
    this.authors,
  });

  factory GeneralNew.fromJson(Map<String, dynamic> json) => GeneralNew(
        publishedDate: DateTime.parse(json["publishedDate"]),
        title: json["title"],
        image: json["image"],
        site: json["site"],
        slug: json['slug'],
        text: json["text"],
        url: json["url"],
        authors: json["authors"] == null
            ? []
            : List<DetailListType>.from(
                json["authors"]!.map((x) => DetailListType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "publishedDate": publishedDate?.toIso8601String(),
        "title": title,
        "image": image,
        "slug": slug,
        "site": site,
        "text": text,
        "url": url,
        "authors": authors == null
            ? []
            : List<dynamic>.from(authors!.map((x) => x.toJson())),
      };
}

class MostBullishData {
  final String symbol;
  // final DateTime publishedDate;
  final String? image;
  final String? price;
  final String? name;
  final num changes;
  final num? mention;
  final num mentionChange;
  final String? displayChange;
  final num changesPercentage;
  int isAlertAdded;
  int isWatchlistAdded;
  // final dynamic sites;

  MostBullishData({
    required this.symbol,
    this.name,
    // required this.publishedDate,
    this.image,
    this.price,
    this.displayChange,
    required this.changesPercentage,
    required this.changes,
    this.mention,
    required this.mentionChange,
    required this.isAlertAdded,
    required this.isWatchlistAdded,
    // required this.sites,
  });

  factory MostBullishData.fromJson(Map<String, dynamic> json) =>
      MostBullishData(
        symbol: json["symbol"],
        name: json["name"],
        // publishedDate: DateTime.parse(json["published_date"]),
        image: json["image"],
        displayChange: json["display_change"],
        changesPercentage: json["changesPercentage"],
        price: json["price"],
        changes: json["changes"],
        mention: json["mention"],
        mentionChange: json["mention_change"],
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],

        // sites: json["sites"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        // "published_date":
        //     "${publishedDate.year.toString().padLeft(4, '0')}-${publishedDate.month.toString().padLeft(2, '0')}-${publishedDate.day.toString().padLeft(2, '0')}",
        "image": image,
        "price": price,
        "name": name,
        "changes": changes,
        "display_change": displayChange,
        "changesPercentage": changesPercentage,
        "mention": mention,
        "mention_change": mentionChange,
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
        // "sites": sites,
      };
}

class Sector {
  final String? sector;
  final String? sectorSlug;
  final String? mentionType;
  final num? totalMentions;
  final String? image;

  Sector({
    this.sector,
    this.mentionType,
    this.totalMentions,
    this.sectorSlug,
    this.image,
  });

  factory Sector.fromJson(Map<String, dynamic> json) => Sector(
        sector: json["sector"],
        mentionType: json["mention_type"],
        totalMentions: json["total_mentions"],
        sectorSlug: json["sector_slug"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "sector": sector,
        "mention_type": mentionType,
        "total_mentions": totalMentions,
        "sector_slug": sectorSlug,
        "image": image,
      };
}

class SectorsPerformance {
  final String? name;
  final String? color;
  final num? value;

  SectorsPerformance({
    this.name,
    this.color,
    this.value,
  });

  factory SectorsPerformance.fromJson(Map<String, dynamic> json) =>
      SectorsPerformance(
        name: json["name"],
        color: json["color"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "color": color,
        "value": value,
      };
}

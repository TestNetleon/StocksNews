import 'dart:convert';

import 'package:stocks_news_new/models/stockDetail/overview.dart';

SDChartRes SDChartResFromJson(String str) =>
    SDChartRes.fromJson(json.decode(str));

String SDChartResToJson(SDChartRes data) => json.encode(data.toJson());

class SDChartRes {
  final String? title;
  final String? subTitle;
  final List<BaseKeyValueRes>? top;
  final ChartPriceHistoryRes? priceHistory;

  SDChartRes({
    this.title,
    this.subTitle,
    this.top,
    this.priceHistory,
  });

  factory SDChartRes.fromJson(Map<String, dynamic> json) => SDChartRes(
        title: json["title"],
        subTitle: json["sub_title"],
        top: json["top"] == null
            ? []
            : List<BaseKeyValueRes>.from(
                json["top"]!.map((x) => BaseKeyValueRes.fromJson(x))),
        priceHistory: json["price_history"] == null
            ? null
            : ChartPriceHistoryRes.fromJson(json["price_history"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "top":
            top == null ? [] : List<dynamic>.from(top!.map((x) => x.toJson())),
        "price_history": priceHistory?.toJson(),
      };
}

class ChartPriceHistoryRes {
  final String? title;
  final String? subTitle;
  final List<PriceHistoryDataRes>? data;

  ChartPriceHistoryRes({
    this.title,
    this.subTitle,
    this.data,
  });

  factory ChartPriceHistoryRes.fromJson(Map<String, dynamic> json) =>
      ChartPriceHistoryRes(
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<PriceHistoryDataRes>.from(
                json["data"]!.map((x) => PriceHistoryDataRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class PriceHistoryDataRes {
  final String? date;
  final String? openingPrice;
  final String? closingPrice;
  final double? changePercent;
  final String? high;
  final String? low;
  final String? volume;
  final String? marketCapitalization;

  PriceHistoryDataRes({
    this.date,
    this.openingPrice,
    this.closingPrice,
    this.changePercent,
    this.high,
    this.low,
    this.volume,
    this.marketCapitalization,
  });

  factory PriceHistoryDataRes.fromJson(Map<String, dynamic> json) =>
      PriceHistoryDataRes(
        date: json["date"],
        openingPrice: json["opening_price"],
        closingPrice: json["closing_price"],
        changePercent: json["change_percent"]?.toDouble(),
        high: json["high"],
        low: json["low"],
        volume: json["volume"],
        marketCapitalization: json["market_capitalization"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "opening_price": openingPrice,
        "closing_price": closingPrice,
        "change_percent": changePercent,
        "high": high,
        "low": low,
        "volume": volume,
        "market_capitalization": marketCapitalization,
      };
}

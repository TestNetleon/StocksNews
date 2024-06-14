import 'dart:convert';

import 'package:stocks_news_new/modals/stockDetailRes/earnings.dart';

SdChartRes sdChartResFromJson(String str) =>
    SdChartRes.fromJson(json.decode(str));

String sdChartResToJson(SdChartRes data) => json.encode(data.toJson());

class SdChartRes {
  final List<SdTopRes>? top;
  final List<PriceHistory>? priceHistory;

  SdChartRes({
    this.top,
    this.priceHistory,
  });

  factory SdChartRes.fromJson(Map<String, dynamic> json) => SdChartRes(
        top: json["top"] == null
            ? []
            : List<SdTopRes>.from(
                json["top"]!.map((x) => SdTopRes.fromJson(x))),
        priceHistory: json["price_history"] == null
            ? []
            : List<PriceHistory>.from(
                json["price_history"]!.map((x) => PriceHistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "top":
            top == null ? [] : List<dynamic>.from(top!.map((x) => x.toJson())),
        "price_history": priceHistory == null
            ? []
            : List<dynamic>.from(priceHistory!.map((x) => x.toJson())),
      };
}

class PriceHistory {
  final String? date;
  final String? openingPrice;
  final String? closingPrice;
  final dynamic changePercent;
  final String? high;
  final String? low;
  final String? volume;
  final String? marketCapitalization;

  PriceHistory({
    this.date,
    this.openingPrice,
    this.closingPrice,
    this.changePercent,
    this.high,
    this.low,
    this.volume,
    this.marketCapitalization,
  });

  factory PriceHistory.fromJson(Map<String, dynamic> json) => PriceHistory(
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

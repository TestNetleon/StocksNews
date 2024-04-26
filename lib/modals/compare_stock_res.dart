// To parse this JSON data, do
//
//     final compareStockRes = compareStockResFromJson(jsonString);

import 'dart:convert';

List<CompareStockRes> compareStockResFromJson(String str) =>
    List<CompareStockRes>.from(
        json.decode(str).map((x) => CompareStockRes.fromJson(x)));

String compareStockResToJson(List<CompareStockRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CompareStockRes {
  final String symbol;
  final String name;
  final String image;
  final String price;
  final double changes;
  final double changesPercentage;
  final String dayLow;
  final String dayHigh;
  final String yearLow;
  final String yearHigh;
  final String mktCap;
  final String priceAvg50;
  final String priceAvg200;
  final String exchange;
  final String volume;
  final String avgVolume;
  final String open;
  final String previousClose;
  final double eps;
  final double pe;
  final String earningsAnnouncement;
  final String sharesOutstanding;
  final num fundamentalPercent;
  final num shortTermPercent;
  final num longTermPercent;
  final num valuationPercent;
  final num analystRankingPercent;
  final num overallPercent;
  final num setimentPercent;

  CompareStockRes({
    required this.symbol,
    required this.name,
    required this.image,
    required this.price,
    required this.changes,
    required this.changesPercentage,
    required this.dayLow,
    required this.dayHigh,
    required this.yearLow,
    required this.yearHigh,
    required this.mktCap,
    required this.priceAvg50,
    required this.priceAvg200,
    required this.exchange,
    required this.volume,
    required this.avgVolume,
    required this.open,
    required this.previousClose,
    required this.eps,
    required this.pe,
    required this.earningsAnnouncement,
    required this.sharesOutstanding,
    required this.analystRankingPercent,
    required this.fundamentalPercent,
    required this.longTermPercent,
    required this.overallPercent,
    required this.setimentPercent,
    required this.shortTermPercent,
    required this.valuationPercent,
  });

  factory CompareStockRes.fromJson(Map<String, dynamic> json) =>
      CompareStockRes(
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        changes: json["changes"]?.toDouble(),
        changesPercentage: json["changesPercentage"]?.toDouble(),
        dayLow: json["dayLow"],
        dayHigh: json["dayHigh"],
        yearLow: json["yearLow"],
        yearHigh: json["yearHigh"],
        mktCap: json["mktCap"],
        priceAvg50: json["priceAvg50"],
        priceAvg200: json["priceAvg200"],
        exchange: json["exchange"],
        volume: json["volume"],
        avgVolume: json["avgVolume"],
        open: json["open"],
        previousClose: json["previousClose"],
        eps: json["eps"]?.toDouble(),
        pe: json["pe"]?.toDouble(),
        earningsAnnouncement: json["earningsAnnouncement"],
        sharesOutstanding: json["sharesOutstanding"],
        overallPercent: json["overall_percent"],
        fundamentalPercent: json["fundamental_percent"],
        shortTermPercent: json["short_term_percent"],
        longTermPercent: json["long_term_percent"],
        valuationPercent: json["valuation_percent"],
        analystRankingPercent: json["analyst_ranking_percent"],
        setimentPercent: json["sentiment_percent"],
      );

  Map<String, dynamic> toJson() => {
        "overall_percent": overallPercent,
        "fundamental_percent": fundamentalPercent,
        "short_term_percent": shortTermPercent,
        "symbol": symbol,
        "name": name,
        "image": image,
        "price": price,
        "changes": changes,
        "changesPercentage": changesPercentage,
        "dayLow": dayLow,
        "dayHigh": dayHigh,
        "yearLow": yearLow,
        "yearHigh": yearHigh,
        "mktCap": mktCap,
        "priceAvg50": priceAvg50,
        "priceAvg200": priceAvg200,
        "exchange": exchange,
        "volume": volume,
        "avgVolume": avgVolume,
        "open": open,
        "previousClose": previousClose,
        "eps": eps,
        "pe": pe,
        "earningsAnnouncement": earningsAnnouncement,
        "sharesOutstanding": sharesOutstanding,
        "long_term_percent": longTermPercent,
        "valuation_percent": valuationPercent,
        "analyst_ranking_percent": analystRankingPercent,
        "sentiment_percent": setimentPercent,
      };
}

// To parse this JSON data, do
//
//     final earningsRes = earningsResFromJson(jsonString);

import 'dart:convert';

List<EarningsRes> earningsResFromJson(String str) => List<EarningsRes>.from(
    json.decode(str).map((x) => EarningsRes.fromJson(x)));

String earningsResToJson(List<EarningsRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EarningsRes {
  final dynamic symbol;
  final dynamic name;
  final dynamic exchangeShortName;
  final dynamic price;
  final dynamic eps;
  final dynamic epsEstimated;
  final dynamic revenue;
  final dynamic revenueEstimated;
  final dynamic date;
  final dynamic fiscalDateEnding;
  final dynamic updatedFromDate;
  final dynamic image;
  final dynamic percentageChange;
  final dynamic priceChange;
  num? isAlertAdded;
  num? isWatchlistAdded;

  EarningsRes({
    this.symbol,
    this.name,
    this.exchangeShortName,
    this.price,
    this.eps,
    this.epsEstimated,
    this.revenue,
    this.revenueEstimated,
    this.date,
    this.fiscalDateEnding,
    this.updatedFromDate,
    this.image,
    this.percentageChange,
    this.priceChange,
    this.isAlertAdded,
    this.isWatchlistAdded,
  });

  factory EarningsRes.fromJson(Map<String, dynamic> json) => EarningsRes(
        symbol: json["symbol"],
        name: json["name"],
        exchangeShortName: json["exchange_short_name"],
        price: json["price"],
        eps: json["eps"],
        epsEstimated: json["epsEstimated"],
        revenue: json["revenue"],
        revenueEstimated: json["revenueEstimated"],
        date: json["date"],
        fiscalDateEnding: json["fiscalDateEnding"],
        updatedFromDate: json["updatedFromDate"],
        image: json["image"],
        percentageChange: json["percentage_change"],
        priceChange: json["price_change"],
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "exchange_short_name": exchangeShortName,
        "price": price,
        "eps": eps,
        "epsEstimated": epsEstimated,
        "revenue": revenue,
        "revenueEstimated": revenueEstimated,
        "date": date,
        "fiscalDateEnding": fiscalDateEnding,
        "updatedFromDate": updatedFromDate,
        "image": image,
        "percentage_change": percentageChange,
        "price_change": priceChange,
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
      };
}

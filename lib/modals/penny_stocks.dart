// To parse this JSON data, do
//
//     final pennyStocksRes = pennyStocksResFromJson(jsonString);

import 'dart:convert';

List<PennyStocksRes> pennyStocksResFromJson(String str) =>
    List<PennyStocksRes>.from(
        json.decode(str).map((x) => PennyStocksRes.fromJson(x)));

String pennyStocksResToJson(List<PennyStocksRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PennyStocksRes {
  final dynamic symbol;
  final dynamic name;
  final dynamic exchange;
  final dynamic price;
  final dynamic change;
  final dynamic changesPercentage;
  final dynamic volume;
  final dynamic image;
  final dynamic avgVolume;
  final dynamic dollarVolume;
  final dynamic pe;
  final dynamic mktCap;
  final dynamic watchlistandalertlistCount;
  num? isAlertAdded;
  num? isWatchlistAdded;

  PennyStocksRes({
    this.symbol,
    this.name,
    this.exchange,
    this.price,
    this.change,
    this.changesPercentage,
    this.volume,
    this.image,
    this.avgVolume,
    this.dollarVolume,
    this.pe,
    this.mktCap,
    this.watchlistandalertlistCount,
    this.isAlertAdded,
    this.isWatchlistAdded,
  });

  factory PennyStocksRes.fromJson(Map<String, dynamic> json) => PennyStocksRes(
        symbol: json["symbol"],
        name: json["name"],
        exchange: json["exchange"],
        price: json["price"],
        image: json["image"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
        volume: json["volume"],
        avgVolume: json["avgVolume"],
        dollarVolume: json["dollarVolume"],
        pe: json["pe"],
        mktCap: json["mktCap"],
        watchlistandalertlistCount: json["watchlistandalertlistCount"],
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "image": image,
        "exchange": exchange,
        "price": price,
        "change": change,
        "changesPercentage": changesPercentage,
        "volume": volume,
        "avgVolume": avgVolume,
        "dollarVolume": dollarVolume,
        "pe": pe,
        "mktCap": mktCap,
        "watchlistandalertlistCount": watchlistandalertlistCount,
      };
}

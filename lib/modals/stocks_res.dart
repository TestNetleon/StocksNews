// To parse this JSON data, do
//
//     final stocksRes = stocksResFromJson(jsonString);

import 'dart:convert';

StocksRes stocksResFromJson(String str) => StocksRes.fromJson(json.decode(str));

String stocksResToJson(StocksRes data) => json.encode(data.toJson());

class StocksRes {
  // final int currentPage;
  final List<AllStocks>? data;
  final int lastPage;
//
  StocksRes({
    // required this.currentPage,
    this.data,
    required this.lastPage,
  });

  factory StocksRes.fromJson(Map<String, dynamic> json) => StocksRes(
        // currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<AllStocks>.from(
                json["data"]!.map((x) => AllStocks.fromJson(x))),
        lastPage: json["last_page"],
      );

  Map<String, dynamic> toJson() => {
        // "current_page": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "last_page": lastPage,
      };
}

class AllStocks {
  final String? id;
  final String symbol;
  final String? name;
  final String? exchangeShortName;
  final String? image;
  final num? change;
  final String? price;
  final num? changesPercentage;
  final String? dayHigh;
  final String? dayLow;
  final String? open;
  final String? previousClose;
  final String displayChange;
  num? isAlertAdded;
  num? isWatchlistAdded;

  AllStocks({
    this.id,
    required this.symbol,
    this.name,
    this.exchangeShortName,
    this.image,
    this.change,
    this.price,
    this.changesPercentage,
    required this.displayChange,
    this.dayHigh,
    this.dayLow,
    this.open,
    this.previousClose,
    this.isAlertAdded,
    this.isWatchlistAdded,
  });

  factory AllStocks.fromJson(Map<String, dynamic> json) => AllStocks(
        id: json["_id"],
        symbol: json["symbol"],
        name: json["name"],
        exchangeShortName: json["exchange_short_name"],
        image: json["image"],
        change: json["change"],
        displayChange: json["display_change"],
        price: json["price"],
        changesPercentage: json["changesPercentage"],
        dayHigh: json["dayHigh"],
        dayLow: json["dayLow"],
        open: json["open"],
        previousClose: json["previousClose"],
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "symbol": symbol,
        "name": name,
        "exchange_short_name": exchangeShortName,
        "image": image,
        "display_change": displayChange,
        "change": change,
        "price": price,
        "changesPercentage": changesPercentage,
        "dayHigh": dayHigh,
        "dayLow": dayLow,
        "open": open,
        "previousClose": previousClose,
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
      };
}

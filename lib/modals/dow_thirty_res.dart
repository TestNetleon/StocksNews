// To parse this JSON data, do
//
//     final dowThirtyRes = dowThirtyResFromJson(jsonString);

import 'dart:convert';

// DowThirtyRes dowThirtyResFromJson(String str) =>
//     DowThirtyRes.fromJson(json.decode(str));

// String dowThirtyResToJson(DowThirtyRes data) => json.encode(data.toJson());

List<Result> dowThirtyResFromJson(String str) =>
    List<Result>.from(json.decode(str).map((x) => Result.fromJson(x)));

String dowThirtyResToJson(List<Result> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Result {
  final dynamic symbol;
  final dynamic name;
  final dynamic exchangeShortName;
  final dynamic price;
  final dynamic change;
  final dynamic pe;
  final dynamic mktCap;
  final dynamic percentageChange;
  final dynamic volume;
  final dynamic avgVolume;
  final dynamic image;
  final dynamic priceChange;

  final dynamic sector;
  final dynamic exchangeValues;

  final dynamic consensusAnalystRating;
  final dynamic peRatio;
  final dynamic analystRatingConsensusPriceTarget;
  num? isAlertAdded;
  num? isWatchlistAdded;

  Result({
    this.symbol,
    this.name,
    this.exchangeShortName,
    this.price,
    this.change,
    this.pe,
    this.mktCap,
    this.percentageChange,
    this.volume,
    this.avgVolume,
    this.image,
    this.priceChange,
    this.sector,
    this.exchangeValues,
    this.consensusAnalystRating,
    this.peRatio,
    this.analystRatingConsensusPriceTarget,
    this.isAlertAdded,
    this.isWatchlistAdded,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        symbol: json["symbol"],
        name: json["name"],
        exchangeShortName: json["exchange_short_name"],
        price: json["price"],
        change: json["change"],
        pe: json["pe"],
        mktCap: json["mktCap"],
        percentageChange: json["percentage_change"],
        volume: json["volume"],
        avgVolume: json["avgVolume"],
        image: json["image"],
        priceChange: json["price_change"],
        sector: json["sector"],
        exchangeValues: json["exchange"],
        consensusAnalystRating: json["consensus_analyst_rating"],
        peRatio: json["pe_ratio"],
        analystRatingConsensusPriceTarget:
            json["analyst_rating_consensus_price_target"],
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "exchange_short_name": exchangeShortName,
        "price": price,
        "change": change,
        "pe": pe,
        "mktCap": mktCap,
        "percentage_change": percentageChange,
        "volume": volume,
        "avgVolume": avgVolume,
        "image": image,
        "price_change": priceChange,
        "sector": sector,
        "exchange": exchangeValues,
        "consensus_analyst_rating": consensusAnalystRating,
        "pe_ratio": peRatio,
        "analyst_rating_consensus_price_target":
            analystRatingConsensusPriceTarget,
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
      };
}

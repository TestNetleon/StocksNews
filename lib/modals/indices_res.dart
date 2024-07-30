// To parse this JSON data, do
//
//     final indicesRes = indicesResFromJson(jsonString);

import 'dart:convert';

List<IndicesRes> indicesResFromJson(String str) =>
    List<IndicesRes>.from(json.decode(str).map((x) => IndicesRes.fromJson(x)));

String indicesResToJson(List<IndicesRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IndicesRes {
  final dynamic symbol;
  final dynamic name;
  final dynamic image;
  final dynamic price;
  final dynamic sector;
  final dynamic exchangeValues;
  final dynamic volume;
  final dynamic avgVolume;
  final dynamic priceChange;
  final dynamic percentageChange;
  final dynamic mktCap;
  final dynamic consensusAnalystRating;
  final dynamic peRatio;
  final dynamic analystRatingConsensusPriceTarget;
  num? isAlertAdded;
  num? isWatchlistAdded;

  IndicesRes({
    this.symbol,
    this.name,
    this.image,
    this.price,
    this.sector,
    this.exchangeValues,
    this.volume,
    this.avgVolume,
    this.priceChange,
    this.percentageChange,
    this.mktCap,
    this.consensusAnalystRating,
    this.peRatio,
    this.analystRatingConsensusPriceTarget,
    this.isAlertAdded,
    this.isWatchlistAdded,
  });

  factory IndicesRes.fromJson(Map<String, dynamic> json) => IndicesRes(
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        sector: json["sector"],
        exchangeValues: json["exchange"],
        volume: json["volume"],
        avgVolume: json["avgVolume"],
        priceChange: json["price_change"],
        percentageChange: json["percentage_change"],
        mktCap: json["mktCap"],
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
        "image": image,
        "price": price,
        "sector": sector,
        "exchange": exchangeValues,
        "volume": volume,
        "avgVolume": avgVolume,
        "price_change": priceChange,
        "percentage_change": percentageChange,
        "mktCap": mktCap,
        "consensus_analyst_rating": consensusAnalystRating,
        "pe_ratio": peRatio,
        "analyst_rating_consensus_price_target":
            analystRatingConsensusPriceTarget,
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
      };
}

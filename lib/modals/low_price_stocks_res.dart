// To parse this JSON data, do
//
//     final lowPriceStocksRes = lowPriceStocksResFromJson(jsonString);

import 'dart:convert';

List<LowPriceStocksRes> lowPriceStocksResFromJson(String str) =>
    List<LowPriceStocksRes>.from(
        json.decode(str).map((x) => LowPriceStocksRes.fromJson(x)));

String lowPriceStocksResToJson(List<LowPriceStocksRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LowPriceStocksRes {
  final dynamic symbol;
  final dynamic name;

  final dynamic description;
  final dynamic image;
  final dynamic price;
  final dynamic mktCap;

  final dynamic change;
  final dynamic changesPercentage;

  final dynamic avgVolume;

  final dynamic pe;
  final dynamic priceTarget;

  final dynamic consensusRating;

  final dynamic volume;

  final dynamic priceChange;
  final dynamic percentageChange;
  final dynamic the52WeekHigh;
  final dynamic discount52Weeks;

  LowPriceStocksRes({
    this.symbol,
    this.name,
    this.description,
    this.image,
    this.price,
    this.mktCap,
    this.change,
    this.changesPercentage,
    this.avgVolume,
    this.pe,
    this.priceTarget,
    this.consensusRating,
    this.volume,
    this.priceChange,
    this.percentageChange,
    this.the52WeekHigh,
    this.discount52Weeks,
  });

  factory LowPriceStocksRes.fromJson(Map<String, dynamic> json) =>
      LowPriceStocksRes(
        symbol: json["symbol"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        price: json["price"],
        mktCap: json["mktCap"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
        avgVolume: json["avgVolume"],
        pe: json["pe"],
        priceTarget: json["price_target"],
        consensusRating: json["Consensus_Rating"],
        volume: json["volume"],
        priceChange: json["price_change"],
        percentageChange: json["percentage_change"],
        the52WeekHigh: json["52WeekHigh"],
        discount52Weeks: json["discount52Weeks"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "description": description,
        "image": image,
        "price": price,
        "mktCap": mktCap,
        "change": change,
        "changesPercentage": changesPercentage,
        "avgVolume": avgVolume,
        "pe": pe,
        "price_target": priceTarget,
        "Consensus_Rating": consensusRating,
        "volume": volume,
        "price_change": priceChange,
        "percentage_change": percentageChange,
        "52WeekHigh": the52WeekHigh,
        "discount52Weeks": discount52Weeks,
      };
}

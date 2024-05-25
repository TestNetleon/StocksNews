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
  final String? symbol;
  final String? name;

  final String? description;
  final String? image;
  final String? price;
  final String? mktCap;

  final String? change;
  final num? changesPercentage;

  final String? avgVolume;

  final num? pe;
  final num? priceTarget;

  final String? consensusRating;

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
        consensusRating: json["consensus_rating"],
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
        "consensus_rating": consensusRating,
      };
}

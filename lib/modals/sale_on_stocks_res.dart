// To parse this JSON data, do
//
//     final saleOnStocks = saleOnStocksFromJson(jsonString);

import 'dart:convert';

List<SaleOnStocks> saleOnStocksFromJson(String str) => List<SaleOnStocks>.from(
    json.decode(str).map((x) => SaleOnStocks.fromJson(x)));

String saleOnStocksToJson(List<SaleOnStocks> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SaleOnStocks {
  final dynamic symbol;
  final dynamic name;
  final dynamic image;
  final dynamic price;
  final dynamic volume;
  final dynamic avgVolume;
  final dynamic priceChange;
  final dynamic percentageChange;
  final dynamic the52WeekHigh;
  final dynamic discount52Weeks;
  final dynamic consensusRating;
  final dynamic priceTarget;

  SaleOnStocks({
    this.symbol,
    this.name,
    this.image,
    this.price,
    this.volume,
    this.avgVolume,
    this.priceChange,
    this.percentageChange,
    this.the52WeekHigh,
    this.discount52Weeks,
    this.consensusRating,
    this.priceTarget,
  });

  factory SaleOnStocks.fromJson(Map<String, dynamic> json) => SaleOnStocks(
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        price: priceValues.map[json["price"]]!,
        volume: json["volume"],
        avgVolume: json["avgVolume"],
        priceChange: json["price_change"]?.toDouble(),
        percentageChange: json["percentage_change"]?.toDouble(),
        the52WeekHigh: json["52WeekHigh"]?.toDouble(),
        discount52Weeks: json["discount52Weeks"],
        consensusRating: json["consensusRating"],
        priceTarget: json["priceTarget"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "image": image,
        "price": priceValues.reverse[price],
        "volume": volume,
        "avgVolume": avgVolume,
        "price_change": priceChange,
        "percentage_change": percentageChange,
        "52WeekHigh": the52WeekHigh,
        "discount52Weeks": discount52Weeks,
        "consensusRating": consensusRating,
        "priceTarget": priceTarget,
      };
}

enum Price { THE_0 }

final priceValues = EnumValues({"\u00240": Price.THE_0});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

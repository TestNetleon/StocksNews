// To parse this JSON data, do
//
//     final hIghLowPeRes = hIghLowPeResFromJson(jsonString);

import 'dart:convert';

List<HIghLowPeRes> hIghLowPeResFromJson(String str) => List<HIghLowPeRes>.from(
    json.decode(str).map((x) => HIghLowPeRes.fromJson(x)));

String hIghLowPeResToJson(List<HIghLowPeRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HIghLowPeRes {
  final String? symbol;
  final String? name;
  final String? price;
  final Change? change;
  final double? pe;
  final String? marketCap;
  final String? volume;
  final String? avgVolume;
  final String? image;

  HIghLowPeRes({
    this.symbol,
    this.name,
    this.price,
    this.change,
    this.pe,
    this.marketCap,
    this.volume,
    this.avgVolume,
    this.image,
  });

  factory HIghLowPeRes.fromJson(Map<String, dynamic> json) => HIghLowPeRes(
        symbol: json["symbol"],
        name: json["name"],
        price: json["price"],
        change: json["change"] == null ? null : Change.fromJson(json["change"]),
        pe: json["pe"]?.toDouble(),
        marketCap: json["marketCap"],
        volume: json["volume"],
        avgVolume: json["avgVolume"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "price": price,
        "change": change?.toJson(),
        "pe": pe,
        "marketCap": marketCap,
        "volume": volume,
        "avgVolume": avgVolume,
        "image": image,
      };
}

class Change {
  final String? value;
  final String? percentage;
  final String? direction;

  Change({
    this.value,
    this.percentage,
    this.direction,
  });

  factory Change.fromJson(Map<String, dynamic> json) => Change(
        value: json["value"],
        percentage: json["percentage"],
        direction: json["direction"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "percentage": percentage,
        "direction": direction,
      };
}

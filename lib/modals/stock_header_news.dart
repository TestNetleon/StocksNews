// To parse this JSON data, do
//
//     final stockHeaderNewsRes = stockHeaderNewsResFromJson(jsonString);

import 'dart:convert';

List<StockHeaderNewsRes> stockHeaderNewsResFromJson(String str) =>
    List<StockHeaderNewsRes>.from(
        json.decode(str).map((x) => StockHeaderNewsRes.fromJson(x)));
//
String stockHeaderNewsResToJson(List<StockHeaderNewsRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StockHeaderNewsRes {
  final String name;
  final double price;
  final double changesPercentage;
  final String arrow;
  final String arrowClass;

  StockHeaderNewsRes({
    required this.name,
    required this.price,
    required this.changesPercentage,
    required this.arrow,
    required this.arrowClass,
  });

  factory StockHeaderNewsRes.fromJson(Map<String, dynamic> json) =>
      StockHeaderNewsRes(
        name: json["name"],
        price: json["price"]?.toDouble(),
        changesPercentage: json["changesPercentage"]?.toDouble(),
        arrow: json["arrow"],
        arrowClass: json["arrow_class"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "changesPercentage": changesPercentage,
        "arrow": arrow,
        "arrow_class": arrowClass,
      };
}

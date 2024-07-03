import 'dart:convert';

List<MostPurchasedRes> mostPurchasedResFromJson(String str) =>
    List<MostPurchasedRes>.from(
        json.decode(str).map((x) => MostPurchasedRes.fromJson(x)));

String mostPurchasedResToJson(List<MostPurchasedRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MostPurchasedRes {
  final String? symbol;
  final String? name;
  final String? image;
  final String? price;
  final String? change;
  final num? changesPercentage;

  MostPurchasedRes({
    this.symbol,
    this.name,
    this.image,
    this.price,
    this.change,
    this.changesPercentage,
  });

  factory MostPurchasedRes.fromJson(Map<String, dynamic> json) =>
      MostPurchasedRes(
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "image": image,
        "price": price,
        "change": change,
        "changesPercentage": changesPercentage,
      };
}

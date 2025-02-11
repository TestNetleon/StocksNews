import 'dart:convert';

List<BaseTickerRes> baseTickerResFromJson(String str) =>
    List<BaseTickerRes>.from(
        json.decode(str).map((x) => BaseTickerRes.fromJson(x)));

String baseTickerResToJson(List<BaseTickerRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BaseTickerRes {
  final String? id;
  final String? symbol;
  final String? price;
  final String? image;
  final String? name;
  final String? change;
  final num? changesPercentage;

  BaseTickerRes({
    this.id,
    this.symbol,
    this.price,
    this.image,
    this.name,
    this.change,
    this.changesPercentage,
  });

  factory BaseTickerRes.fromJson(Map<String, dynamic> json) => BaseTickerRes(
        id: json["_id"],
        symbol: json["symbol"],
        price: json["price"],
        image: json["image"],
        name: json["name"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "symbol": symbol,
        "price": price,
        "image": image,
        "name": name,
        "change": change,
        "changesPercentage": changesPercentage,
      };
}

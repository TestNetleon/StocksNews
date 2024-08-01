import 'dart:convert';

List<TradingSearchTickerRes> tradingSearchTickerResFromJson(String str) =>
    List<TradingSearchTickerRes>.from(
        json.decode(str).map((x) => TradingSearchTickerRes.fromJson(x)));

String tradingSearchTickerResToJson(List<TradingSearchTickerRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TradingSearchTickerRes {
  final String? symbol;
  final String? name;
  final String? image;
  final String? price;
  final String? change;
  final double? changesPercentage;

  TradingSearchTickerRes({
    required this.symbol,
    required this.name,
    required this.image,
    required this.price,
    required this.change,
    required this.changesPercentage,
  });

  factory TradingSearchTickerRes.fromJson(Map<String, dynamic> json) =>
      TradingSearchTickerRes(
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        change: json["change"],
        changesPercentage: json["changesPercentage"]?.toDouble(),
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

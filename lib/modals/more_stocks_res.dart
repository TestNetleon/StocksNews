import 'dart:convert';

List<MoreStocksRes> moreStocksResFromJson(String str) =>
    List<MoreStocksRes>.from(
        json.decode(str).map((x) => MoreStocksRes.fromJson(x)));

String moreStocksResToJson(List<MoreStocksRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MoreStocksRes {
  final String name;
  final String symbol;
  final String price;
  final num changesPercentage;
  final String image;
  final String range;
  // final num dayLow;
  // final num dayHigh;
  final num volume;
  final num avgVolume;
  final String previousClose;

  MoreStocksRes({
    required this.name,
    required this.symbol,
    required this.price,
    required this.changesPercentage,
    required this.image,
    required this.range,
    // required this.dayLow,
    // required this.dayHigh,
    required this.volume,
    required this.avgVolume,
    required this.previousClose,
  });

  factory MoreStocksRes.fromJson(Map<String, dynamic> json) => MoreStocksRes(
        name: json["name"],
        symbol: json["symbol"],
        price: json["price"],
        changesPercentage: json["changesPercentage"] is num
            ? json["changesPercentage"].toDouble()
            : json["changesPercentage"],
        image: json["image"],
        range: json["range"],
        // dayLow:
        //     json["dayLow"] is num ? json["dayLow"].toDouble() : json["dayLow"],
        // dayHigh: json["dayHigh"] is num
        //     ? json["dayHigh"].toDouble()
        //     : json["dayHigh"],
        volume: json["volume"],
        avgVolume: json["avgVolume"],
        previousClose: json["previousClose"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "symbol": symbol,
        "price": price,
        "changesPercentage": changesPercentage,
        "image": image,
        "range": range,
        // "dayLow": dayLow,
        // "dayHigh": dayHigh,
        "volume": volume,
        "avgVolume": avgVolume,
        "previousClose": previousClose,
      };
}

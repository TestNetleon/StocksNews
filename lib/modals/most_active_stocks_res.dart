// To parse this JSON data, do
//
//     final mostActiveStocks = mostActiveStocksFromJson(jsonString);

import 'dart:convert';

List<MostActiveStocksRes> mostActiveStocksFromJson(String str) =>
    List<MostActiveStocksRes>.from(
        json.decode(str).map((x) => MostActiveStocksRes.fromJson(x)));

String mostActiveStocksToJson(List<MostActiveStocksRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MostActiveStocksRes {
  final dynamic symbol;
  final dynamic name;
  final dynamic image;
  final dynamic price;
  final dynamic exchange;
  final dynamic intradayRange;
  final dynamic volume;
  final dynamic avgVolume;
  final dynamic priceChange;
  final dynamic percentageChange;
  final dynamic dollarVolume;
  final dynamic dayLow;
  final dynamic dayHigh;
  final dynamic volatility;
  final dynamic volumeGrowth;

  MostActiveStocksRes({
    this.symbol,
    this.name,
    this.image,
    this.price,
    this.exchange,
    this.intradayRange,
    this.volume,
    this.avgVolume,
    this.priceChange,
    this.percentageChange,
    this.dollarVolume,
    this.dayLow,
    this.dayHigh,
    this.volatility,
    this.volumeGrowth,
  });

  factory MostActiveStocksRes.fromJson(Map<String, dynamic> json) =>
      MostActiveStocksRes(
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        exchange: json["exchange"],
        intradayRange: json["intraday_range"],
        volume: json["volume"],
        avgVolume: json["avgVolume"],
        priceChange: json["price_change"],
        percentageChange: json["percentage_change"],
        dollarVolume: json["dollarVolume"],
        dayLow: json["dayLow"],
        dayHigh: json["dayHigh"],
        volatility: json["volatility"],
        volumeGrowth: json["dayHigh"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "image": image,
        "price": price,
        "exchange": exchange,
        "intraday_range": intradayRange,
        "volume": volume,
        "avgVolume": avgVolume,
        "price_change": priceChange,
        "percentage_change": percentageChange,
        "dollarVolume": dollarVolume,
        "dayLow": dayLow,
        "dayHigh": dayHigh,
        "volatility": volatility,
        "Volume_growth": volumeGrowth,
      };
}

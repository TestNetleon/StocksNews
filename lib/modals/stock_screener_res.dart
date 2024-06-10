// To parse this JSON data, do
//
//     final stockScreenerRes = stockScreenerResFromJson(jsonString);

import 'dart:convert';

StockScreenerRes stockScreenerResFromJson(String str) =>
    StockScreenerRes.fromJson(json.decode(str));

String stockScreenerResToJson(StockScreenerRes data) =>
    json.encode(data.toJson());

class StockScreenerRes {
  final List<KeyValueElementStockScreener>? industries;
  final List<KeyValueElementStockScreener>? sectors;
  final List<KeyValueElementStockScreener>? exchange;
  final List<KeyValueElementStockScreener>? marketCap;
  final List<KeyValueElementStockScreener>? price;
  final List<KeyValueElementStockScreener>? beta;
  final List<KeyValueElementStockScreener>? dividend;
  final List<KeyValueElementStockScreener>? isEtf;
  final List<KeyValueElementStockScreener>? isFund;
  final List<KeyValueElementStockScreener>? isActivelyTrading;
  final List<Result>? result;

  StockScreenerRes({
    this.industries,
    this.sectors,
    this.exchange,
    this.marketCap,
    this.price,
    this.beta,
    this.dividend,
    this.isEtf,
    this.isFund,
    this.isActivelyTrading,
    this.result,
  });

  factory StockScreenerRes.fromJson(Map<String, dynamic> json) =>
      StockScreenerRes(
        industries: json["industries"] == null
            ? null
            : List<KeyValueElementStockScreener>.from(json["industries"]
                .map((x) => KeyValueElementStockScreener.fromJson(x))),
        sectors: json["sectors"] == null
            ? null
            : List<KeyValueElementStockScreener>.from(json["sectors"]
                .map((x) => KeyValueElementStockScreener.fromJson(x))),
        exchange: json["exchange"] == null
            ? null
            : List<KeyValueElementStockScreener>.from(json["exchange"]
                .map((x) => KeyValueElementStockScreener.fromJson(x))),
        marketCap: json["MarketCap"] == null
            ? null
            : List<KeyValueElementStockScreener>.from(json["MarketCap"]
                .map((x) => KeyValueElementStockScreener.fromJson(x))),
        price: json["price"] == null
            ? null
            : List<KeyValueElementStockScreener>.from(json["price"]
                .map((x) => KeyValueElementStockScreener.fromJson(x))),
        beta: json["beta"] == null
            ? null
            : List<KeyValueElementStockScreener>.from(json["beta"]
                .map((x) => KeyValueElementStockScreener.fromJson(x))),
        dividend: json["dividend"] == null
            ? null
            : List<KeyValueElementStockScreener>.from(json["dividend"]
                .map((x) => KeyValueElementStockScreener.fromJson(x))),
        isEtf: json["isEtf"] == null
            ? null
            : List<KeyValueElementStockScreener>.from(json["isEtf"]
                .map((x) => KeyValueElementStockScreener.fromJson(x))),
        isFund: json["isFund"] == null
            ? null
            : List<KeyValueElementStockScreener>.from(json["isFund"]
                .map((x) => KeyValueElementStockScreener.fromJson(x))),
        isActivelyTrading: json["isActivelyTrading"] == null
            ? null
            : List<KeyValueElementStockScreener>.from(json["isActivelyTrading"]
                .map((x) => KeyValueElementStockScreener.fromJson(x))),
        result: json["result"] == null
            ? null
            : List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "industries": industries == null
            ? null
            : List<dynamic>.from(industries!.map((x) => x.toJson())),
        "sectors": sectors == null
            ? null
            : List<dynamic>.from(sectors!.map((x) => x.toJson())),
        "exchange": exchange == null
            ? null
            : List<dynamic>.from(exchange!.map((x) => x.toJson())),
        "MarketCap": marketCap == null
            ? null
            : List<dynamic>.from(marketCap!.map((x) => x.toJson())),
        "price": price == null
            ? null
            : List<dynamic>.from(price!.map((x) => x.toJson())),
        "beta": beta == null
            ? null
            : List<dynamic>.from(beta!.map((x) => x.toJson())),
        "dividend": dividend == null
            ? null
            : List<dynamic>.from(dividend!.map((x) => x.toJson())),
        "isEtf": isEtf == null
            ? null
            : List<dynamic>.from(isEtf!.map((x) => x.toJson())),
        "isFund": isFund == null
            ? null
            : List<dynamic>.from(isFund!.map((x) => x.toJson())),
        "isActivelyTrading": isActivelyTrading == null
            ? null
            : List<dynamic>.from(isActivelyTrading!.map((x) => x.toJson())),
        "result": result == null
            ? null
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class KeyValueElementStockScreener {
  final dynamic key;
  final dynamic value;

  KeyValueElementStockScreener({
    this.key,
    this.value,
  });

  factory KeyValueElementStockScreener.fromJson(Map<String, dynamic> json) =>
      KeyValueElementStockScreener(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}

class Result {
  final dynamic symbol;
  final dynamic name;
  final dynamic marketCap;
  final dynamic sector;
  final dynamic industry;
  final dynamic beta;
  final dynamic price;
  final dynamic lastAnnualDividend;
  final dynamic volume;
  final dynamic exchange;
  final dynamic exchangeShortName;
  final dynamic country;
  final dynamic isEtf;
  final dynamic isFund;
  final dynamic isActivelyTrading;

  Result({
    this.symbol,
    this.name,
    this.marketCap,
    this.sector,
    this.industry,
    this.beta,
    this.price,
    this.lastAnnualDividend,
    this.volume,
    this.exchange,
    this.exchangeShortName,
    this.country,
    this.isEtf,
    this.isFund,
    this.isActivelyTrading,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        symbol: json["symbol"],
        name: json["name"],
        marketCap: json["marketCap"],
        sector: json["sector"],
        industry: json["industry"],
        beta: json["beta"],
        price: json["price"],
        lastAnnualDividend: json["lastAnnualDividend"],
        volume: json["volume"],
        exchange: json["exchange"],
        exchangeShortName: json["exchangeShortName"],
        country: json["country"],
        isEtf: json["isEtf"],
        isFund: json["isFund"],
        isActivelyTrading: json["isActivelyTrading"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "marketCap": marketCap,
        "sector": sector,
        "industry": industry,
        "beta": beta,
        "price": price,
        "lastAnnualDividend": lastAnnualDividend,
        "volume": volume,
        "exchange": exchange,
        "exchangeShortName": exchangeShortName,
        "country": country,
        "isEtf": isEtf,
        "isFund": isFund,
        "isActivelyTrading": isActivelyTrading,
      };
}

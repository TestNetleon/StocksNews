// To parse this JSON data, do
//
//     final dowThirtyRes = dowThirtyResFromJson(jsonString);

import 'dart:convert';

DowThirtyRes dowThirtyResFromJson(String str) =>
    DowThirtyRes.fromJson(json.decode(str));

String dowThirtyResToJson(DowThirtyRes data) => json.encode(data.toJson());

class DowThirtyRes {
  final List<KeyValueElementDowThirty>? industries;
  final List<KeyValueElementDowThirty>? sectors;
  final List<KeyValueElementDowThirty>? exchange;
  final List<KeyValueElementDowThirty>? marketCap;

  final List<Result>? result;

  DowThirtyRes({
    this.industries,
    this.sectors,
    this.exchange,
    this.marketCap,
    this.result,
  });

  factory DowThirtyRes.fromJson(Map<String, dynamic> json) => DowThirtyRes(
        industries: json["industries"] == null
            ? null
            : List<KeyValueElementDowThirty>.from(json["industries"]
                .map((x) => KeyValueElementDowThirty.fromJson(x))),
        sectors: json["sectors"] == null
            ? null
            : List<KeyValueElementDowThirty>.from(json["sectors"]
                .map((x) => KeyValueElementDowThirty.fromJson(x))),
        exchange: json["exchange"] == null
            ? null
            : List<KeyValueElementDowThirty>.from(json["exchange"]
                .map((x) => KeyValueElementDowThirty.fromJson(x))),
        marketCap: json["MarketCap"] == null
            ? null
            : List<KeyValueElementDowThirty>.from(json["MarketCap"]
                .map((x) => KeyValueElementDowThirty.fromJson(x))),
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
        "result": result == null
            ? null
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class KeyValueElementDowThirty {
  final dynamic key;
  final dynamic value;

  KeyValueElementDowThirty({
    this.key,
    this.value,
  });

  factory KeyValueElementDowThirty.fromJson(Map<String, dynamic> json) =>
      KeyValueElementDowThirty(
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
  final dynamic exchangeShortName;
  final dynamic price;
  final dynamic change;
  final dynamic pe;
  final dynamic mktCap;
  final dynamic percentageChange;
  final dynamic volume;
  final dynamic avgVolume;
  final dynamic image;
  final dynamic priceChange;

  final dynamic sector;
  final dynamic exchangeValues;

  final dynamic consensusAnalystRating;
  final dynamic peRatio;
  final dynamic analystRatingConsensusPriceTarget;

  Result({
    this.symbol,
    this.name,
    this.exchangeShortName,
    this.price,
    this.change,
    this.pe,
    this.mktCap,
    this.percentageChange,
    this.volume,
    this.avgVolume,
    this.image,
    this.priceChange,
    this.sector,
    this.exchangeValues,
    this.consensusAnalystRating,
    this.peRatio,
    this.analystRatingConsensusPriceTarget,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        symbol: json["symbol"],
        name: json["name"],
        exchangeShortName: json["exchange_short_name"],
        price: json["price"],
        change: json["change"],
        pe: json["pe"],
        mktCap: json["mktCap"],
        percentageChange: json["percentage_change"],
        volume: json["volume"],
        avgVolume: json["avgVolume"],
        image: json["image"],
        priceChange: json["price_change"],
        sector: json["sector"],
        exchangeValues: json["exchange"],
        consensusAnalystRating: json["consensus_analyst_rating"],
        peRatio: json["pe_ratio"],
        analystRatingConsensusPriceTarget:
            json["analyst_rating_consensus_price_target"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "exchange_short_name": exchangeShortName,
        "price": price,
        "change": change,
        "pe": pe,
        "mktCap": mktCap,
        "percentage_change": percentageChange,
        "volume": volume,
        "avgVolume": avgVolume,
        "image": image,
        "price_change": priceChange,
        "sector": sector,
        "exchange": exchangeValues,
        "consensus_analyst_rating": consensusAnalystRating,
        "pe_ratio": peRatio,
        "analyst_rating_consensus_price_target":
            analystRatingConsensusPriceTarget,
      };
}

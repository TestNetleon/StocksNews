import 'dart:convert';

StocksDetailOverviewRes stocksDetailOverviewResFromJson(String str) =>
    StocksDetailOverviewRes.fromJson(json.decode(str));

String stocksDetailOverviewResToJson(StocksDetailOverviewRes data) =>
    json.encode(data.toJson());

class StocksDetailOverviewRes {
  final StocksTickerDataRes? tickerData;
  final StockScoreRes? stockScore;

  StocksDetailOverviewRes({
    this.tickerData,
    this.stockScore,
  });

  factory StocksDetailOverviewRes.fromJson(Map<String, dynamic> json) =>
      StocksDetailOverviewRes(
        tickerData: json["ticker_data"] == null
            ? null
            : StocksTickerDataRes.fromJson(json["ticker_data"]),
        stockScore: json["stock_score"] == null
            ? null
            : StockScoreRes.fromJson(json["stock_score"]),
      );

  Map<String, dynamic> toJson() => {
        "ticker_data": tickerData?.toJson(),
        "stock_score": stockScore?.toJson(),
      };
}

class StockScoreRes {
  final String? altmanZScore;
  final String? piotroskiScore;
  final String? mostRepeatedGrade;

  StockScoreRes({
    this.altmanZScore,
    this.piotroskiScore,
    this.mostRepeatedGrade,
  });

  factory StockScoreRes.fromJson(Map<String, dynamic> json) => StockScoreRes(
        altmanZScore: json["altman_z_score"],
        piotroskiScore: json["piotroski_score"],
        mostRepeatedGrade: json["most_repeated_grade"],
      );

  Map<String, dynamic> toJson() => {
        "altman_z_score": altmanZScore,
        "piotroski_score": piotroskiScore,
        "most_repeated_grade": mostRepeatedGrade,
      };
}

class StocksTickerDataRes {
  final String? ceo;
  final String? country;
  final String? fullTimeEmployees;
  final String? ipoDate;
  final String? isIn;
  final String? sector;
  final String? sectorSlug;
  final String? industry;
  final String? industrySlug;
  final String? website;
  final String? description;
  final num? dayLow;
  final num? dayHigh;
  final num? yearLow;
  final num? yearHigh;
  final num? currentPrice;

  StocksTickerDataRes({
    this.ceo,
    this.country,
    this.fullTimeEmployees,
    this.ipoDate,
    this.isIn,
    this.sector,
    this.sectorSlug,
    this.industry,
    this.industrySlug,
    this.website,
    this.description,
    this.dayLow,
    this.dayHigh,
    this.yearLow,
    this.yearHigh,
    this.currentPrice,
  });

  factory StocksTickerDataRes.fromJson(Map<String, dynamic> json) =>
      StocksTickerDataRes(
        ceo: json["ceo"],
        country: json["country"],
        fullTimeEmployees: json["fullTimeEmployees"],
        ipoDate: json["ipoDate"],
        isIn: json["isIn"],
        sector: json["sector"],
        sectorSlug: json["sector_slug"],
        industry: json["industry"],
        industrySlug: json["industry_slug"],
        website: json["website"],
        description: json["description"],
        dayLow: json["dayLow"],
        dayHigh: json["dayHigh"],
        yearLow: json["yearLow"],
        yearHigh: json["yearHigh"],
        currentPrice: json["currentPrice"],
      );

  Map<String, dynamic> toJson() => {
        "ceo": ceo,
        "country": country,
        "fullTimeEmployees": fullTimeEmployees,
        "ipoDate": ipoDate,
        "isIn": isIn,
        "sector": sector,
        "sector_slug": sectorSlug,
        "industry": industry,
        "industry_slug": industrySlug,
        "website": website,
        "description": description,
        "dayLow": dayLow,
        "dayHigh": dayHigh,
        "yearLow": yearLow,
        "yearHigh": yearHigh,
        "currentPrice": currentPrice,
      };
}

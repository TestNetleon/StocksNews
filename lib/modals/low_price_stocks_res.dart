import 'dart:convert';

List<LowPriceStocksRes> lowPriceStocksResFromJson(String str) =>
    List<LowPriceStocksRes>.from(
        json.decode(str).map((x) => LowPriceStocksRes.fromJson(x)));

String lowPriceStocksResToJson(List<LowPriceStocksRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LowPriceStocksRes {
  final String? id;
  final String? symbol;
  final String? name;
  final String? exchange;
  final String? exchangeShortName;
  final Type? type;
  final String? description;
  final String? sector;
  final String? image;
  final num? price;
  final int? mktCap;
  final bool? twitStatus;
  final bool? redditStatus;
  final int? status;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final String? industry;
  final bool? sentimentStatus;
  final bool? stockNewsStatus;
  final num? change;
  final num? changesPercentage;
  final String? industrySlug;
  final String? sectorSlug;
  final String? slug;
  final bool? finnhubStatus;
  final int? dailyUpdate;
  final int? webView;
  final AnalystStock? analystStock;
  final int? avgVolume;
  final num? dayHigh;
  final num? dayLow;
  final num? eps;
  final num? pe;
  final num? previousClose;
  final PriceTarget? priceTarget;
  final int? volume;
  final num? yearHigh;
  final num? yearLow;
  final String? cap;
  final int? appView;
  final String? ceo;
  final String? website;
  final String? country;
  final String? isin;
  final int? gapType;
  final double? open;

  LowPriceStocksRes({
    this.id,
    this.symbol,
    this.name,
    this.exchange,
    this.exchangeShortName,
    this.type,
    this.description,
    this.sector,
    this.image,
    this.price,
    this.mktCap,
    this.twitStatus,
    this.redditStatus,
    this.status,
    this.updatedAt,
    this.createdAt,
    this.industry,
    this.sentimentStatus,
    this.stockNewsStatus,
    this.change,
    this.changesPercentage,
    this.industrySlug,
    this.sectorSlug,
    this.slug,
    this.finnhubStatus,
    this.dailyUpdate,
    this.webView,
    this.analystStock,
    this.avgVolume,
    this.dayHigh,
    this.dayLow,
    this.eps,
    this.pe,
    this.previousClose,
    this.priceTarget,
    this.volume,
    this.yearHigh,
    this.yearLow,
    this.cap,
    this.appView,
    this.ceo,
    this.website,
    this.country,
    this.isin,
    this.gapType,
    this.open,
  });

  factory LowPriceStocksRes.fromJson(Map<String, dynamic> json) =>
      LowPriceStocksRes(
        id: json["_id"],
        symbol: json["symbol"],
        name: json["name"],
        exchange: json["exchange"],
        exchangeShortName: json["exchange_short_name"],
        type: json["type"],
        description: json["description"],
        sector: json["sector"],
        image: json["image"],
        price: json["price"],
        mktCap: json["mktCap"],
        twitStatus: json["twit_status"],
        redditStatus: json["reddit_status"],
        status: json["status"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        industry: json["industry"],
        sentimentStatus: json["sentiment_status"],
        stockNewsStatus: json["stock_news_status"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
        industrySlug: json["industry_slug"],
        sectorSlug: json["sector_slug"],
        slug: json["slug"],
        finnhubStatus: json["finnhub_status"],
        dailyUpdate: json["daily_update"],
        webView: json["web_view"],
        analystStock: json["analyst_stock"] == null
            ? null
            : AnalystStock.fromJson(json["analyst_stock"]),
        avgVolume: json["avgVolume"],
        dayHigh: json["dayHigh"]?.toDouble(),
        dayLow: json["dayLow"]?.toDouble(),
        eps: json["eps"]?.toDouble(),
        pe: json["pe"]?.toDouble(),
        previousClose: json["previousClose"]?.toDouble(),
        priceTarget: json["price_target"] == null
            ? null
            : PriceTarget.fromJson(json["price_target"]),
        volume: json["volume"],
        yearHigh: json["yearHigh"]?.toDouble(),
        yearLow: json["yearLow"]?.toDouble(),
        cap: json["cap"],
        appView: json["app_view"],
        ceo: json["ceo"],
        website: json["website"],
        country: json["country"],
        isin: json["isin"],
        gapType: json["gap_type"],
        open: json["open"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "symbol": symbol,
        "name": name,
        "exchange": exchange,
        "exchange_short_name": exchangeShortName,
        "type": type,
        "description": description,
        "sector": sector,
        "image": image,
        "price": price,
        "mktCap": mktCap,
        "twit_status": twitStatus,
        "reddit_status": redditStatus,
        "status": status,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "industry": industry,
        "sentiment_status": sentimentStatus,
        "stock_news_status": stockNewsStatus,
        "change": change,
        "changesPercentage": changesPercentage,
        "industry_slug": industrySlug,
        "sector_slug": sectorSlug,
        "slug": slug,
        "finnhub_status": finnhubStatus,
        "daily_update": dailyUpdate,
        "web_view": webView,
        "analyst_stock": analystStock?.toJson(),
        "avgVolume": avgVolume,
        "dayHigh": dayHigh,
        "dayLow": dayLow,
        "eps": eps,
        "pe": pe,
        "previousClose": previousClose,
        "price_target": priceTarget?.toJson(),
        "volume": volume,
        "yearHigh": yearHigh,
        "yearLow": yearLow,
        "cap": cap,
        "app_view": appView,
        "ceo": ceo,
        "website": website,
        "country": country,
        "isin": isin,
        "gap_type": gapType,
        "open": open,
      };
}

class AnalystStock {
  final DateTime? date;
  final int? analystRatingsbuy;
  final int? analystRatingsHold;
  final int? analystRatingsSell;
  final int? analystRatingsStrongSell;
  final int? analystRatingsStrongBuy;

  AnalystStock({
    this.date,
    this.analystRatingsbuy,
    this.analystRatingsHold,
    this.analystRatingsSell,
    this.analystRatingsStrongSell,
    this.analystRatingsStrongBuy,
  });

  factory AnalystStock.fromJson(Map<String, dynamic> json) => AnalystStock(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        analystRatingsbuy: json["analystRatingsbuy"],
        analystRatingsHold: json["analystRatingsHold"],
        analystRatingsSell: json["analystRatingsSell"],
        analystRatingsStrongSell: json["analystRatingsStrongSell"],
        analystRatingsStrongBuy: json["analystRatingsStrongBuy"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "analystRatingsbuy": analystRatingsbuy,
        "analystRatingsHold": analystRatingsHold,
        "analystRatingsSell": analystRatingsSell,
        "analystRatingsStrongSell": analystRatingsStrongSell,
        "analystRatingsStrongBuy": analystRatingsStrongBuy,
      };
}

class PriceTarget {
  final int? targetHigh;
  final int? targetLow;
  final double? targetConsensus;
  final double? targetMedian;

  PriceTarget({
    this.targetHigh,
    this.targetLow,
    this.targetConsensus,
    this.targetMedian,
  });

  factory PriceTarget.fromJson(Map<String, dynamic> json) => PriceTarget(
        targetHigh: json["targetHigh"],
        targetLow: json["targetLow"],
        targetConsensus: json["targetConsensus"]?.toDouble(),
        targetMedian: json["targetMedian"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "targetHigh": targetHigh,
        "targetLow": targetLow,
        "targetConsensus": targetConsensus,
        "targetMedian": targetMedian,
      };
}

import 'dart:convert';

StockDetailsRes stockDetailsResFromJson(String str) =>
    StockDetailsRes.fromJson(json.decode(str));

String stockDetailsResToJson(StockDetailsRes data) =>
    json.encode(data.toJson());

class StockDetailsRes {
  final KeyStats? keyStats;
  final CompanyInfo? companyInfo;
  num? isAlertAdded;
  num? isWatchlistAdded;

  // final List<TradingStock>? tradingStock;
  // final List<Mentions>? mentions;
  // final List<RedditPost>? redditPost;
  // final List<News>? newsPost;
  // final List<TopPost>? topPosts;
  // final String? forecastAnalyst;

  StockDetailsRes({
    this.keyStats,
    this.companyInfo,
    this.isAlertAdded,
    this.isWatchlistAdded,
    // this.tradingStock,
    // this.mentions,
    // this.redditPost,
    // this.newsPost,
    // this.topPosts,
    // this.forecastAnalyst,
  });

  factory StockDetailsRes.fromJson(Map<String, dynamic> json) =>
      StockDetailsRes(
        keyStats: json["key_stats"] == null
            ? null
            : KeyStats.fromJson(json["key_stats"]),
        companyInfo: json["company_info"] == null
            ? null
            : CompanyInfo.fromJson(json["company_info"]),
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],
        // tradingStock: json["trading_stock"] == null
        //     ? []
        //     : List<TradingStock>.from(
        //         json["trading_stock"]?.map((x) => TradingStock.fromJson(x))),
        // mentions: json["mentions"] == null
        //     ? []
        //     : List<Mentions>.from(
        //         json["mentions"]?.map((x) => Mentions.fromJson(x))),
        // redditPost: json["reddit_post"] == null
        //     ? []
        //     : List<RedditPost>.from(
        //         json["reddit_post"]?.map((x) => RedditPost.fromJson(x))),
        // topPosts: json["top_posts"] == null
        //     ? []
        //     : List<TopPost>.from(
        //         json["top_posts"]!.map((x) => TopPost.fromJson(x))),
        // forecastAnalyst: json["forecast_analyst"],
      );

  Map<String, dynamic> toJson() => {
        "key_stats": keyStats?.toJson(),
        "company_info": companyInfo?.toJson(),
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
        // "trading_stock": tradingStock == null
        //     ? []
        //     : List<dynamic>.from(tradingStock!.map((x) => x.toJson())),
        // "mentions": mentions == null
        //     ? []
        //     : List<dynamic>.from(mentions!.map((x) => x.toJson())),
        // "reddit_post": redditPost == null
        //     ? []
        //     : List<dynamic>.from(redditPost!.map((x) => x)),
        // "top_posts": topPosts == null
        //     ? []
        //     : List<dynamic>.from(topPosts!.map((x) => x.toJson())),
        // "forecast_analyst": forecastAnalyst,
      };
}

class CompanyInfo {
  final String? companyName;
  final String? sector;
  final String? sectorSlug;
  final String? industry;
  final String? industrySlug;

  final String? ceo;
  final String? website;
  final String? country;
  final String? fullTimeEmployees;
  final String? ipoDate;
  final String? isin;
  final String? description;
  final String? image;
  String? redditRssId, twitterRssId;

  CompanyInfo({
    this.companyName,
    this.sector,
    this.industry,
    this.ceo,
    this.website,
    this.country,
    this.fullTimeEmployees,
    this.ipoDate,
    this.isin,
    this.description,
    this.twitterRssId,
    this.image,
    this.industrySlug,
    this.redditRssId,
    this.sectorSlug,
  });

  factory CompanyInfo.fromJson(Map<String, dynamic> json) => CompanyInfo(
      companyName: json["companyName"],
      sector: json["sector"],
      industry: json["industry"],
      ceo: json["ceo"],
      website: json["website"],
      country: json["country"],
      fullTimeEmployees: json["fullTimeEmployees"],
      ipoDate: json["ipoDate"],
      isin: json["isin"],
      description: json["description"],
      image: json["image"],
      sectorSlug: json["sector_slug"],
      redditRssId: json["reddit_rss_id"],
      twitterRssId: json["twitter_rss_id"],
      industrySlug: json["industry_slug"]);

  Map<String, dynamic> toJson() => {
        "companyName": companyName,
        "sector": sector,
        "industry": industry,
        "ceo": ceo,
        "website": website,
        "country": country,
        "fullTimeEmployees": fullTimeEmployees,
        "ipoDate": ipoDate,
        "isin": isin,
        "description": description,
        "image": image,
        "reddit_rss_id": redditRssId,
        "twitter_rss_id": twitterRssId,
        "sector_slug": sectorSlug,
        "industry_slug": industrySlug,
      };
}

class KeyStats {
  final String symbol;
  final String name;
  final String? price;
  final num? priceWithoutCur;
  final num? changesPercentage;
  final num? change;
  final String? dayLow;
  final String? dayHigh;
  final String? yearHigh;
  final String? yearLow;
  final String? marketCap;
  final String? priceAvg50;
  final String? priceAvg200;
  final String? exchange;
  final String? volume;
  final String? avgVolume;
  final String? open;
  final String? marketStatus;
  final String? previousClose;
  final num? eps;
  final num? pe;
  final String? earningsAnnouncement;
  final String? sharesOutstanding;
  final num? timestamp;

  final num? priceValue;
  final num? dayLowValue;
  final num? dayHighValue;
  final num? yearLowValue;
  final num? yearHighValue;

  KeyStats({
    required this.symbol,
    required this.name,
    this.price,
    this.priceWithoutCur,
    this.marketStatus,
    this.changesPercentage,
    this.change,
    this.dayLow,
    this.dayHigh,
    this.yearHigh,
    this.yearLow,
    this.marketCap,
    this.priceAvg50,
    this.priceAvg200,
    this.exchange,
    this.volume,
    this.avgVolume,
    this.open,
    this.previousClose,
    this.eps,
    this.pe,
    this.earningsAnnouncement,
    this.sharesOutstanding,
    this.timestamp,
    this.dayHighValue,
    this.dayLowValue,
    this.yearHighValue,
    this.yearLowValue,
    this.priceValue,
  });

  factory KeyStats.fromJson(Map<String, dynamic> json) => KeyStats(
        symbol: json["symbol"],
        name: json["name"],
        price: json["price"],
        priceWithoutCur: json["price_without_cur"],
        changesPercentage: json["changesPercentage"],
        change: json["change"],
        dayLow: json["dayLow"],
        dayHigh: json["dayHigh"],
        yearHigh: json["yearHigh"],
        yearLow: json["yearLow"],
        marketCap: json["marketCap"],
        priceAvg50: json["priceAvg50"],
        priceAvg200: json["priceAvg200"],
        exchange: json["exchange"],
        volume: json["volume"],
        avgVolume: json["avgVolume"],
        marketStatus: json["market_status"],
        open: json["open"],
        previousClose: json["previousClose"],
        eps: json["eps"],
        pe: json["pe"],
        earningsAnnouncement: json["earningsAnnouncement"],
        sharesOutstanding: json["sharesOutstanding"],
        timestamp: json["timestamp"],
        dayHighValue: json["dayHigh_value"],
        dayLowValue: json["dayLow_value"],
        yearHighValue: json["yearHigh_value"],
        yearLowValue: json["yearLow_value"],
        priceValue: json["price_value"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "price": price,
        "price_without_cur": priceWithoutCur,
        "changesPercentage": changesPercentage,
        "change": change,
        "dayLow": dayLow,
        "dayHigh": dayHigh,
        "yearHigh": yearHigh,
        "yearLow": yearLow,
        "marketCap": marketCap,
        "priceAvg50": priceAvg50,
        "priceAvg200": priceAvg200,
        "exchange": exchange,
        "volume": volume,
        "avgVolume": avgVolume,
        "open": open,
        "previousClose": previousClose,
        "eps": eps,
        "pe": pe,
        "earningsAnnouncement": earningsAnnouncement,
        "sharesOutstanding": sharesOutstanding,
        "timestamp": timestamp,
        "price_value": priceValue,
        "dayLow_value": dayLowValue,
        "dayHigh_value": dayHighValue,
        "yearLow_value": yearLowValue,
        "yearHigh_value": yearHighValue,
        "market_status": marketStatus,
      };
}

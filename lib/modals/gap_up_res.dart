import 'dart:convert';

GapUpRes gapUpResFromJson(String str) => GapUpRes.fromJson(json.decode(str));

String gapUpResToJson(GapUpRes data) => json.encode(data.toJson());

class GapUpRes {
  final List<GapUpData> data;
  final int lastPage;

  GapUpRes({
    required this.data,
    required this.lastPage,
  });

  factory GapUpRes.fromJson(Map<String, dynamic> json) => GapUpRes(
        data: List<GapUpData>.from(
            json["data"].map((x) => GapUpData.fromJson(x))),
        lastPage: json["last_page"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "last_page": lastPage,
      };
}

class GapUpData {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final String price;
  final String change;
  final String changesPercentage;
  final int volume;
  final double previousClose;
  final double open;
  final String changeSinceOpen;

  // final Exchange exchange;
  // final ExchangeShortName exchangeShortName;
  // final Type type;
  // final String description;
  // final String sector;
  // final int mktCap;
  // final bool twitStatus;
  // final bool redditStatus;
  // final int status;
  // final String industry;
  // final bool sentimentStatus;
  // final bool stockNewsStatus;
  // final String industrySlug;
  // final String sectorSlug;
  // final String slug;
  // final bool finnhubStatus;
  // final String ceo;
  // final String website;
  // final Country country;
  // final String isin;
  // final int dailyUpdate;
  // final int avgVolume;
  // final double eps;
  // final double pe;
  // final DateTime updatedAt;
  // final DateTime createdAt;
  // final AnalystStock analystStock;
  // final double dayHigh;
  // final double dayLow;
  // final dynamic priceTarget;
  // final double yearHigh;
  // final double yearLow;
  // final double gapPer;
  // final int gapType;
  // final int webView;
  // final dynamic beta;

  GapUpData({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.price,
    required this.change,
    required this.changesPercentage,
    required this.volume,
    required this.previousClose,
    required this.open,
    required this.changeSinceOpen,
    // required this.exchange,
    // required this.exchangeShortName,
    // required this.type,
    // required this.description,
    // required this.sector,
    // required this.mktCap,
    // required this.twitStatus,
    // required this.redditStatus,
    // required this.status,
    // required this.industry,
    // required this.sentimentStatus,
    // required this.stockNewsStatus,
    // required this.industrySlug,
    // required this.sectorSlug,
    // required this.slug,
    // required this.finnhubStatus,
    // required this.ceo,
    // required this.website,
    // required this.country,
    // required this.isin,
    // required this.dailyUpdate,
    // required this.avgVolume,
    // required this.eps,
    // required this.pe,
    // required this.updatedAt,
    // required this.createdAt,
    // required this.analystStock,
    // required this.dayHigh,
    // required this.dayLow,
    // required this.priceTarget,
    // required this.yearHigh,
    // required this.yearLow,
    // required this.gapPer,
    // required this.gapType,
    // required this.webView,
    // required this.beta,
  });

  factory GapUpData.fromJson(Map<String, dynamic> json) => GapUpData(
        id: json["_id"],
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
        volume: json["volume"],
        price: json["price"],
        previousClose: json["previousClose"],
        open: json["open"],
        changeSinceOpen: json["priceChangeSinceOpen"],
        // exchange: exchangeValues.map[json["exchange"]]!,
        // exchangeShortName:
        //     exchangeShortNameValues.map[json["exchange_short_name"]]!,
        // type: typeValues.map[json["type"]]!,
        // description: json["description"],
        // sector: json["sector"],
        // mktCap: json["mktCap"],
        // twitStatus: json["twit_status"],
        // redditStatus: json["reddit_status"],
        // status: json["status"],
        // industry: json["industry"],
        // sentimentStatus: json["sentiment_status"],
        // stockNewsStatus: json["stock_news_status"],
        // industrySlug: json["industry_slug"],
        // sectorSlug: json["sector_slug"],
        // slug: json["slug"],
        // finnhubStatus: json["finnhub_status"],
        // ceo: json["ceo"],
        // website: json["website"],
        // country: countryValues.map[json["country"]]!,
        // isin: json["isin"],
        // dailyUpdate: json["daily_update"],
        // avgVolume: json["avgVolume"],
        // eps: json["eps"]?.toDouble(),
        // pe: json["pe"]?.toDouble(),
        // updatedAt: DateTime.parse(json["updated_at"]),
        // createdAt: DateTime.parse(json["created_at"]),
        // analystStock: AnalystStock.fromJson(json["analyst_stock"]),
        // dayHigh: json["dayHigh"]?.toDouble(),
        // dayLow: json["dayLow"]?.toDouble(),
        // priceTarget: json["price_target"],
        // yearHigh: json["yearHigh"]?.toDouble(),
        // yearLow: json["yearLow"]?.toDouble(),
        // gapPer: json["gap_per"]?.toDouble(),
        // gapType: json["gap_type"],
        // webView: json["web_view"],
        // beta: json["beta"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "symbol": symbol,
        "name": name,
        "image": image,
        "change": change,
        "changesPercentage": changesPercentage,
        "volume": volume,
        "previousClose": previousClose,
        "open": open,
        "priceChangeSinceOpen": changeSinceOpen,
        // "exchange": exchangeValues.reverse[exchange],
        // "exchange_short_name":
        //     exchangeShortNameValues.reverse[exchangeShortName],
        // "type": typeValues.reverse[type],
        // "description": description,
        // "sector": sector,
        // "price": price,
        // "mktCap": mktCap,
        // "twit_status": twitStatus,
        // "reddit_status": redditStatus,
        // "status": status,
        // "industry": industry,
        // "sentiment_status": sentimentStatus,
        // "stock_news_status": stockNewsStatus,
        // "industry_slug": industrySlug,
        // "sector_slug": sectorSlug,
        // "slug": slug,
        // "finnhub_status": finnhubStatus,
        // "ceo": ceo,
        // "website": website,
        // "country": countryValues.reverse[country],
        // "isin": isin,
        // "daily_update": dailyUpdate,
        // "avgVolume": avgVolume,
        // "eps": eps,
        // "pe": pe,
        // "updated_at": updatedAt.toIso8601String(),
        // "created_at": createdAt.toIso8601String(),
        // "analyst_stock": analystStock.toJson(),
        // "dayHigh": dayHigh,
        // "dayLow": dayLow,
        // "price_target": priceTarget,
        // "yearHigh": yearHigh,
        // "yearLow": yearLow,
        // "gap_per": gapPer,
        // "gap_type": gapType,
        // "web_view": webView,
        // "beta": beta,
      };
}

class AnalystStock {
  final DateTime date;
  final int analystRatingsbuy;
  final int analystRatingsHold;
  final int analystRatingsSell;
  final int analystRatingsStrongSell;
  final int analystRatingsStrongBuy;

  AnalystStock({
    required this.date,
    required this.analystRatingsbuy,
    required this.analystRatingsHold,
    required this.analystRatingsSell,
    required this.analystRatingsStrongSell,
    required this.analystRatingsStrongBuy,
  });

  factory AnalystStock.fromJson(Map<String, dynamic> json) => AnalystStock(
        date: DateTime.parse(json["date"]),
        analystRatingsbuy: json["analystRatingsbuy"],
        analystRatingsHold: json["analystRatingsHold"],
        analystRatingsSell: json["analystRatingsSell"],
        analystRatingsStrongSell: json["analystRatingsStrongSell"],
        analystRatingsStrongBuy: json["analystRatingsStrongBuy"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "analystRatingsbuy": analystRatingsbuy,
        "analystRatingsHold": analystRatingsHold,
        "analystRatingsSell": analystRatingsSell,
        "analystRatingsStrongSell": analystRatingsStrongSell,
        "analystRatingsStrongBuy": analystRatingsStrongBuy,
      };
}

enum Country { CA, US }

final countryValues = EnumValues({"CA": Country.CA, "US": Country.US});

enum Exchange { OTHER_OTC }

final exchangeValues = EnumValues({"Other OTC": Exchange.OTHER_OTC});

enum ExchangeShortName { OTC }

final exchangeShortNameValues = EnumValues({"OTC": ExchangeShortName.OTC});

enum Type { STOCK }

final typeValues = EnumValues({"stock": Type.STOCK});

class Link {
  final String url;
  final String label;
  final bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

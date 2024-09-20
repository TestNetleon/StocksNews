import 'dart:convert';

MsStockTopRes msStockTopResFromJson(String str) =>
    MsStockTopRes.fromJson(json.decode(str));

String msStockTopResToJson(MsStockTopRes data) => json.encode(data.toJson());

class MsStockTopRes {
  final String? symbol;
  final String? name;
  String? price;
  num? changesPercentage;
  num? change;
  final String? dayLow;
  final String? dayHigh;
  final String? yearHigh;
  final String? yearLow;
  final String? marketCap;
  final String? exchange;
  final num? priceValue;
  final num? dayLowValue;
  final num? dayHighValue;
  final num? yearLowValue;
  final num? yearHighValue;
  // final num? priceWithoutCur;
  String? changeWithCur;
  // final num? previousCloseWithoutCur;
  final String? marketStatus;
  final String? companyName;
  // final String? sector;
  // final String? sectorSlug;
  // final String? industry;
  // final String? industrySlug;
  final String? image;
  final num? isAlertAdded;
  final num? isWatchlistAdded;
  final String? shareUrl;

  MsStockTopRes({
    this.symbol,
    this.name,
    this.price,
    this.changesPercentage,
    this.change,
    this.dayLow,
    this.dayHigh,
    this.yearHigh,
    this.yearLow,
    this.marketCap,
    this.exchange,
    this.priceValue,
    this.dayLowValue,
    this.dayHighValue,
    this.yearLowValue,
    this.yearHighValue,
    // this.priceWithoutCur,
    this.changeWithCur,
    // this.previousCloseWithoutCur,
    this.marketStatus,
    this.companyName,
    // this.sector,
    // this.sectorSlug,
    // this.industry,
    // this.industrySlug,
    this.image,
    this.isAlertAdded,
    this.isWatchlistAdded,
    this.shareUrl,
  });

  factory MsStockTopRes.fromJson(Map<String, dynamic> json) => MsStockTopRes(
        symbol: json["symbol"],
        name: json["name"],
        price: json["price"],
        changesPercentage: json["changesPercentage"],
        change: json["change"],
        dayLow: json["dayLow"],
        dayHigh: json["dayHigh"],
        yearHigh: json["yearHigh"],
        yearLow: json["yearLow"],
        marketCap: json["marketCap"],
        exchange: json["exchange"],
        priceValue: json["price_value"],
        dayLowValue: json["dayLow_value"],
        dayHighValue: json["dayHigh_value"],
        yearLowValue: json["yearLow_value"],
        yearHighValue: json["yearHigh_value"],
        // priceWithoutCur: json["price_without_cur"],
        changeWithCur: json["change_with_cur"],
        // previousCloseWithoutCur: json["previousClose_without_cur"],
        marketStatus: json["market_status"],
        companyName: json["companyName"],
        // sector: json["sector"],
        // sectorSlug: json["sector_slug"],
        // industry: json["industry"],
        // industrySlug: json["industry_slug"],
        image: json["image"],
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],
        shareUrl: json["share_url"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "price": price,
        "changesPercentage": changesPercentage,
        "change": change,
        "dayLow": dayLow,
        "dayHigh": dayHigh,
        "yearHigh": yearHigh,
        "yearLow": yearLow,
        "marketCap": marketCap,
        "exchange": exchange,
        "price_value": priceValue,
        "dayLow_value": dayLowValue,
        "dayHigh_value": dayHighValue,
        "yearLow_value": yearLowValue,
        "yearHigh_value": yearHighValue,
        // "price_without_cur": priceWithoutCur,
        "change_with_cur": changeWithCur,
        // "previousClose_without_cur": previousCloseWithoutCur,
        "market_status": marketStatus,
        "companyName": companyName,
        // "sector": sector,
        // "sector_slug": sectorSlug,
        // "industry": industry,
        // "industry_slug": industrySlug,
        "image": image,
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
        "share_url": shareUrl,
      };
}

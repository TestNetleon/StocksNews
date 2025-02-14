import 'dart:convert';

List<BaseTickerRes> baseTickerResFromJson(String str) =>
    List<BaseTickerRes>.from(
        json.decode(str).map((x) => BaseTickerRes.fromJson(x)));

String baseTickerResToJson(List<BaseTickerRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BaseTickerRes {
  final String? id;
  final String? symbol;
  final String? price;
  final String? image;
  final String? name;
  final String? change;
  final String? type;
  final String? investmentValue;
  final num? quantity;
  final num? changesPercentage;
  dynamic isAlertAdded;
  dynamic isWatchlistAdded;
  //extra
  final String? mktCap;
  final String? dayLow;
  final String? dayHigh;
  final String? yearLow;
  final String? yearHigh;
  final String? priceAvg50;
  final String? priceAvg200;
  final String? exchange;
  final String? volume;
  final String? avgVolume;
  final String? open;
  final String? previousClose;
  final String? eps;
  final num? pe;
  final String? earningsAnnouncement;
  final String? sharesOutstanding;
  final num? overallPercent;
  final num? fundamentalPercent;
  final num? shortTermPercent;
  final num? longTermPercent;
  final num? valuationPercent;
  final num? analystRankingPercent;
  final num? sentimentPercent;

  BaseTickerRes({
    this.id,
    this.symbol,
    this.price,
    this.image,
    this.investmentValue,
    this.type,
    this.quantity,
    this.name,
    this.change,
    this.changesPercentage,
    this.isAlertAdded,
    this.isWatchlistAdded,
    //extra
    this.mktCap,
    this.dayLow,
    this.dayHigh,
    this.yearLow,
    this.yearHigh,
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
    this.overallPercent,
    this.fundamentalPercent,
    this.shortTermPercent,
    this.longTermPercent,
    this.valuationPercent,
    this.analystRankingPercent,
    this.sentimentPercent,
  });

  factory BaseTickerRes.fromJson(Map<String, dynamic> json) => BaseTickerRes(
        id: json["_id"],
        symbol: json["symbol"],
        quantity: json['quantity'],
        type: json['type'],
        investmentValue: json['investment_value'],
        price: json["price"],
        image: json["image"],
        name: json["name"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],
        //extra
        mktCap: json["mktCap"],
        dayLow: json["dayLow"],
        dayHigh: json["dayHigh"],
        yearLow: json["yearLow"],
        yearHigh: json["yearHigh"],
        priceAvg50: json["priceAvg50"],
        priceAvg200: json["priceAvg200"],
        exchange: json["exchange_short_name"],
        volume: json["volume"],
        avgVolume: json["avgVolume"],
        open: json["open"],
        previousClose: json["previousClose"],
        eps: json["eps"],
        pe: json["pe"],
        earningsAnnouncement: json["earningsAnnouncement"],
        sharesOutstanding: json["sharesOutstanding"],
        overallPercent: json["overall_percent"],
        fundamentalPercent: json["fundamental_percent"],
        shortTermPercent: json["short_term_percent"],
        longTermPercent: json["long_term_percent"],
        valuationPercent: json["valuation_percent"],
        analystRankingPercent: json["analyst_ranking_percent"],
        sentimentPercent: json["sentiment_percent"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "symbol": symbol,
        "price": price,
        'quantity': quantity,
        "image": image,
        'investment_value': investmentValue,
        'type': type,
        "name": name,
        "change": change,
        "changesPercentage": changesPercentage,
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
        //extra
        "mktCap": mktCap,
        "dayLow": dayLow,
        "dayHigh": dayHigh,
        "yearLow": yearLow,
        "yearHigh": yearHigh,
        "priceAvg50": priceAvg50,
        "priceAvg200": priceAvg200,
        "exchange_short_name": exchange,
        "volume": volume,
        "avgVolume": avgVolume,
        "open": open,
        "previousClose": previousClose,
        "eps": eps,
        "pe": pe,
        "earningsAnnouncement": earningsAnnouncement,
        "sharesOutstanding": sharesOutstanding,
        "overall_percent": overallPercent,
        "fundamental_percent": fundamentalPercent,
        "short_term_percent": shortTermPercent,
        "long_term_percent": longTermPercent,
        "valuation_percent": valuationPercent,
        "analyst_ranking_percent": analystRankingPercent,
        "sentiment_percent": sentimentPercent,
      };
}

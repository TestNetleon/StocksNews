import 'dart:convert';

List<BaseTickerRes> baseTickerResFromJson(String str) =>
    List<BaseTickerRes>.from(
        json.decode(str).map((x) => BaseTickerRes.fromJson(x)));

String baseTickerResToJson(List<BaseTickerRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BaseTickerRes {
  final String? id;
  final String? symbol;
  final String? displayPrice;
  final String? displayChange;
  final num? changesPercentage;
  final String? image;
  final String? name;
  final String? type;
  final String? investmentValue;
  final num? quantity;
  final num? mentionCount;
  final String? mentionDate;
  int? isAlertAdded;
  int? isWatchlistAdded;
  //extra
  final String? revenue;
  final String? employeeCount;
  final bool? showMore;
  final String? closeDate;
  final String? shareUrl;
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
  final String? pe;
  final String? earningsAnnouncement;
  final String? sharesOutstanding;
  final num? overallPercent;
  final num? fundamentalPercent;
  final num? shortTermPercent;
  final num? longTermPercent;
  final num? valuationPercent;
  final num? analystRankingPercent;
  final num? sentimentPercent;
  final List<AdditionalInfoRes>? additionalInfo;

  BaseTickerRes({
    this.id,
    this.symbol,
    this.displayPrice,
    this.displayChange,
    this.changesPercentage,
    this.image,
    this.investmentValue,
    this.type,
    this.quantity,
    this.name,
    this.isAlertAdded,
    this.isWatchlistAdded,
    this.mentionCount,
    this.mentionDate,

    //extra
    this.revenue,
    this.employeeCount,
    this.showMore,
    this.closeDate,
    this.shareUrl,
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
    this.additionalInfo,
  });

  factory BaseTickerRes.fromJson(Map<String, dynamic> json) => BaseTickerRes(
        id: json["_id"],
        symbol: json["symbol"],
        quantity: json['quantity'],
        type: json['type'],
        investmentValue: json['investment_value'],
        displayPrice: json["display_price"],
        displayChange: json["display_change"],
        changesPercentage: json["changesPercentage"],
        image: json["image"],
        name: json["name"],
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],
        mentionCount: json["mention_count"],
        mentionDate: json["mention_date"],

        //extra
        revenue: json['revenue'],
        employeeCount: json['employee_count'],
        showMore: json['show_more'],
        shareUrl: json['share_url'],
        closeDate: json['closeDate'],
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
        additionalInfo: json["additional_info"] == null
            ? []
            : List<AdditionalInfoRes>.from(json["additional_info"]!
                .map((x) => AdditionalInfoRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "symbol": symbol,
        "display_price": displayPrice,
        'quantity': quantity,
        "image": image,
        'investment_value': investmentValue,
        'type': type,
        "name": name,
        "display_change": displayChange,
        "changesPercentage": changesPercentage,
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
        "mention_count": mentionCount,
        "mention_date": mentionDate,

        //extra
        'revenue': revenue,
        'employee_count': employeeCount,
        'show_more': showMore,
        'share_url': shareUrl,
        'closeDate': closeDate,
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
        "additional_info": additionalInfo == null
            ? []
            : List<dynamic>.from(additionalInfo!.map((x) => x.toJson())),
      };
}

class AdditionalInfoRes {
  final String? title;
  final String? value;

  AdditionalInfoRes({
    this.title,
    this.value,
  });

  factory AdditionalInfoRes.fromJson(Map<String, dynamic> json) =>
      AdditionalInfoRes(
        title: json["title"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": title,
        "value": value,
      };
}

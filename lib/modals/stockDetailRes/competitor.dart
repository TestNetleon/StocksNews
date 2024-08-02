import 'dart:convert';

SdCompetitorRes sdCompetitorResFromJson(String str) =>
    SdCompetitorRes.fromJson(json.decode(str));

String sdCompetitorResToJson(SdCompetitorRes data) =>
    json.encode(data.toJson());

class SdCompetitorRes {
  final List<TickerList> tickerList;

  SdCompetitorRes({
    required this.tickerList,
  });

  factory SdCompetitorRes.fromJson(Map<String, dynamic> json) =>
      SdCompetitorRes(
        tickerList: List<TickerList>.from(
            json["ticker_list"].map((x) => TickerList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ticker_list": List<dynamic>.from(tickerList.map((x) => x.toJson())),
      };
}

class TickerList {
  final dynamic symbol;
  final dynamic image;
  final dynamic company;
  final dynamic price;
  final dynamic mktCap;
  final dynamic pe;
  final dynamic fullTimeEmployees;
  final dynamic revenue;
  final dynamic rating;
  num? isAlertAdded;
  num? isWatchlistAdded;

  TickerList({
    required this.symbol,
    required this.image,
    required this.company,
    required this.price,
    required this.mktCap,
    required this.pe,
    required this.fullTimeEmployees,
    required this.revenue,
    required this.rating,
    this.isAlertAdded,
    this.isWatchlistAdded,
  });

  factory TickerList.fromJson(Map<String, dynamic> json) => TickerList(
        symbol: json["symbol"],
        image: json["image"],
        company: json["company"],
        price: json["price"],
        mktCap: json["mktCap"],
        pe: json["pe"],
        fullTimeEmployees: json["fullTimeEmployees"],
        revenue: json["revenue"],
        rating: json["rating"],
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "image": image,
        "company": company,
        "price": price,
        "mktCap": mktCap,
        "pe": pe,
        "fullTimeEmployees": fullTimeEmployees,
        "revenue": revenue,
        "rating": rating,
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
      };
}

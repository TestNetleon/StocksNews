import 'dart:convert';

List<HighLowBetaStocksRes> highLowBetaStocksResFromJson(String str) =>
    List<HighLowBetaStocksRes>.from(
        json.decode(str).map((x) => HighLowBetaStocksRes.fromJson(x)));

String highLowBetaStocksResToJson(List<HighLowBetaStocksRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HighLowBetaStocksRes {
  final dynamic symbol;
  final dynamic name;
  final dynamic price;
  final dynamic beta;
  final dynamic pe;
  final dynamic marketCap;
  final dynamic volume;
  final dynamic avgVolume;
  final dynamic image;
  final dynamic change;
  final dynamic changesPercentage;
  num? isAlertAdded;
  num? isWatchlistAdded;

  HighLowBetaStocksRes({
    this.symbol,
    this.name,
    this.price,
    this.beta,
    this.pe,
    this.marketCap,
    this.volume,
    this.avgVolume,
    this.image,
    required this.change,
    this.changesPercentage,
    this.isAlertAdded,
    this.isWatchlistAdded,
  });

  factory HighLowBetaStocksRes.fromJson(Map<String, dynamic> json) =>
      HighLowBetaStocksRes(
        symbol: json["symbol"],
        name: json["name"],
        price: json["price"],
        beta: json["beta"],
        pe: json["pe"],
        marketCap: json["marketCap"],
        volume: json["volume"],
        avgVolume: json["avgVolume"],
        image: json["image"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "price": price,
        "beta": beta,
        "pe": pe,
        "marketCap": marketCap,
        "volume": volume,
        "avgVolume": avgVolume,
        "image": image,
        "change": change,
        "changesPercentage": changesPercentage,
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
      };
}

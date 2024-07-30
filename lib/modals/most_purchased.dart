import 'dart:convert';

List<MostPurchasedRes> mostPurchasedResFromJson(String str) =>
    List<MostPurchasedRes>.from(
        json.decode(str).map((x) => MostPurchasedRes.fromJson(x)));

String mostPurchasedResToJson(List<MostPurchasedRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MostPurchasedRes {
  final String? symbol;
  final String? name;
  final String? image;
  final String? price;
  final String? change;
  final num? changesPercentage;
  num? isAlertAdded;
  num? isWatchlistAdded;

  MostPurchasedRes({
    this.symbol,
    this.name,
    this.image,
    this.price,
    this.change,
    this.changesPercentage,
    this.isAlertAdded,
    this.isWatchlistAdded,
  });

  factory MostPurchasedRes.fromJson(Map<String, dynamic> json) =>
      MostPurchasedRes(
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "image": image,
        "price": price,
        "change": change,
        "changesPercentage": changesPercentage,
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
      };
}

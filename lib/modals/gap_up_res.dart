import 'dart:convert';

List<GapUpRes> gapUpResFromJson(String str) =>
    List<GapUpRes>.from(json.decode(str).map((x) => GapUpRes.fromJson(x)));

String gapUpResToJson(List<GapUpRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GapUpRes {
  final dynamic symbol;
  final dynamic name;
  final dynamic gapPer;
  final dynamic open;
  final dynamic previousClose;
  final dynamic price;
  final dynamic change;
  final dynamic changePercentage;
  final dynamic priceChangeSinceOpen;
  final dynamic volume;
  final dynamic image;
  final dynamic changesPercentage;
  num? isAlertAdded;
  num? isWatchlistAdded;
  // final dynamic change;

  GapUpRes({
    required this.symbol,
    required this.name,
    required this.gapPer,
    required this.open,
    required this.previousClose,
    required this.price,
    this.change,
    this.changePercentage,
    required this.priceChangeSinceOpen,
    required this.volume,
    required this.image,
    required this.changesPercentage,
    this.isAlertAdded,
    this.isWatchlistAdded,
    // required this.change,
  });

  factory GapUpRes.fromJson(Map<String, dynamic> json) => GapUpRes(
        symbol: json["symbol"],
        name: json["name"],
        gapPer: json["gap_per"],
        open: json["open"],
        previousClose: json["previousClose"],
        price: json["price"],
        priceChangeSinceOpen: json["priceChangeSinceOpen"],
        volume: json["volume"],
        image: json["image"],
        changesPercentage: json["changesPercentage"],
        change: json["change"],
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "gap_per": gapPer,
        "open": open,
        "previousClose": previousClose,
        "price": price,
        "priceChangeSinceOpen": priceChangeSinceOpen,
        "volume": volume,
        "image": image,
        "changesPercentage": changesPercentage,
        "change": change,
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
      };
}

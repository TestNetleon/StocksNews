import 'dart:convert';

List<GapUpRes> gapUpResFromJson(String str) =>
    List<GapUpRes>.from(json.decode(str).map((x) => GapUpRes.fromJson(x)));

String gapUpResToJson(List<GapUpRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GapUpRes {
  final String symbol;
  final String name;
  final String gapPer;
  final double open;
  final double previousClose;
  final String price;
  final String priceChangeSinceOpen;
  final String volume;
  final String image;

  GapUpRes({
    required this.symbol,
    required this.name,
    required this.gapPer,
    required this.open,
    required this.previousClose,
    required this.price,
    required this.priceChangeSinceOpen,
    required this.volume,
    required this.image,
  });

  factory GapUpRes.fromJson(Map<String, dynamic> json) => GapUpRes(
        symbol: json["symbol"],
        name: json["name"],
        gapPer: json["gap_per"],
        open: json["open"]?.toDouble(),
        previousClose: json["previousClose"]?.toDouble(),
        price: json["price"],
        priceChangeSinceOpen: json["priceChangeSinceOpen"],
        volume: json["volume"],
        image: json["image"],
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
      };
}

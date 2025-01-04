import 'dart:convert';

List<SearchRes> searchResFromJson(String str) =>
    List<SearchRes>.from(json.decode(str).map((x) => SearchRes.fromJson(x)));

String searchResToJson(List<SearchRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchRes {
  final String symbol;
  final String name;
  final String? image;
  final num? currentPrice;
//
  SearchRes({
    required this.symbol,
    required this.name,
    this.image,
    this.currentPrice,
  });

  factory SearchRes.fromJson(Map<String, dynamic> json) => SearchRes(
      symbol: json["symbol"],
      name: json["name"],
      image: json["image"],
      currentPrice: json['current_price']);

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "image": image,
        'current_price': currentPrice,
      };
}

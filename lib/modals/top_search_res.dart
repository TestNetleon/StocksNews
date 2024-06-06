import 'dart:convert';

List<TopSearch> topSearchFromJson(String str) =>
    List<TopSearch>.from(json.decode(str).map((x) => TopSearch.fromJson(x)));

String topSearchToJson(List<TopSearch> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TopSearch {
  final String symbol;
  final String name;
  final String image;
  final String price;
  final num changes;
//
  TopSearch({
    required this.symbol,
    required this.name,
    required this.image,
    required this.price,
    required this.changes,
  });

  factory TopSearch.fromJson(Map<String, dynamic> json) => TopSearch(
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        changes: json["changes"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "image": image,
        "price": price,
        "changes": changes,
      };
}

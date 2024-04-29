import 'dart:convert';

List<SearchRes> searchResFromJson(String str) =>
    List<SearchRes>.from(json.decode(str).map((x) => SearchRes.fromJson(x)));

String searchResToJson(List<SearchRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchRes {
  final String id;
  final String symbol;
  final String name;
//
  SearchRes({
    required this.id,
    required this.symbol,
    required this.name,
  });

  factory SearchRes.fromJson(Map<String, dynamic> json) => SearchRes(
        id: json["_id"],
        symbol: json["symbol"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "symbol": symbol,
        "name": name,
      };
}

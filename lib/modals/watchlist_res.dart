import 'dart:convert';

WatchlistRes watchlistResFromJson(String str) =>
    WatchlistRes.fromJson(json.decode(str));

String watchlistResToJson(WatchlistRes data) => json.encode(data.toJson());

class WatchlistRes {
  // final num currentPage;
  final List<WatchlistData> data;
  final num lastPage;

  WatchlistRes({
    // required this.currentPage,
    required this.data,
    required this.lastPage,
  });
//
  factory WatchlistRes.fromJson(Map<String, dynamic> json) => WatchlistRes(
        // currentPage: json["current_page"],
        data: List<WatchlistData>.from(
            json["data"].map((x) => WatchlistData.fromJson(x))),
        lastPage: json["last_page"],
      );

  Map<String, dynamic> toJson() => {
        // "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "last_page": lastPage,
      };
}

class WatchlistData {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final String price;
  final num changes;
  final String displayChange;
  final num changesPercentage;
  // final DateTime updatedAt;
  // final DateTime createdAt;

  WatchlistData({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.price,
    required this.changes,
    required this.displayChange,
    required this.changesPercentage,
    // required this.updatedAt,
    // required this.createdAt,
  });

  factory WatchlistData.fromJson(Map<String, dynamic> json) => WatchlistData(
        id: json["_id"],
        symbol: json["symbol"],
        name: json["name"],
        displayChange: json["display_change"],
        changesPercentage: json["changesPercentage"],
        image: json["image"],
        price: json["price"],
        changes: json["changes"],
        // updatedAt: DateTime.parse(json["updated_at"]),
        // createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "symbol": symbol,
        "name": name,
        "display_change": displayChange,
        "changesPercentage": changesPercentage,
        "image": image,
        "price": price,
        "changes": changes,
        // "updated_at": updatedAt.toIso8601String(),
        // "created_at": createdAt.toIso8601String(),
      };
}

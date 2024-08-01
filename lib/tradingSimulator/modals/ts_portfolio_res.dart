import 'dart:convert';

List<TsPortfolioRes> tsPortfolioResFromJson(String str) =>
    List<TsPortfolioRes>.from(
        json.decode(str).map((x) => TsPortfolioRes.fromJson(x)));

String tsPortfolioResToJson(List<TsPortfolioRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TsPortfolioRes {
  final dynamic id;
  final dynamic userId;
  final dynamic symbol;
  final dynamic quantity;
  final dynamic price;
  final dynamic totalAmount;
  final dynamic image;
  // final DateTime createdAt;
  // final DateTime updatedAt;

  TsPortfolioRes({
    required this.id,
    required this.userId,
    required this.symbol,
    required this.quantity,
    required this.price,
    required this.totalAmount,
    required this.image,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory TsPortfolioRes.fromJson(Map<String, dynamic> json) => TsPortfolioRes(
        id: json["id"],
        userId: json["user_id"],
        symbol: json["symbol"],
        quantity: json["quantity"],
        price: json["price"],
        totalAmount: json["total_amount"],
        image: json["image"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "symbol": symbol,
        "quantity": quantity,
        "price": price,
        "total_amount": totalAmount,
        "image": image,
        // "created_at": createdAt.toIso8601String(),
        // "updated_at": updatedAt.toIso8601String(),
      };
}

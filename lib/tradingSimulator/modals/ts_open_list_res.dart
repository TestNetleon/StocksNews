import 'dart:convert';

List<TsOpenListRes> tsOpenListResFromJson(String str) =>
    List<TsOpenListRes>.from(
        json.decode(str).map((x) => TsOpenListRes.fromJson(x)));

String tsOpenListResToJson(List<TsOpenListRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TsOpenListRes {
  final dynamic symbol;
  final dynamic quantity;
  final dynamic price;
  final dynamic totalAmount;
  final dynamic currentAmountOfShare;
  final dynamic percentChangeLoss;
  final dynamic image;
  // final DateTime createdAt;
  // final DateTime updatedAt;

  TsOpenListRes({
    required this.symbol,
    required this.quantity,
    required this.price,
    required this.totalAmount,
    required this.currentAmountOfShare,
    required this.percentChangeLoss,
    required this.image,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory TsOpenListRes.fromJson(Map<String, dynamic> json) => TsOpenListRes(
        symbol: json["symbol"],
        quantity: json["quantity"],
        price: json["price"],
        totalAmount: json["total_amount"],
        currentAmountOfShare: json["current_amount_of_share"],
        percentChangeLoss: json["percent_change_loss"],
        image: json["image"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "quantity": quantity,
        "price": price,
        "total_amount": totalAmount,
        "current_amount_of_share": currentAmountOfShare,
        "percent_change_loss": percentChangeLoss,
        "image": image,
        // "created_at": createdAt.toIso8601String(),
        // "updated_at": updatedAt.toIso8601String(),
      };
}









// import 'dart:convert';

// List<TsOpenListRes> tsOpenListResFromJson(String str) =>
//     List<TsOpenListRes>.from(
//         json.decode(str).map((x) => TsOpenListRes.fromJson(x)));

// String tsOpenListResToJson(List<TsOpenListRes> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class TsOpenListRes {
//   final String? id;
//   final String? userId;
//   final String? symbol;
//   final double? currentPrice;
//   final dynamic purchaseType;
//   final dynamic totalShare;
//   final String? orderType;
//   final dynamic totalAmount;
//   final dynamic image;
//   // final DateTime? updatedAt;
//   // final DateTime? createdAt;

//   TsOpenListRes({
//     required this.id,
//     required this.userId,
//     required this.symbol,
//     required this.currentPrice,
//     required this.purchaseType,
//     required this.totalShare,
//     required this.orderType,
//     required this.totalAmount,
//     required this.image,
//     // required this.updatedAt,
//     // required this.createdAt,
//   });

//   factory TsOpenListRes.fromJson(Map<String, dynamic> json) => TsOpenListRes(
//         id: json["_id"],
//         userId: json["user_id"],
//         symbol: json["symbol"],
//         currentPrice: json["current_price"],
//         purchaseType: json["purchase_type"],
//         totalShare: json["total_share"],
//         orderType: json["order_type"],
//         totalAmount: json["total_amount"],
//         image: json["image"],
//         // updatedAt: DateTime.parse(json["updated_at"]),
//         // createdAt: DateTime.parse(json["created_at"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "user_id": userId,
//         "symbol": symbol,
//         "current_price": currentPrice,
//         "purchase_type": purchaseType,
//         "total_share": totalShare,
//         "order_type": orderType,
//         "total_amount": totalAmount,
//         "image": image,
//         // "updated_at": updatedAt.toIso8601String(),
//         // "created_at": createdAt.toIso8601String(),
//       };
// }

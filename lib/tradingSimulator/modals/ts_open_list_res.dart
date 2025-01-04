import 'dart:convert';

List<TsOpenListRes> tsOpenListResFromJson(String str) =>
    List<TsOpenListRes>.from(
        json.decode(str).map((x) => TsOpenListRes.fromJson(x)));

String tsOpenListResToJson(List<TsOpenListRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TsOpenListRes {
  final String? symbol;
  final num? quantity;
  num? currentPrice;
  final num? invested;
  num? currentInvested;
  num? investedChange;
  num? investedChangePercentage;
  final String? image;
  num? change;
  num? changesPercentage;
  final String? company;
  final String? avgPrice;

  TsOpenListRes({
    this.symbol,
    this.quantity,
    this.currentPrice,
    this.invested,
    this.currentInvested,
    this.investedChange,
    this.investedChangePercentage,
    this.image,
    this.change,
    this.changesPercentage,
    this.company,
    this.avgPrice,
  });

  factory TsOpenListRes.fromJson(Map<String, dynamic> json) => TsOpenListRes(
        symbol: json["symbol"],
        avgPrice: json['average_price'],
        quantity: json["quantity"],
        currentPrice: json["currentPrice"],
        invested: json["total_invested"],
        currentInvested: json['current_invested'],
        investedChange: json['invested_change'],
        investedChangePercentage: json['invested_change_percentage'],
        image: json["image"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
        company: json["company"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "quantity": quantity,
        "currentPrice": currentPrice,
        "total_invested": invested,
        "image": image,
        "change": change,
        "changesPercentage": changesPercentage,
        "company": company,
        "average_price": avgPrice,
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

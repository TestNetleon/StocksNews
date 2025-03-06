import 'dart:convert';

List<TsOpenListRes> tsOpenListResFromJson(String str) =>
    List<TsOpenListRes>.from(
        json.decode(str).map((x) => TsOpenListRes.fromJson(x)));

String tsOpenListResToJson(List<TsOpenListRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


TsOpenRes tsOpenResFromMap(String str) => TsOpenRes.fromMap(json.decode(str));

String tsOpenResToMap(TsOpenRes data) => json.encode(data.toMap());


class TsOpenRes {
  final String? title;
  final String? subTitle;
  final bool? isTradeExecutable;
  final bool? totalResults;
  final DateTime? reponseTime;
  final List<TsOpenListRes>? data;

  TsOpenRes({
    this.title,
    this.subTitle,
    this.isTradeExecutable,
    this.totalResults,
    this.reponseTime,
    this.data,
  });

  factory TsOpenRes.fromMap(Map<String, dynamic> json) => TsOpenRes(
    title: json["title"],
    subTitle: json["sub_title"],
    isTradeExecutable: json["is_trade_executable"],
    totalResults: json["total_results"],
    reponseTime: json["reponse_time"] == null ? null : DateTime.parse(json["reponse_time"]),
    data: json["data"] == null ? [] : List<TsOpenListRes>.from(json["data"]!.map((x) => TsOpenListRes.fromJson(x))),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "sub_title": subTitle,
    "is_trade_executable": isTradeExecutable,
    "total_results": totalResults,
    "reponse_time": reponseTime?.toIso8601String(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class TsOpenListRes {
  final int? id;
  final String? symbol;
  num? quantity;
  num? currentPrice;
  num? invested;
  num? currentInvested;
  num? investedChange;
  num? investedChangePercentage;
  final String? image;
  num? change;
  num? changesPercentage;
  final String? company;
  num? avgPrice;
  DateTime? createdAt;
  final bool? executable;
  num? previousClose;
  final String? tradeType;
  final num? targetPrice;
  final num? stopPrice;
  final num? limitPrice;
  final String? orderTypeOriginal;
  final String? orderType;
  final num? portfolioTradeType;

  TsOpenListRes({
    this.id,
    this.tradeType,
    this.symbol,
    this.previousClose,
    this.executable,
    this.createdAt,
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
    this.targetPrice,
    this.stopPrice,
    this.limitPrice,
    this.orderTypeOriginal,
    this.orderType,
    this.portfolioTradeType,
  });

  factory TsOpenListRes.fromJson(Map<String, dynamic> json) => TsOpenListRes(
        symbol: json["symbol"],
        id: json['id'],
        tradeType: json['trade_type'],
        previousClose: json['previous_close'],
        executable: json['is_trade_executable'],
        avgPrice: json['average_price'],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
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
        targetPrice: json["target_price"],
        stopPrice: json["stop_price"],
    limitPrice: json["limit_price"],
        orderTypeOriginal: json["order_type_original"],
        orderType: json["order_type"],
    portfolioTradeType: json["portfolio_trade_type"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        'id': id,
        'trade_type': tradeType,
        'previous_close': previousClose,
        'is_trade_executable': executable,
        "quantity": quantity,
        "currentPrice": currentPrice,
        "total_invested": invested,
        "image": image,
        "created_at": createdAt,
        "change": change,
        "changesPercentage": changesPercentage,
        "company": company,
        "average_price": avgPrice,
        "target_price": targetPrice,
        "limit_price": limitPrice,
        "stop_price": stopPrice,
        "order_type_original": orderTypeOriginal,
        "order_type": orderType,
        "portfolio_trade_type": portfolioTradeType,
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



    //  symbol: json["symbol"],
    //     previousClose: json['previous_close'],
    //     avgPrice: json['average_price'],
    //     currentPrice: json["currentPrice"],
    //     currentInvested: json['current_invested'],
    //     investedChange: json['invested_change'],
    //     investedChangePercentage: json['invested_change_percentage'],
    //     change: json["change"],
    //     changesPercentage: json["changesPercentage"],


   
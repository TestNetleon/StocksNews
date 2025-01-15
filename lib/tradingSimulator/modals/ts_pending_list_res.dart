import 'dart:convert';

List<TsPendingListRes> tsPendingListResFromJson(String str) =>
    List<TsPendingListRes>.from(
        json.decode(str).map((x) => TsPendingListRes.fromJson(x)));

String tsPendingListResToJson(List<TsPendingListRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TsPendingListRes {
  final num? id;
  final String? symbol;
  final String? company;
  final String? image;
  final String? price;
  final num? quantity;
  final String? tradeType;
  // final Types orderType;
  final String? orderType;
  num? currentPrice;
  final String? tradeStatus;
  final String? investedValue;
  final String? date;
  num? change;
  num? changesPercentage;

  TsPendingListRes({
    this.change,
    this.changesPercentage,
    this.id,
    this.symbol,
    this.company,
    this.image,
    this.price,
    this.quantity,
    this.tradeType,
    this.orderType,
    this.currentPrice,
    this.tradeStatus,
    this.investedValue,
    this.date,
  });

  factory TsPendingListRes.fromJson(Map<String, dynamic> json) =>
      TsPendingListRes(
        symbol: json["symbol"],
        id: json['id'],
        investedValue: json['invested_value'],
        company: json["company"],
        image: json["image"],
        price: json["price"],
        quantity: json["quantity"],
        tradeType: json["trade_type"],
        tradeStatus: json['trade_status'],
        // orderType: Types.fromJson(json["order_type"]),
        orderType: json['order_type'],
        currentPrice: json['currentPrice'],
        date: json['updated_at'],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        'id': id,
        "company": company,
        "image": image,
        'invested_value': investedValue,
        "price": price,
        'trade_status': tradeStatus,
        "quantity": quantity,
        "trade_type": tradeType,
        // "order_type": orderType.toJson(),
        "order_type": orderType,
        "currentPrice": currentPrice,
        "updated_at": date,
        "change": change,
        "changesPercentage": changesPercentage,
      };
}

// class OrderType {

// class Types {
//   final OrderType limitOrder;
//   final OrderType targetPrice;
//   final OrderType stopLoss;

//   Types({
//     required this.limitOrder,
//     required this.targetPrice,
//     required this.stopLoss,
//   });

//   factory Types.fromJson(Map<String, dynamic> json) => Types(
//         limitOrder: OrderType.fromJson(json["limit_order"]),
//         targetPrice: OrderType.fromJson(json["target_price"]),
//         stopLoss: OrderType.fromJson(json["stop_loss"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "limit_order": limitOrder.toJson(),
//         "target_price": targetPrice.toJson(),
//         "stop_loss": stopLoss.toJson(),
//       };
// }

// class OrderType {
//   final bool status;
//   final dynamic price;

//   OrderType({
//     required this.status,
//     required this.price,
//   });

//   factory OrderType.fromJson(Map<String, dynamic> json) => OrderType(
//         status: json["status"],
//         price: json["price"],
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "price": price,
//       };
// }

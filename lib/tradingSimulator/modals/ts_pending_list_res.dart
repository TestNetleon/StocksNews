import 'dart:convert';

List<TsPendingListRes> tsPendingListResFromJson(String str) =>
    List<TsPendingListRes>.from(
        json.decode(str).map((x) => TsPendingListRes.fromJson(x)));

String tsPendingListResToJson(List<TsPendingListRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TsPendingListRes {
  final dynamic symbol;
  final dynamic company;
  final dynamic image;
  final dynamic price;
  final dynamic quantity;
  final dynamic invested;
  final dynamic tradeType;
  final Types orderType;
  final dynamic currency;

  TsPendingListRes({
    required this.symbol,
    required this.company,
    required this.image,
    required this.price,
    required this.quantity,
    required this.invested,
    required this.tradeType,
    required this.orderType,
    required this.currency,
  });

  factory TsPendingListRes.fromJson(Map<String, dynamic> json) =>
      TsPendingListRes(
        symbol: json["symbol"],
        company: json["company"],
        image: json["image"],
        price: json["price"],
        quantity: json["quantity"],
        invested: json["invested"],
        tradeType: json["tradeType"],
        orderType: Types.fromJson(json["order_type"]),
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "company": company,
        "image": image,
        "price": price,
        "quantity": quantity,
        "invested": invested,
        "tradeType": tradeType,
        "order_type": orderType.toJson(),
        "currency": currency,
      };
}

// class OrderType {

class Types {
  final OrderType limitOrder;
  final OrderType targetPrice;
  final OrderType stopLoss;

  Types({
    required this.limitOrder,
    required this.targetPrice,
    required this.stopLoss,
  });

  factory Types.fromJson(Map<String, dynamic> json) => Types(
        limitOrder: OrderType.fromJson(json["limit_order"]),
        targetPrice: OrderType.fromJson(json["target_price"]),
        stopLoss: OrderType.fromJson(json["stop_loss"]),
      );

  Map<String, dynamic> toJson() => {
        "limit_order": limitOrder.toJson(),
        "target_price": targetPrice.toJson(),
        "stop_loss": stopLoss.toJson(),
      };
}

class OrderType {
  final bool status;
  final dynamic price;

  OrderType({
    required this.status,
    required this.price,
  });

  factory OrderType.fromJson(Map<String, dynamic> json) => OrderType(
        status: json["status"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "price": price,
      };
}

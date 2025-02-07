// import 'dart:convert';

// TsUserRes tsUserResFromJson(String str) => TsUserRes.fromJson(json.decode(str));

// String tsUserResToJson(TsUserRes data) => json.encode(data.toJson());

// class TsUserRes {
//   num tradeBalance;
//   num? investedValue;
//   num? invested;
//   num? currentPositionAmount;
//   num? todayReturn;
//   num? previousPosition;
//   TsUserRes({
//     required this.tradeBalance,
//     this.invested,
//     this.investedValue,
//     this.currentPositionAmount,
//     this.todayReturn,
//     this.previousPosition,
//   });

//   factory TsUserRes.fromJson(Map<String, dynamic> json) => TsUserRes(
//         tradeBalance: json["trade_balance"],
//         investedValue: json['invested_market_value'],
//         invested: json['invested_value'],
//         currentPositionAmount: json['current_position_amount'],
//         todayReturn: json['today_return'],
//         previousPosition: json['total_return_value'],
//       );

//   Map<String, dynamic> toJson() => {
//         "trade_balance": tradeBalance,
//         'invested_market_value': investedValue,
//         "invested_value": invested,
//         'current_position_amount': currentPositionAmount,
//         'today_return': todayReturn,
//         'previous_position': previousPosition,
//       };
// }

import 'dart:convert';

TsUserRes tsUserResFromJson(String str) => TsUserRes.fromJson(json.decode(str));

String tsUserResToJson(TsUserRes data) => json.encode(data.toJson());

class TsUserRes {
  num tradeBalance;
  num? investedAmount;
  num? marketValue;
  num? totalReturn;
  num? todayReturn;
  num? totalPortfolioStateAmount;
  // num? staticTotalReturn;
  final UserConditionalOrderPermissionRes? userConditionalOrderPermission;
  final OrdersSubTitle? ordersSubTitle;
  final LabelInfoStrings? labelInfoStrings;

  TsUserRes({
    required this.tradeBalance,
    this.investedAmount,
    this.marketValue,
    this.totalReturn,
    this.todayReturn,
    this.totalPortfolioStateAmount,
    this.userConditionalOrderPermission,
    this.ordersSubTitle,
    this.labelInfoStrings,
    // this.staticTotalReturn,s
  });

  factory TsUserRes.fromJson(Map<String, dynamic> json) => TsUserRes(
        tradeBalance: json["trade_balance"],
        investedAmount: json['invested_amount'],
        marketValue: json['market_value'],
        totalReturn: json['total_return'],
        todayReturn: json['today_return'],
        totalPortfolioStateAmount: json['total_portfolio_state_amount'],
        userConditionalOrderPermission:
            json["user_conditional_order_permission"] == null
                ? null
                : UserConditionalOrderPermissionRes.fromMap(
                    json["user_conditional_order_permission"],
                  ),
        ordersSubTitle: json["orders_sub_title"] == null
            ? null
            : OrdersSubTitle.fromJson(json["orders_sub_title"]),
    labelInfoStrings: json["label_info_strings"] == null ? null : LabelInfoStrings.fromMap(json["label_info_strings"]),
      );

  Map<String, dynamic> toJson() => {
        "trade_balance": tradeBalance,
        'invested_amount': investedAmount,
        "market_value": marketValue,
        'total_return': totalReturn,
        'today_return': todayReturn,
        'total_portfolio_state_amount': totalPortfolioStateAmount,
        "user_conditional_order_permission":
            userConditionalOrderPermission?.toMap(),
        "orders_sub_title": ordersSubTitle?.toJson(),
    "label_info_strings": labelInfoStrings?.toMap(),
      };
}

class UserConditionalOrderPermissionRes {
  final bool? limitOrder;
  final bool? bracketOrder;
  final bool? stopOrder;
  final bool? trailingOrder;
  final bool? stopLimitOrder;
  final bool? recurringOrder;

  UserConditionalOrderPermissionRes({
    this.limitOrder,
    this.bracketOrder,
    this.stopOrder,
    this.trailingOrder,
    this.stopLimitOrder,
    this.recurringOrder,
  });

  factory UserConditionalOrderPermissionRes.fromMap(
          Map<String, dynamic> json) =>
      UserConditionalOrderPermissionRes(
        limitOrder: json["LIMIT_ORDER"],
        bracketOrder: json["BRACKET_ORDER"],
        stopOrder: json["STOP_ORDER"],
        trailingOrder: json["TRAILING_ORDER"],
        stopLimitOrder: json["STOP_LIMIT_ORDER"],
        recurringOrder: json["RECURRING_ORDER"],
      );

  Map<String, dynamic> toMap() => {
        "LIMIT_ORDER": limitOrder,
        "BRACKET_ORDER": bracketOrder,
        "STOP_ORDER": stopOrder,
        "TRAILING_ORDER": trailingOrder,
        "STOP_LIMIT_ORDER": stopLimitOrder,
        "RECURRING_ORDER": recurringOrder,
      };
}

class OrdersSubTitle {
  final String? buyOrder;
  final String? sellOrder;
  final String? shortOrder;
  final String? buyToCoverOrder;
  final String? bracketOrder;
  final String? limitOrder;
  final String? stopOrder;

  OrdersSubTitle({
    required this.buyOrder,
    required this.sellOrder,
    required this.shortOrder,
    required this.buyToCoverOrder,
    required this.bracketOrder,
    required this.limitOrder,
    required this.stopOrder,
  });

  factory OrdersSubTitle.fromJson(Map<String, dynamic> json) => OrdersSubTitle(
        buyOrder: json["buy_order"],
        sellOrder: json["sell_order"],
        shortOrder: json["short_order"],
        buyToCoverOrder: json["buy_to_cover_order"],
        bracketOrder: json["bracket_order"],
    limitOrder: json["limit_order"],
    stopOrder: json["stop_order"],
      );

  Map<String, dynamic> toJson() => {
        "buy_order": buyOrder,
        "sell_order": sellOrder,
        "short_order": shortOrder,
        "buy_to_cover_order": buyToCoverOrder,
        "bracket_order": bracketOrder,
        "limit_order": limitOrder,
        "stop_order": stopOrder,
      };
}

class LabelInfoStrings {
  final Buy? buy;
  final Buy? sell;
  final Buy? short;
  final Buy? buyToCover;

  LabelInfoStrings({
    this.buy,
    this.sell,
    this.short,
    this.buyToCover,
  });

  factory LabelInfoStrings.fromMap(Map<String, dynamic> json) => LabelInfoStrings(
    buy: json["buy"] == null ? null : Buy.fromMap(json["buy"]),
    sell: json["sell"] == null ? null : Buy.fromMap(json["sell"]),
    short: json["short"] == null ? null : Buy.fromMap(json["short"]),
    buyToCover: json["buy_to_cover"] == null ? null : Buy.fromMap(json["buy_to_cover"]),
  );

  Map<String, dynamic> toMap() => {
    "buy": buy?.toMap(),
    "sell": sell?.toMap(),
    "short": short?.toMap(),
    "buy_to_cover": buyToCover?.toMap(),
  };
}

class Buy {
  final BracketOrder? bracketOrder;
  final LimitOrder? limitOrder;
  final Order? stopOrder;
  final StopLimitOrder? stopLimitOrder;
  final Order? trailingOrder;

  Buy({
    this.bracketOrder,
    this.limitOrder,
    this.stopOrder,
    this.stopLimitOrder,
    this.trailingOrder,
  });

  factory Buy.fromMap(Map<String, dynamic> json) => Buy(
    bracketOrder: json["bracket_order"] == null ? null : BracketOrder.fromMap(json["bracket_order"]),
    limitOrder: json["limit_order"] == null ? null : LimitOrder.fromMap(json["limit_order"]),
    stopOrder: json["stop_order"] == null ? null : Order.fromMap(json["stop_order"]),
    stopLimitOrder: json["stop_limit_order"] == null ? null : StopLimitOrder.fromMap(json["stop_limit_order"]),
    trailingOrder: json["trailing_order"] == null ? null : Order.fromMap(json["trailing_order"]),
  );

  Map<String, dynamic> toMap() => {
    "bracket_order": bracketOrder?.toMap(),
    "limit_order": limitOrder?.toMap(),
    "stop_order": stopOrder?.toMap(),
    "stop_limit_order": stopLimitOrder?.toMap(),
    "trailing_order": trailingOrder?.toMap(),
  };
}

class BracketOrder {
  final String? stopPrice;
  final String? targetPrice;

  BracketOrder({
    this.stopPrice,
    this.targetPrice,
  });

  factory BracketOrder.fromMap(Map<String, dynamic> json) => BracketOrder(
    stopPrice: json["stop-price"],
    targetPrice: json["target-price"],
  );

  Map<String, dynamic> toMap() => {
    "stop-price": stopPrice,
    "target-price": targetPrice,
  };
}

class LimitOrder {
  final String? limitPrice;

  LimitOrder({
    this.limitPrice,
  });

  factory LimitOrder.fromMap(Map<String, dynamic> json) => LimitOrder(
    limitPrice: json["limit-price"],
  );

  Map<String, dynamic> toMap() => {
    "limit-price": limitPrice,
  };
}

class StopLimitOrder {
  final String? stopPrice;
  final String? limitPrice;

  StopLimitOrder({
    this.stopPrice,
    this.limitPrice,
  });

  factory StopLimitOrder.fromMap(Map<String, dynamic> json) => StopLimitOrder(
    stopPrice: json["stop-price"],
    limitPrice: json["limit-price"],
  );

  Map<String, dynamic> toMap() => {
    "stop-price": stopPrice,
    "limit-price": limitPrice,
  };
}

class Order {
  final String? stopPrice;

  Order({
    this.stopPrice,
  });

  factory Order.fromMap(Map<String, dynamic> json) => Order(
    stopPrice: json["stop-price"],
  );

  Map<String, dynamic> toMap() => {
    "stop-price": stopPrice,
  };
}
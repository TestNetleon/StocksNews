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

  TsUserRes({
    required this.tradeBalance,
    this.investedAmount,
    this.marketValue,
    this.totalReturn,
    this.todayReturn,
    this.totalPortfolioStateAmount,
    this.userConditionalOrderPermission,
    this.ordersSubTitle,
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

  OrdersSubTitle({
    required this.buyOrder,
    required this.sellOrder,
    required this.shortOrder,
    required this.buyToCoverOrder,
    required this.bracketOrder,
  });

  factory OrdersSubTitle.fromJson(Map<String, dynamic> json) => OrdersSubTitle(
        buyOrder: json["buy_order"],
        sellOrder: json["sell_order"],
        shortOrder: json["short_order"],
        buyToCoverOrder: json["buy_to_cover_order"],
        bracketOrder: json["bracket_order"],
      );

  Map<String, dynamic> toJson() => {
        "buy_order": buyOrder,
        "sell_order": sellOrder,
        "short_order": shortOrder,
        "buy_to_cover_order": buyToCoverOrder,
        "bracket_order": bracketOrder,
      };
}

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
  // num? staticTotalReturn;
  final UserConditionalOrderPermissionRes? userConditionalOrderPermission;
  TsUserRes({
    required this.tradeBalance,
    this.investedAmount,
    this.marketValue,
    this.totalReturn,
    this.todayReturn,
    this.userConditionalOrderPermission,
    // this.staticTotalReturn,s
  });

  factory TsUserRes.fromJson(Map<String, dynamic> json) => TsUserRes(
        tradeBalance: json["trade_balance"],
        investedAmount: json['invested_amount'],
        marketValue: json['market_value'],
        totalReturn: json['total_return'],
        todayReturn: json['today_return'],
    userConditionalOrderPermission: json["user_conditional_order_permission"] == null ? null : UserConditionalOrderPermissionRes.fromMap(json["user_conditional_order_permission"])
  );

  Map<String, dynamic> toJson() => {
        "trade_balance": tradeBalance,
        'invested_amount': investedAmount,
        "market_value": marketValue,
        'total_return': totalReturn,
        'today_return': todayReturn,
    "user_conditional_order_permission": userConditionalOrderPermission?.toMap(),
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

  factory UserConditionalOrderPermissionRes.fromMap(Map<String, dynamic> json) => UserConditionalOrderPermissionRes(
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

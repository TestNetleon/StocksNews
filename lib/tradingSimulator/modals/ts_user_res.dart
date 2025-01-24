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
  TsUserRes({
    required this.tradeBalance,
    this.investedAmount,
    this.marketValue,
    this.totalReturn,
    this.todayReturn,
    // this.staticTotalReturn,s
  });

  factory TsUserRes.fromJson(Map<String, dynamic> json) => TsUserRes(
        tradeBalance: json["trade_balance"],
        investedAmount: json['invested_amount'],
        marketValue: json['market_value'],
        totalReturn: json['total_return'],
        todayReturn: json['today_return'],
      );

  Map<String, dynamic> toJson() => {
        "trade_balance": tradeBalance,
        'invested_amount': investedAmount,
        "market_value": marketValue,
        'total_return': totalReturn,
        'today_return': todayReturn,
      };
}

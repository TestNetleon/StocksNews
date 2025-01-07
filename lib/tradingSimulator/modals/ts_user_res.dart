import 'dart:convert';

TsUserRes tsUserResFromJson(String str) => TsUserRes.fromJson(json.decode(str));

String tsUserResToJson(TsUserRes data) => json.encode(data.toJson());

class TsUserRes {
  // final dynamic sqlId;
  num tradeBalance;
  num? investedValue;
  num? invested;
  num? currentPositionAmount;
  num? todayReturn;
  num? previousPosition;
  // DateTime? marketTime;
  String? timingInfo;
  TsUserRes({
    // required this.sqlId,
    required this.tradeBalance,
    this.invested,
    this.investedValue,
    this.currentPositionAmount,
    this.todayReturn,
    // this.marketTime,
    this.previousPosition,
    this.timingInfo,
  });

  factory TsUserRes.fromJson(Map<String, dynamic> json) => TsUserRes(
        // sqlId: json["mssql_id"],
        tradeBalance: json["trade_balance"],
        investedValue: json['invested_market_value'],
        invested: json['invested_value'],
        currentPositionAmount: json['current_position_amount'],
        todayReturn: json['today_return'],
        // marketTime: DateTime.parse(json["market_opening_date_time"]),
        previousPosition: json['total_return_value'],
        timingInfo: json['market_timing_info'],
      );

  Map<String, dynamic> toJson() => {
        // "mssql_id": sqlId,
        "trade_balance": tradeBalance,
        'invested_market_value': investedValue,
        "invested_value": invested,
        'current_position_amount': currentPositionAmount,
        'today_return': todayReturn,
        // 'market_opening_date_time': marketTime,
        'previous_position': previousPosition,
        'market_timing_info': timingInfo,
      };
}

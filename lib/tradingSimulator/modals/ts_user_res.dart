import 'dart:convert';

TsUserRes tsUserResFromJson(String str) => TsUserRes.fromJson(json.decode(str));

String tsUserResToJson(TsUserRes data) => json.encode(data.toJson());

class TsUserRes {
  final dynamic sqlId;
  num tradeBalance;
  num? invested;
  num? investedValue;
  num? currentPositionAmount;
  num? todayReturn;
  DateTime? marketTime;
  TsUserRes({
    required this.sqlId,
    required this.tradeBalance,
    this.invested,
    this.investedValue,
    this.currentPositionAmount,
    this.todayReturn,
    this.marketTime,
  });

  factory TsUserRes.fromJson(Map<String, dynamic> json) => TsUserRes(
        sqlId: json["mssql_id"],
        tradeBalance: json["trade_balance"],
        invested: json['invested_market_value'],
        investedValue: json['invested_value'],
        currentPositionAmount: json['current_position_amount'],
        todayReturn: json['today_return'],
        marketTime: DateTime.parse(json["market_opening_date_time"]),
      );

  Map<String, dynamic> toJson() => {
        "mssql_id": sqlId,
        "trade_balance": tradeBalance,
        'invested_market_value': invested,
        "invested_value": investedValue,
        'current_position_amount': currentPositionAmount,
        'today_return': todayReturn,
        'market_opening_date_time': marketTime,
      };
}

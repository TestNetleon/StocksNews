import 'dart:convert';

TsUserRes tsUserResFromJson(String str) => TsUserRes.fromJson(json.decode(str));

String tsUserResToJson(TsUserRes data) => json.encode(data.toJson());

class TsUserRes {
  final dynamic sqlId;
  num tradeBalance;
  num? invested;
  num? investedValue;
  num? currentPositionAmount;
  TsUserRes({
    required this.sqlId,
    required this.tradeBalance,
    this.invested,
    this.investedValue,
    this.currentPositionAmount,
  });

  factory TsUserRes.fromJson(Map<String, dynamic> json) => TsUserRes(
      sqlId: json["mssql_id"],
      tradeBalance: json["trade_balance"],
      invested: json['invested_market_value'],
      investedValue: json['invested_value'],
      currentPositionAmount: json['current_position_amount']);

  Map<String, dynamic> toJson() => {
        "mssql_id": sqlId,
        "trade_balance": tradeBalance,
        'invested_market_value': invested,
        "invested_value": investedValue,
        'current_position_amount': currentPositionAmount,
      };
}

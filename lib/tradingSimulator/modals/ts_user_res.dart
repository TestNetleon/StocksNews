import 'dart:convert';

TsUserRes tsUserResFromJson(String str) => TsUserRes.fromJson(json.decode(str));

String tsUserResToJson(TsUserRes data) => json.encode(data.toJson());

class TsUserRes {
  final dynamic sqlId;
  num tradeBalance;

  TsUserRes({
    required this.sqlId,
    required this.tradeBalance,
  });

  factory TsUserRes.fromJson(Map<String, dynamic> json) => TsUserRes(
        sqlId: json["mssql_id"],
        tradeBalance: json["trade_balance"],
      );

  Map<String, dynamic> toJson() => {
        "mssql_id": sqlId,
        "trade_balance": tradeBalance,
      };
}

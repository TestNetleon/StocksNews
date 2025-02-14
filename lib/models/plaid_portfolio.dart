import 'dart:convert';

import 'package:stocks_news_new/models/ticker.dart';

ToolsPortfolioRes toolsPortfolioResFromJson(String str) =>
    ToolsPortfolioRes.fromJson(json.decode(str));

String toolsPortfolioResToJson(ToolsPortfolioRes data) =>
    json.encode(data.toJson());

class ToolsPortfolioRes {
  final String? title;
  final List<BaseTickerRes>? data;
  final PortfolioBalanceBoxRes? balanceBox;

  ToolsPortfolioRes({
    this.title,
    this.data,
    this.balanceBox,
  });

  factory ToolsPortfolioRes.fromJson(Map<String, dynamic> json) =>
      ToolsPortfolioRes(
        title: json["title"],
        data: json["data"] == null
            ? []
            : List<BaseTickerRes>.from(
                json["data"]!.map((x) => BaseTickerRes.fromJson(x))),
        balanceBox: json["balance_box"] == null
            ? null
            : PortfolioBalanceBoxRes.fromJson(json["balance_box"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "balance_box": balanceBox?.toJson(),
      };
}

class PortfolioBalanceBoxRes {
  final String? text;
  final String? balance;
  final String? btnText;

  PortfolioBalanceBoxRes({
    this.text,
    this.balance,
    this.btnText,
  });

  factory PortfolioBalanceBoxRes.fromJson(Map<String, dynamic> json) =>
      PortfolioBalanceBoxRes(
        text: json["text"],
        balance: json["balance"],
        btnText: json["btn_text"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "balance": balance,
        "btn_text": btnText,
      };
}

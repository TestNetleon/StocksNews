import 'dart:convert';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/show_button_res.dart';

TickerDetailRes tournamentTickerDetailResFromJson(String str) =>
    TickerDetailRes.fromJson(json.decode(str));

String tournamentTickerDetailResToJson(TickerDetailRes data) =>
    json.encode(data.toJson());

class TickerDetailRes {
  final ShowButtonRes? showButton;
  final BaseTickerRes? ticker;

  TickerDetailRes({
    this.showButton,
    this.ticker,
  });

  factory TickerDetailRes.fromJson(Map<String, dynamic> json) =>
      TickerDetailRes(
        showButton: json["show_button"] == null
            ? null
            : ShowButtonRes.fromJson(json["show_button"]),
        ticker: json["ticker"] == null
            ? null
            : BaseTickerRes.fromJson(json["ticker"]),
      );

  Map<String, dynamic> toJson() => {
        "show_button": showButton?.toJson(),
        "ticker": ticker?.toJson(),
      };
}


import 'dart:convert';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/show_button_res.dart';

TournamentTickerDetailRes tournamentTickerDetailResFromJson(String str) =>
    TournamentTickerDetailRes.fromJson(json.decode(str));

String tournamentTickerDetailResToJson(TournamentTickerDetailRes data) =>
    json.encode(data.toJson());

class TournamentTickerDetailRes {
  final ShowButtonRes? showButton;
  final BaseTickerRes? ticker;

  TournamentTickerDetailRes({
    this.showButton,
    this.ticker,
  });

  factory TournamentTickerDetailRes.fromJson(Map<String, dynamic> json) =>
      TournamentTickerDetailRes(
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


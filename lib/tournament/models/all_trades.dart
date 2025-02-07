// To parse this JSON data, do
//
//     final tournamentAllTradesRes = tournamentAllTradesResFromJson(jsonString);

import 'dart:convert';

import '../../modals/stock_screener_res.dart';
import '../../tradingSimulator/modals/trading_search_res.dart';

TournamentAllTradesRes tournamentAllTradesResFromJson(String str) =>
    TournamentAllTradesRes.fromJson(json.decode(str));

String tournamentAllTradesResToJson(TournamentAllTradesRes data) =>
    json.encode(data.toJson());

class TournamentAllTradesRes {
  final List<KeyValueElementStockScreener>? overview;
  final List<TradingSearchTickerRes>? data;

  TournamentAllTradesRes({
    this.overview,
    this.data,
  });

  factory TournamentAllTradesRes.fromJson(Map<String, dynamic> json) =>
      TournamentAllTradesRes(
        overview: json["overview"] == null
            ? []
            : List<KeyValueElementStockScreener>.from(json["overview"]!
                .map((x) => KeyValueElementStockScreener.fromJson(x))),
        data: json["data"] == null
            ? []
            : List<TradingSearchTickerRes>.from(
                json["data"]!.map((x) => TradingSearchTickerRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "overview": overview == null
            ? []
            : List<dynamic>.from(overview!.map((x) => x.toJson())),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

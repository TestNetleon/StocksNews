import 'dart:convert';
import 'package:stocks_news_new/modals/stock_screener_res.dart';
import 'package:stocks_news_new/models/ticker.dart';


AllTradesRes allTradesResFromJson(String str) =>
    AllTradesRes.fromJson(json.decode(str));

String allTradesResToJson(AllTradesRes data) =>
    json.encode(data.toJson());

class AllTradesRes {
  final String? title;
  final String? subTitle;
  final int? totalPages;
  final List<KeyValueElementStockScreener>? overview;
  final List<BaseTickerRes>? data;
  final int? tournamentBattleId;

  AllTradesRes({
    this.title,
    this.subTitle,
    this.totalPages,
    this.overview,
    this.data,
    this.tournamentBattleId,
  });

  factory AllTradesRes.fromJson(Map<String, dynamic> json) =>
      AllTradesRes(
        title: json["title"],
        subTitle: json["sub_title"],
        totalPages: json["total_pages"],
        overview: json["overview"] == null
            ? []
            : List<KeyValueElementStockScreener>.from(json["overview"]!
                .map((x) => KeyValueElementStockScreener.fromJson(x))),
        data: json["data"] == null
            ? []
            : List<BaseTickerRes>.from(
                json["data"]!.map((x) => BaseTickerRes.fromJson(x))),
        tournamentBattleId: json["tournament_battle_id"],

      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "sub_title": subTitle,
    "total_pages": totalPages,
        "overview": overview == null
            ? []
            : List<dynamic>.from(overview!.map((x) => x.toJson())),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),

    "tournament_battle_id": tournamentBattleId,

  };
}


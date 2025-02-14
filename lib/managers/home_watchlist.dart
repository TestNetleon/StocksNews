import 'dart:convert';

import 'package:stocks_news_new/models/ticker.dart';

HomeWatchlistRes homeWatchlistResFromJson(String str) =>
    HomeWatchlistRes.fromJson(json.decode(str));

String homeWatchlistResToJson(HomeWatchlistRes data) =>
    json.encode(data.toJson());

class HomeWatchlistRes {
  final List<BaseTickerRes>? data;

  HomeWatchlistRes({
    this.data,
  });

  factory HomeWatchlistRes.fromJson(Map<String, dynamic> json) =>
      HomeWatchlistRes(
        data: json["data"] == null
            ? []
            : List<BaseTickerRes>.from(
                json["data"]!.map((x) => BaseTickerRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

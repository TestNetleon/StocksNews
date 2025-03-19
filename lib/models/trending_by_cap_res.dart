import 'dart:convert';

import 'package:stocks_news_new/models/ticker.dart';

TrendingByCapRes trendingByCapResFromJson(String str) =>
    TrendingByCapRes.fromJson(json.decode(str));

String trendingByCapResToJson(TrendingByCapRes data) =>
    json.encode(data.toJson());

class TrendingByCapRes {
  final List<MarketCapData> data;

  TrendingByCapRes({required this.data});

  factory TrendingByCapRes.fromJson(Map<String, dynamic> json) =>
      TrendingByCapRes(
        data: List<MarketCapData>.from(
            json["data"].map((x) => MarketCapData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class MarketCapData {
  final String? title;
  final String? subtitle;
  final String? noDataMessage;
  final List<BaseTickerRes>? data;

  MarketCapData({
    required this.title,
    required this.subtitle,
    required this.noDataMessage,
    required this.data,
  });

  factory MarketCapData.fromJson(Map<String, dynamic> json) => MarketCapData(
        title: json["title"],
        subtitle: json["subtitle"],
        noDataMessage: json["no_data_message"],
        data: json["data"] == null
            ? null
            : List<BaseTickerRes>.from(
                json["data"].map((x) => BaseTickerRes.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "no_data_message": noDataMessage,
        "data": data == null
            ? null
            : List<BaseTickerRes>.from(data!.map((x) => x.toJson())),
      };
}

import 'dart:convert';

import 'package:stocks_news_new/models/faq.dart';

SDAnalystForecastRes sdAnalysisResFromJson(String str) =>
    SDAnalystForecastRes.fromJson(json.decode(str));

String sdAnalysisResToJson(SDAnalystForecastRes data) =>
    json.encode(data.toJson());

class SDAnalystForecastRes {
  final String? title;
  final String? subTitle;
  final List<AnalystForecastRes>? analystForecasts;
  final List<BaseFaqRes>? faq;

  SDAnalystForecastRes({
    this.title,
    this.subTitle,
    this.analystForecasts,
    this.faq,
  });

  factory SDAnalystForecastRes.fromJson(Map<String, dynamic> json) =>
      SDAnalystForecastRes(
        title: json["title"],
        subTitle: json["sub_title"],
        analystForecasts: json["analyst_forecasts"] == null
            ? []
            : List<AnalystForecastRes>.from(json["analyst_forecasts"]!
                .map((x) => AnalystForecastRes.fromJson(x))),
        faq: json["faq"] == null
            ? []
            : List<BaseFaqRes>.from(
                json["faq"]!.map((x) => BaseFaqRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "analyst_forecasts": analystForecasts == null
            ? []
            : List<dynamic>.from(analystForecasts!.map((x) => x.toJson())),
        "faq":
            faq == null ? [] : List<dynamic>.from(faq!.map((x) => x.toJson())),
      };
}

class AnalystForecastRes {
  final String? date;
  final String? brokerage;
  final String? analystName;
  final String? priceTarget;
  final String? priceWhenPosted;
  final num? upDown;
  final String? newsUrl;

  AnalystForecastRes({
    this.date,
    this.brokerage,
    this.analystName,
    this.priceTarget,
    this.priceWhenPosted,
    this.upDown,
    this.newsUrl,
  });

  factory AnalystForecastRes.fromJson(Map<String, dynamic> json) =>
      AnalystForecastRes(
        date: json["date"],
        brokerage: json["brokerage"],
        analystName: json["analystName"],
        priceTarget: json["priceTarget"],
        priceWhenPosted: json["priceWhenPosted"],
        upDown: json["up_down"],
        newsUrl: json["newsURL"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "brokerage": brokerage,
        "analystName": analystName,
        "priceTarget": priceTarget,
        "priceWhenPosted": priceWhenPosted,
        "up_down": upDown,
        "newsURL": newsUrl,
      };
}

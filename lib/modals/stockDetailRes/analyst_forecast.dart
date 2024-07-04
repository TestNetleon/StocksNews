import 'dart:convert';

import '../faqs_res.dart';
import 'earnings.dart';

SdAnalystForecastRes sdAnalystForecastResFromJson(String str) =>
    SdAnalystForecastRes.fromJson(json.decode(str));

String sdAnalystForecastResToJson(SdAnalystForecastRes data) =>
    json.encode(data.toJson());

class SdAnalystForecastRes {
  final List<AnalystForecast>? analystForecasts;
  final List<AnalystForecastChart>? chartData;
  final List<FaQsRes>? faq;
  final List<SdTopRes>? top;
  //chartData

  SdAnalystForecastRes(
      {this.analystForecasts, this.faq, this.top, this.chartData});

  factory SdAnalystForecastRes.fromJson(Map<String, dynamic> json) =>
      SdAnalystForecastRes(
        analystForecasts: json["analyst_forecasts"] == null
            ? []
            : List<AnalystForecast>.from(json["analyst_forecasts"]!
                .map((x) => AnalystForecast.fromJson(x))),
        chartData: json["chart_data"] == null
            ? []
            : List<AnalystForecastChart>.from(json["chart_data"]!
                .map((x) => AnalystForecastChart.fromJson(x))),
        faq: json["faq"] == null
            ? []
            : List<FaQsRes>.from(json["faq"]!.map((x) => FaQsRes.fromJson(x))),
        top: json["top"] == null
            ? []
            : List<SdTopRes>.from(
                json["top"]!.map((x) => SdTopRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "analyst_forecasts": analystForecasts == null
            ? []
            : List<dynamic>.from(analystForecasts!.map((x) => x.toJson())),
        "chart_data": chartData == null
            ? []
            : List<dynamic>.from(chartData!.map((x) => x.toJson())),
        "faq":
            faq == null ? [] : List<dynamic>.from(faq!.map((x) => x.toJson())),
        "top":
            top == null ? [] : List<dynamic>.from(top!.map((x) => x.toJson())),
      };
}

class AnalystForecast {
  final String? date;
  final String? brokerage;
  final String? analystName;
  final String? priceTarget;
  final String? priceWhenPosted;
  final dynamic upDown;
  final String? newsUrl;

  AnalystForecast({
    this.date,
    this.brokerage,
    this.analystName,
    this.priceTarget,
    this.priceWhenPosted,
    this.upDown,
    this.newsUrl,
  });

  factory AnalystForecast.fromJson(Map<String, dynamic> json) =>
      AnalystForecast(
        date: json["date"],
        brokerage: json["brokerage"],
        analystName: json["analystName"],
        priceTarget: json["priceTarget"],
        priceWhenPosted: json["priceWhenPosted"],
        upDown: json["up_down"]?.toDouble(),
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

class AnalystForecastChart {
  final String? period;
  final int? buy;
  final int? sell;
  final int? hold;

  AnalystForecastChart({
    this.period,
    this.buy,
    this.sell,
    this.hold,
  });

  factory AnalystForecastChart.fromJson(Map<String, dynamic> json) =>
      AnalystForecastChart(
        period: json["period"],
        buy: json["buy"],
        sell: json["sell"],
        hold: json["hold"],
      );

  Map<String, dynamic> toJson() => {
        "period": period,
        "buy": buy,
        "sell": sell,
        "hold": hold,
      };
}

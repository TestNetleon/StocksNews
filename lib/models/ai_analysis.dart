import 'dart:convert';

import 'package:stocks_news_new/models/faq.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/models/ticker.dart';

AIRes AIResFromJson(String str) => AIRes.fromJson(json.decode(str));

String AIResToJson(AIRes data) => json.encode(data.toJson());

class AIRes {
  final BaseTickerRes? tickerDetail;
  final AIradarChartRes? radarChart;
  final AIourTakeRes? ourTake;
  final AIswotRes? swot;
  final Performance? performance;
  final BaseFaqRes? faqs;

  AIRes({
    this.tickerDetail,
    this.radarChart,
    this.ourTake,
    this.swot,
    this.performance,
    this.faqs,
  });

  factory AIRes.fromJson(Map<String, dynamic> json) => AIRes(
        tickerDetail: json["ticker_data"] == null
            ? null
            : BaseTickerRes.fromJson(json["ticker_data"]),
        radarChart: json["radar_chart"] == null
            ? null
            : AIradarChartRes.fromJson(json["radar_chart"]),
        ourTake: json["our_take"] == null
            ? null
            : AIourTakeRes.fromJson(json["our_take"]),
        swot: json["swot"] == null ? null : AIswotRes.fromJson(json["swot"]),
        performance: json["performance"] == null
            ? null
            : Performance.fromJson(json["performance"]),
        faqs: json["faqs"] == null ? null : BaseFaqRes.fromJson(json["faqs"]),
      );

  Map<String, dynamic> toJson() => {
        "ticker_data": tickerDetail?.toJson(),
        "radar_chart": radarChart?.toJson(),
        "our_take": ourTake?.toJson(),
        "swot": swot?.toJson(),
        "performance": performance?.toJson(),
        "faqs": faqs?.toJson(),
      };
}

class AIourTakeRes {
  final String? title;
  final List<String>? data;

  AIourTakeRes({
    this.title,
    this.data,
  });

  factory AIourTakeRes.fromJson(Map<String, dynamic> json) => AIourTakeRes(
        title: json["title"],
        data: json["data"] == null
            ? []
            : List<String>.from(json["data"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
      };
}

class Performance {
  final String? title;
  final num? price;
  final num? yearHigh;
  final num? yearLow;
  final num? dayHigh;
  final num? dayLow;
  final String? open;
  final String? previousClose;
  final String? volume;

  Performance({
    this.title,
    this.price,
    this.yearHigh,
    this.yearLow,
    this.dayHigh,
    this.dayLow,
    this.open,
    this.previousClose,
    this.volume,
  });

  factory Performance.fromJson(Map<String, dynamic> json) => Performance(
        title: json["title"],
        price: json["price"],
        yearHigh: json["yearHigh"],
        yearLow: json["yearLow"],
        dayHigh: json["dayHigh"],
        dayLow: json["dayLow"],
        open: json["open"],
        previousClose: json["previousClose"],
        volume: json["volume"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "price": price,
        "yearHigh": yearHigh,
        "yearLow": yearLow,
        "dayHigh": dayHigh,
        "dayLow": dayLow,
        "open": open,
        "previousClose": previousClose,
        "volume": volume,
      };
}

class AIradarChartRes {
  final String? title;
  final BaseKeyValueRes? recommendation;
  final List<AIradarChartDataRes>? radarChart;

  AIradarChartRes({
    this.title,
    this.recommendation,
    this.radarChart,
  });

  factory AIradarChartRes.fromJson(Map<String, dynamic> json) =>
      AIradarChartRes(
        title: json["title"],
        recommendation: json["recommendation"] == null
            ? null
            : BaseKeyValueRes.fromJson(json["recommendation"]),
        radarChart: json["radar_chart"] == null
            ? []
            : List<AIradarChartDataRes>.from(json["radar_chart"]!
                .map((x) => AIradarChartDataRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "recommendation": recommendation?.toJson(),
        "radar_chart": radarChart == null
            ? []
            : List<dynamic>.from(radarChart!.map((x) => x.toJson())),
      };
}

class AIradarChartDataRes {
  final String? label;
  final num? value;
  final String? description;

  AIradarChartDataRes({
    this.label,
    this.value,
    this.description,
  });

  factory AIradarChartDataRes.fromJson(Map<String, dynamic> json) =>
      AIradarChartDataRes(
        label: json["label"],
        value: json["value"]?.toDouble(),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "description": description,
      };
}

class AIswotRes {
  final String? title;
  final AIswotDataRes? data;

  AIswotRes({
    this.title,
    this.data,
  });

  factory AIswotRes.fromJson(Map<String, dynamic> json) => AIswotRes(
        title: json["title"],
        data:
            json["data"] == null ? null : AIswotDataRes.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "data": data?.toJson(),
      };
}

class AIswotDataRes {
  final List<String>? strengths;
  final List<String>? weaknesses;
  final List<String>? opportunity;
  final List<String>? threats;

  AIswotDataRes({
    this.strengths,
    this.weaknesses,
    this.opportunity,
    this.threats,
  });

  factory AIswotDataRes.fromJson(Map<String, dynamic> json) => AIswotDataRes(
        strengths: json["strengths"] == null
            ? []
            : List<String>.from(json["strengths"]!.map((x) => x)),
        weaknesses: json["weaknesses"] == null
            ? []
            : List<String>.from(json["weaknesses"]!.map((x) => x)),
        opportunity: json["opportunity"] == null
            ? []
            : List<String>.from(json["opportunity"]!.map((x) => x)),
        threats: json["threats"] == null
            ? []
            : List<String>.from(json["threats"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "strengths": strengths == null
            ? []
            : List<dynamic>.from(strengths!.map((x) => x)),
        "weaknesses": weaknesses == null
            ? []
            : List<dynamic>.from(weaknesses!.map((x) => x)),
        "opportunity": opportunity == null
            ? []
            : List<dynamic>.from(opportunity!.map((x) => x)),
        "threats":
            threats == null ? [] : List<dynamic>.from(threats!.map((x) => x)),
      };
}

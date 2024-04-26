// To parse this JSON data, do
//
//     final technicalAnalysisRes = technicalAnalysisResFromJson(jsonString);

import 'dart:convert';

TechnicalAnalysisRes technicalAnalysisResFromJson(String str) =>
    TechnicalAnalysisRes.fromJson(json.decode(str));

String technicalAnalysisResToJson(TechnicalAnalysisRes data) =>
    json.encode(data.toJson());

class TechnicalAnalysisRes {
  final MovingAverage summary;
  final List<TechnicalIndicatorArr> technicalIndicatorArr;
  final MovingAverage technicalIndicator;
  final List<MovingAverageArr> movingAverageArr;
  final MovingAverage movingAverage;
  final String interval;

  TechnicalAnalysisRes({
    required this.summary,
    required this.technicalIndicatorArr,
    required this.technicalIndicator,
    required this.movingAverageArr,
    required this.movingAverage,
    required this.interval,
  });

  factory TechnicalAnalysisRes.fromJson(Map<String, dynamic> json) =>
      TechnicalAnalysisRes(
        summary: MovingAverage.fromJson(json["summary"]),
        technicalIndicatorArr: List<TechnicalIndicatorArr>.from(
            json["technical_indicator_arr"]
                .map((x) => TechnicalIndicatorArr.fromJson(x))),
        technicalIndicator: MovingAverage.fromJson(json["technical_indicator"]),
        movingAverageArr: List<MovingAverageArr>.from(json["moving_average_arr"]
            .map((x) => MovingAverageArr.fromJson(x))),
        movingAverage: MovingAverage.fromJson(json["moving_average"]),
        interval: json["interval"],
      );

  Map<String, dynamic> toJson() => {
        "summary": summary.toJson(),
        "technical_indicator_arr":
            List<dynamic>.from(technicalIndicatorArr.map((x) => x.toJson())),
        "technical_indicator": technicalIndicator.toJson(),
        "moving_average_arr":
            List<dynamic>.from(movingAverageArr.map((x) => x.toJson())),
        "moving_average": movingAverage.toJson(),
        "interval": interval,
      };
}

class MovingAverage {
  final int total;
  final int totalSell;
  final int totalBuy;
  final int indicater;
  final String type;

  MovingAverage({
    required this.total,
    required this.totalSell,
    required this.totalBuy,
    required this.indicater,
    required this.type,
  });

  factory MovingAverage.fromJson(Map<String, dynamic> json) => MovingAverage(
        total: json["total"],
        totalSell: json["total_sell"],
        totalBuy: json["total_buy"],
        indicater: json["indicater"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "total_sell": totalSell,
        "total_buy": totalBuy,
        "indicater": indicater,
        "type": type,
      };
}

class MovingAverageArr {
  final String name;
  final double sma;
  final String smaStatus;
  final double ema;
  final String emaStatus;
  final double wma;
  final String wmaStatus;
  final String date;

  MovingAverageArr({
    required this.name,
    required this.sma,
    required this.smaStatus,
    required this.ema,
    required this.emaStatus,
    required this.wma,
    required this.wmaStatus,
    required this.date,
  });

  factory MovingAverageArr.fromJson(Map<String, dynamic> json) =>
      MovingAverageArr(
        name: json["name"],
        sma: json["sma"]?.toDouble(),
        smaStatus: json["sma_status"],
        ema: json["ema"]?.toDouble(),
        emaStatus: json["ema_status"],
        wma: json["wma"]?.toDouble(),
        wmaStatus: json["wma_status"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "sma": sma,
        "sma_status": smaStatus,
        "ema": ema,
        "ema_status": emaStatus,
        "wma": wma,
        "wma_status": wmaStatus,
        "date": date,
      };
}

class TechnicalIndicatorArr {
  final String name;
  final double value;
  final String action;
  final String date;

  TechnicalIndicatorArr({
    required this.name,
    required this.value,
    required this.action,
    required this.date,
  });

  factory TechnicalIndicatorArr.fromJson(Map<String, dynamic> json) =>
      TechnicalIndicatorArr(
        name: json["name"],
        value: json["value"]?.toDouble(),
        action: json["action"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
        "action": action,
        "date": date,
      };
}

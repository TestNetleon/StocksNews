import 'dart:convert';

StocksDetailHistoricalChartRes stocksDetailHistoricalChartResFromJson(
        String str) =>
    StocksDetailHistoricalChartRes.fromJson(json.decode(str));

String stocksDetailHistoricalChartResToJson(
        StocksDetailHistoricalChartRes data) =>
    json.encode(data.toJson());

class StocksDetailHistoricalChartRes {
  final num? totalChange;
  final String? label;

  final List<HistoricalChartRes>? chartData;

  StocksDetailHistoricalChartRes({
    this.label,
    this.totalChange,
    this.chartData,
  });

  factory StocksDetailHistoricalChartRes.fromJson(Map<String, dynamic> json) =>
      StocksDetailHistoricalChartRes(
        label: json['label'],
        totalChange: json["total_change"],
        chartData: json["chart_data"] == null
            ? []
            : List<HistoricalChartRes>.from(
                json["chart_data"]!.map((x) => HistoricalChartRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_change": totalChange,
        "label": label,
        "chart_data": chartData == null
            ? []
            : List<dynamic>.from(chartData!.map((x) => x.toJson())),
      };
}

class HistoricalChartRes {
  final DateTime date;
  final num open;
  final num low;
  final num high;
  final num close;
  final num volume;

  HistoricalChartRes({
    required this.date,
    required this.open,
    required this.low,
    required this.high,
    required this.close,
    required this.volume,
  });

  factory HistoricalChartRes.fromJson(Map<String, dynamic> json) =>
      HistoricalChartRes(
        date: DateTime.parse(json["date"]),
        open: json["open"],
        low: json["low"],
        high: json["high"],
        close: json["close"],
        volume: json["volume"],
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "open": open,
        "low": low,
        "high": high,
        "close": close,
        "volume": volume,
      };
}

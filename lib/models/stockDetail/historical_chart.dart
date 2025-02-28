import 'dart:convert';

SDHistoricalChartRes stocksDetailHistoricalChartResFromJson(String str) =>
    SDHistoricalChartRes.fromJson(json.decode(str));

String stocksDetailHistoricalChartResToJson(SDHistoricalChartRes data) =>
    json.encode(data.toJson());

class SDHistoricalChartRes {
  final num? totalChange;
  final String? label;

  final List<HistoricalChartRes>? chartData;

  SDHistoricalChartRes({
    this.label,
    this.totalChange,
    this.chartData,
  });

  factory SDHistoricalChartRes.fromJson(Map<String, dynamic> json) =>
      SDHistoricalChartRes(
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
  // final num open;
  // final num low;
  // final num high;
  // final num volume;
  final num close;

  HistoricalChartRes({
    required this.date,
    // required this.open,
    // required this.low,
    // required this.high,
    // required this.volume,
    required this.close,
  });

  factory HistoricalChartRes.fromJson(Map<String, dynamic> json) =>
      HistoricalChartRes(
        date: DateTime.parse(json["date"]),
        // open: json["open"],
        // low: json["low"],
        // high: json["high"],
        // volume: json["volume"],
        close: json["close"],
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        // "open": open,
        // "low": low,
        // "high": high,
        // "volume": volume,
        "close": close,
      };
}

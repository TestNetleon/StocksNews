// To parse this JSON data, do
//
//     final stockDetailGraph = stockDetailGraphFromJson(jsonString);

import 'dart:convert';
// To parse this JSON data, do
//
//     final stockDetailGraph = stockDetailGraphFromJson(jsonString);

StockDetailGraph stockDetailGraphFromJson(String str) =>
    StockDetailGraph.fromJson(json.decode(str));

String stockDetailGraphToJson(StockDetailGraph data) =>
    json.encode(data.toJson());

class StockDetailGraph {
  final List<StockDetailGraphData> data;
  final List<StockDetailGraphData> extra;

  StockDetailGraph({
    required this.data,
    required this.extra,
  });

  factory StockDetailGraph.fromJson(Map<String, dynamic> json) =>
      StockDetailGraph(
        data: List<StockDetailGraphData>.from(
            json["data"].map((x) => StockDetailGraphData.fromJson(x))),
        extra: List<StockDetailGraphData>.from(
            json["extra"].map((x) => StockDetailGraphData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "extra": List<dynamic>.from(extra.map((x) => x.toJson())),
      };
}

class StockDetailGraphData {
  final DateTime date;
  final double open;
  final double low;
  final double high;
  final double close;
  final int volume;

  StockDetailGraphData({
    required this.date,
    required this.open,
    required this.low,
    required this.high,
    required this.close,
    required this.volume,
  });

  factory StockDetailGraphData.fromJson(Map<String, dynamic> json) =>
      StockDetailGraphData(
        date: DateTime.parse(json["date"]),
        open: json["open"]?.toDouble(),
        low: json["low"]?.toDouble(),
        high: json["high"]?.toDouble(),
        close: json["close"]?.toDouble(),
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

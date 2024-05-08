// To parse this JSON data, do
//
//     final stockDetailGraph = stockDetailGraphFromJson(jsonString);

import 'dart:convert';

List<StockDetailGraph> stockDetailGraphFromJson(String str) =>
    List<StockDetailGraph>.from(
        json.decode(str).map((x) => StockDetailGraph.fromJson(x)));

String stockDetailGraphToJson(List<StockDetailGraph> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StockDetailGraph {
  final DateTime date;
  // final double open;
  // final double low;
  // final double high;
  final double close;
  // final int volume;

  StockDetailGraph({
    required this.date,
    // required this.open,
    // required this.low,
    // required this.high,
    required this.close,
    // required this.volume,
  });

  factory StockDetailGraph.fromJson(Map<String, dynamic> json) =>
      StockDetailGraph(
        date: DateTime.parse(json["date"]),
        // open: json["open"]?.toDouble(),
        // low: json["low"]?.toDouble(),
        // high: json["high"]?.toDouble(),
        close: json["close"]?.toDouble(),
        // volume: json["volume"],
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        // "open": open,
        // "low": low,
        // "high": high,
        "close": close,
        // "volume": volume,
      };
}

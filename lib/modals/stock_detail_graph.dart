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

  final double close;

  StockDetailGraph({
    required this.date,
    required this.close,
  });

  factory StockDetailGraph.fromJson(Map<String, dynamic> json) =>
      StockDetailGraph(
        date: DateTime.parse(json["date"]),
        close: json["close"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "close": close,
      };
}

import 'dart:convert';

MsStockHighlightsRes msStockHighlightsResFromJson(String str) =>
    MsStockHighlightsRes.fromJson(json.decode(str));

String msStockHighlightsResToJson(MsStockHighlightsRes data) =>
    json.encode(data.toJson());

class MsStockHighlightsRes {
  final String? label;
  final dynamic value;
  final num? stockPe;
  final num? averagePeerPe;
  final String? description;

  MsStockHighlightsRes({
    this.label,
    this.value,
    this.stockPe,
    this.averagePeerPe,
    this.description,
  });

  factory MsStockHighlightsRes.fromJson(Map<String, dynamic> json) =>
      MsStockHighlightsRes(
        label: json["label"],
        value: json["value"],
        stockPe: json["stockPE"],
        averagePeerPe: json["averagePeerPE"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "stockPE": stockPe,
        "averagePeerPE": averagePeerPe,
        "description": description,
      };
}

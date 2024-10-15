import 'dart:convert';

List<MsRadarChartRes> msRadarChartResFromJson(String str) =>
    List<MsRadarChartRes>.from(
        json.decode(str).map((x) => MsRadarChartRes.fromJson(x)));

String msRadarChartResToJson(List<MsRadarChartRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MsRadarChartRes {
  final String? label;
  final dynamic value;
  final String? valueColor;
  final String? description;

  MsRadarChartRes({
    this.label,
    this.value,
    this.valueColor,
    this.description,
  });

  factory MsRadarChartRes.fromJson(Map<String, dynamic> json) =>
      MsRadarChartRes(
        label: json["label"],
        value: json["value"],
        valueColor: json["value_color"],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "value_color": valueColor,
        "description": description,
      };
}

import 'dart:convert';

List<MsRadarChartRes> msRadarChartResFromJson(String str) =>
    List<MsRadarChartRes>.from(
        json.decode(str).map((x) => MsRadarChartRes.fromJson(x)));

String msRadarChartResToJson(List<MsRadarChartRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MsRadarChartRes {
  final String? label;
  final dynamic value;
  final String? description;

  MsRadarChartRes({
    this.label,
    this.value,
    this.description,
  });

  factory MsRadarChartRes.fromJson(Map<String, dynamic> json) =>
      MsRadarChartRes(
        label: json["label"],
        value: json["value"],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "description": description,
      };
}

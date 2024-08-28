import 'dart:convert';

List<MsRadarChartRes> msRadarChartResFromJson(String str) =>
    List<MsRadarChartRes>.from(
        json.decode(str).map((x) => MsRadarChartRes.fromJson(x)));

String msRadarChartResToJson(List<MsRadarChartRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MsRadarChartRes {
  final String? label;
  final num? value;

  MsRadarChartRes({
    this.label,
    this.value,
  });

  factory MsRadarChartRes.fromJson(Map<String, dynamic> json) =>
      MsRadarChartRes(
        label: json["label"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
      };
}

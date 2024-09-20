import 'dart:convert';

List<MsFinancialsRes> msFinancialsResFromJson(String str) =>
    List<MsFinancialsRes>.from(
        json.decode(str).map((x) => MsFinancialsRes.fromJson(x)));

String msFinancialsResToJson(List<MsFinancialsRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MsFinancialsRes {
  final String? key;
  final int? value;
  final String? formattedValue;

  MsFinancialsRes({
    this.key,
    this.value,
    this.formattedValue,
  });

  factory MsFinancialsRes.fromJson(Map<String, dynamic> json) =>
      MsFinancialsRes(
        key: json["key"],
        value: json["value"],
        formattedValue: json["formatted_value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
        "formatted_value": formattedValue,
      };
}

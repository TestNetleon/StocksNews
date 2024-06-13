import 'dart:convert';

List<SdOverviewGraphRes> sdOverviewGraphResFromJson(String str) =>
    List<SdOverviewGraphRes>.from(
        json.decode(str).map((x) => SdOverviewGraphRes.fromJson(x)));

String sdOverviewGraphResToJson(List<SdOverviewGraphRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SdOverviewGraphRes {
  final DateTime date;
  final num close;

  SdOverviewGraphRes({
    required this.date,
    required this.close,
  });

  factory SdOverviewGraphRes.fromJson(Map<String, dynamic> json) =>
      SdOverviewGraphRes(
        date: DateTime.parse(json["date"]),
        close: json["close"],
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "close": close,
      };
}

import 'dart:convert';

AiFinancialRes aiFinancialResFromJson(String str) =>
    AiFinancialRes.fromJson(json.decode(str));

String aiFinancialResToJson(AiFinancialRes data) => json.encode(data.toJson());

class AiFinancialRes {
  final List<AiFinancialChartRes>? data;

  AiFinancialRes({
    this.data,
  });

  factory AiFinancialRes.fromJson(Map<String, dynamic> json) => AiFinancialRes(
        data: json["data"] == null
            ? []
            : List<AiFinancialChartRes>.from(
                json["data"]!.map((x) => AiFinancialChartRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AiFinancialChartRes {
  final String? title;
  final int? value;
  final String? displayValue;

  AiFinancialChartRes({
    this.title,
    this.value,
    this.displayValue,
  });

  factory AiFinancialChartRes.fromJson(Map<String, dynamic> json) =>
      AiFinancialChartRes(
        title: json["title"],
        value: json["value"],
        displayValue: json["display_value"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "display_value": displayValue,
      };
}

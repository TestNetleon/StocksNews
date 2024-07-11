// To parse this JSON data, do
//
//     final sdBenefitAnalyst = sdBenefitAnalystFromJson(jsonString);

import 'dart:convert';

List<SdBenefitAnalyst> sdBenefitAnalystFromJson(String str) =>
    List<SdBenefitAnalyst>.from(
        json.decode(str).map((x) => SdBenefitAnalyst.fromJson(x)));

String sdBenefitAnalystToJson(List<SdBenefitAnalyst> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SdBenefitAnalyst {
  final String? key;
  final int? point;
  final String? text;

  SdBenefitAnalyst({
    this.key,
    this.point,
    this.text,
  });

  factory SdBenefitAnalyst.fromJson(Map<String, dynamic> json) =>
      SdBenefitAnalyst(
        key: json["key"],
        point: json["point"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "point": point,
        "text": text,
      };
}

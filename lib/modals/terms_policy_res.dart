// To parse this JSON data, do
//
//     final termsPolicyRes = termsPolicyResFromJson(jsonString);

import 'dart:convert';

TermsPolicyRes termsPolicyResFromJson(String str) =>
    TermsPolicyRes.fromJson(json.decode(str));

String termsPolicyResToJson(TermsPolicyRes data) => json.encode(data.toJson());

class TermsPolicyRes {
  final String description;
  final List<ContactDetail>? contactDetail;

  TermsPolicyRes({
    required this.description,
    this.contactDetail,
  });

  factory TermsPolicyRes.fromJson(Map<String, dynamic> json) => TermsPolicyRes(
        description: json["description"],
        contactDetail: json["contact_detail"] == null
            ? []
            : List<ContactDetail>.from(
                json["contact_detail"]!.map((x) => ContactDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "contact_detail": contactDetail == null
            ? []
            : List<dynamic>.from(contactDetail!.map((x) => x.toJson())),
      };
}

class ContactDetail {
  final String? key;
  final String value;

  ContactDetail({
    this.key,
    required this.value,
  });

  factory ContactDetail.fromJson(Map<String, dynamic> json) => ContactDetail(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}

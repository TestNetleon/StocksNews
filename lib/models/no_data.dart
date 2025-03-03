
import 'dart:convert';

NoDataRes noDataResFromMap(String str) => NoDataRes.fromMap(json.decode(str));

String noDataResToMap(NoDataRes data) => json.encode(data.toMap());

class NoDataRes {
  final String? icon;
  final String? title;
  final String? subTitle;
  final String? other;
  final String? btnText;

  NoDataRes({
    this.icon,
    this.title,
    this.subTitle,
    this.other,
    this.btnText,
  });

  factory NoDataRes.fromMap(Map<String, dynamic> json) => NoDataRes(
    icon: json["icon"],
    title: json["title"],
    subTitle: json["sub_title"],
    other: json["other"],
    btnText: json["btn_text"],
  );

  Map<String, dynamic> toMap() => {
    "icon": icon,
    "title": title,
    "sub_title": subTitle,
    "other": other,
    "btn_text": btnText,
  };
}

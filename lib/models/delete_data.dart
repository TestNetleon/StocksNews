
import 'dart:convert';

DeleteBoxRes deleteDataResFromMap(String str) => DeleteBoxRes.fromMap(json.decode(str));

String deleteDataResToMap(DeleteBoxRes data) => json.encode(data.toMap());

class DeleteBoxRes {
  final String? icon;
  final String? title;
  final String? subTitle;
  final String? btnCancelText;
  final String? btnConfirmText;
  final String? type;

  DeleteBoxRes({
    this.icon,
    this.title,
    this.subTitle,
    this.btnCancelText,
    this.btnConfirmText,
    this.type,
  });

  factory DeleteBoxRes.fromMap(Map<String, dynamic> json) => DeleteBoxRes(
    icon: json["icon"],
    title: json["title"],
    subTitle: json["sub_title"],
    btnCancelText: json["btn_cancel_text"],
    btnConfirmText: json["btn_confirm_text"],
    type: json["type"],
  );

  Map<String, dynamic> toMap() => {
    "icon": icon,
    "title": title,
    "sub_title": subTitle,
    "btn_cancel_text": btnCancelText,
    "btn_confirm_text": btnConfirmText,
    "type": type,
  };
}

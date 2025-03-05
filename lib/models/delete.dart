import 'dart:convert';

DeleteUserRes deleteUserResFromJson(String str) =>
    DeleteUserRes.fromJson(json.decode(str));

String deleteUserResToJson(DeleteUserRes data) => json.encode(data.toJson());

class DeleteUserRes {
  final String? title;
  final String? subTitle;
  final String? btnActive;
  final String? btnDelete;
  final String? icon;

  DeleteUserRes({
    this.title,
    this.subTitle,
    this.btnActive,
    this.btnDelete,
    this.icon,
  });

  factory DeleteUserRes.fromJson(Map<String, dynamic> json) => DeleteUserRes(
        title: json["title"],
        subTitle: json["sub_title"],
        btnActive: json["btn_active"],
        btnDelete: json["btn_delete"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "btn_active": btnActive,
        "btn_delete": btnDelete,
        "icon": icon,
      };
}

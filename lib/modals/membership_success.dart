import 'dart:convert';

MembershipSuccess membershipSuccessFromJson(String str) =>
    MembershipSuccess.fromJson(json.decode(str));

String membershipSuccessToJson(MembershipSuccess data) =>
    json.encode(data.toJson());

class MembershipSuccess {
  final String? title;
  final String? subTitle;
  final String? description;

  MembershipSuccess({
    this.title,
    this.subTitle,
    this.description,
  });

  factory MembershipSuccess.fromJson(Map<String, dynamic> json) =>
      MembershipSuccess(
        title: json["title"],
        subTitle: json["sub_title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "description": description,
      };
}

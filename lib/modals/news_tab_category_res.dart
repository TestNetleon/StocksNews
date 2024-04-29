import 'dart:convert';

List<NesCategoryTabRes> nesCategoryTabResFromJson(String str) =>
    List<NesCategoryTabRes>.from(
        json.decode(str).map((x) => NesCategoryTabRes.fromJson(x)));

String nesCategoryTabResToJson(List<NesCategoryTabRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//
class NesCategoryTabRes {
  final String id;
  final String name;

  NesCategoryTabRes({
    required this.id,
    required this.name,
  });

  factory NesCategoryTabRes.fromJson(Map<String, dynamic> json) =>
      NesCategoryTabRes(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

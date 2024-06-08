import 'dart:convert';

List<BlogTabRes> blogTabResFromJson(String str) =>
    List<BlogTabRes>.from(json.decode(str).map((x) => BlogTabRes.fromJson(x)));

String blogTabResToJson(List<BlogTabRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BlogTabRes {
  final String id;
  final String name;

  BlogTabRes({
    required this.id,
    required this.name,
  });

  factory BlogTabRes.fromJson(Map<String, dynamic> json) => BlogTabRes(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

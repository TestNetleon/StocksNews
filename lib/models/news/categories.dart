// import 'dart:convert';

// NewsCategoriesRes newsCategoriesResFromJson(String str) =>
//     NewsCategoriesRes.fromJson(json.decode(str));

// String newsCategoriesResToJson(NewsCategoriesRes data) =>
//     json.encode(data.toJson());

// class NewsCategoriesRes {
//   final List<CategoryRes>? data;

//   NewsCategoriesRes({this.data});

//   factory NewsCategoriesRes.fromJson(Map<String, dynamic> json) =>
//       NewsCategoriesRes(
//         data: json["data"] == null
//             ? []
//             : List<CategoryRes>.from(
//                 json["data"]!.map((x) => CategoryRes.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "data": data == null
//             ? []
//             : List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }

// class CategoryRes {
//   final String id;
//   final String name;

//   CategoryRes({
//     required this.id,
//     required this.name,
//   });

//   factory CategoryRes.fromJson(Map<String, dynamic> json) => CategoryRes(
//         id: json["_id"],
//         name: json["name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "name": name,
//       };
// }

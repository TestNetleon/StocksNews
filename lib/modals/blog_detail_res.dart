// To parse this JSON data, do
//
//     final blogsDetailRes = blogsDetailResFromJson(jsonString);

import 'dart:convert';

import 'blogs_res.dart';

BlogsDetailRes blogsDetailResFromJson(String str) =>
    BlogsDetailRes.fromJson(json.decode(str));

String blogsDetailResToJson(BlogsDetailRes data) => json.encode(data.toJson());

class BlogsDetailRes {
  final String id;
  final String name;
  final String description;
  final List<BlogItemRes> authors;
  final List<BlogItemRes> categories;
  final List<BlogItemRes> tags;
  final DateTime? publishedDate;
  final String image;

  BlogsDetailRes({
    required this.id,
    required this.name,
    required this.description,
    required this.authors,
    required this.categories,
    required this.tags,
    this.publishedDate,
    required this.image,
  });

  factory BlogsDetailRes.fromJson(Map<String, dynamic> json) => BlogsDetailRes(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        authors: List<BlogItemRes>.from(
            json["authors"].map((x) => BlogItemRes.fromJson(x))),
        categories: List<BlogItemRes>.from(
            json["categories"].map((x) => BlogItemRes.fromJson(x))),
        tags: List<BlogItemRes>.from(
            json["tags"].map((x) => BlogItemRes.fromJson(x))),
        publishedDate: json["published_date"] == null
            ? null
            : DateTime.parse(json["published_date"]),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "authors": List<dynamic>.from(authors.map((x) => x.toJson())),
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
        "published_date": publishedDate?.toIso8601String(),
        "image": image,
      };
}

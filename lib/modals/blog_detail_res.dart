// To parse this JSON data, do
//
//     final blogsDetailRes = blogsDetailResFromJson(jsonString);

import 'dart:convert';

import 'news_datail_res.dart';

BlogsDetailRes blogsDetailResFromJson(String str) =>
    BlogsDetailRes.fromJson(json.decode(str));

String blogsDetailResToJson(BlogsDetailRes data) => json.encode(data.toJson());

//
class BlogsDetailRes {
  final String id;
  final String name;
  final String description;
  final String slug;
  final List<DetailListType>? authors;
  // final List<BlogItemRes> categories;
  // final List<BlogItemRes> tags;
  final DateTime? publishedDate;
  final String? postDateString;
  final String image;
  String? feedbackMsg;
  String? feedbackExistMsg;

  BlogsDetailRes({
    required this.id,
    required this.name,
    required this.description,
    this.authors,
    this.postDateString,
    required this.slug,
    // required this.categories,
    // required this.tags,
    this.publishedDate,
    required this.image,
    this.feedbackMsg,
    this.feedbackExistMsg,
  });

  factory BlogsDetailRes.fromJson(Map<String, dynamic> json) => BlogsDetailRes(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        slug: json["slug"],
        authors: json["authors"] == null
            ? []
            : List<DetailListType>.from(
                json["authors"]!.map((x) => DetailListType.fromJson(x))),
        // categories: List<BlogItemRes>.from(
        //     json["categories"].map((x) => BlogItemRes.fromJson(x))),
        // tags: List<BlogItemRes>.from(
        //     json["tags"].map((x) => BlogItemRes.fromJson(x))),
        publishedDate: json["published_date"] == null
            ? null
            : DateTime.parse(json["published_date"]),
        postDateString: json['published_date_string'],
        image: json["image"],
        feedbackExistMsg: json["feedback_exist_msg"],
        feedbackMsg: json["feedback_msg"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        'published_date_string': postDateString,
        "slug": slug,
        "authors": authors == null
            ? []
            : List<dynamic>.from(authors!.map((x) => x.toJson())),
        // "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        // "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
        "published_date": publishedDate?.toIso8601String(),
        "image": image,
        "feedback_msg": feedbackMsg,
        "feedback_exist_msg": feedbackExistMsg,
      };
}

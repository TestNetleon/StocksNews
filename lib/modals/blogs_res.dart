// To parse this JSON data, do
//
//     final blogsRes = blogsResFromJson(jsonString);

import 'dart:convert';

import 'news_datail_res.dart';

BlogsRes blogsResFromJson(String str) => BlogsRes.fromJson(json.decode(str));

String blogsResToJson(BlogsRes data) => json.encode(data.toJson());

//
class BlogsRes {
  final String title;
  final String subTitle;
  final String image;
  final BlogDataRes data;

  BlogsRes({
    required this.title,
    required this.subTitle,
    required this.image,
    required this.data,
  });

  factory BlogsRes.fromJson(Map<String, dynamic> json) => BlogsRes(
        title: json["title"],
        subTitle: json["sub_title"],
        image: json["image"],
        data: BlogDataRes.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "image": image,
        "data": data.toJson(),
      };
}

class BlogDataRes {
  // final int currentPage;
  final List<BlogItemRes> data;
  final int lastPage;

  BlogDataRes({
    // required this.currentPage,
    required this.data,
    required this.lastPage,
  });

  factory BlogDataRes.fromJson(Map<String, dynamic> json) => BlogDataRes(
        // currentPage: json["current_page"],
        data: List<BlogItemRes>.from(
            json["data"].map((x) => BlogItemRes.fromJson(x))),
        lastPage: json["last_page"],
      );

  Map<String, dynamic> toJson() => {
        // "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "last_page": lastPage,
      };
}

class BlogItemRes {
  // final String id;
  final String slug;
  final String name;
  final DateTime? publishedDate;
  final String? postDateString;
  final List<DetailListType>? authors;

  final String? image;

  BlogItemRes({
    // required this.id,
    required this.name,
    required this.slug,
    this.authors,
    this.postDateString,
    this.publishedDate,
    this.image,
  });

  factory BlogItemRes.fromJson(Map<String, dynamic> json) => BlogItemRes(
        // id: json["_id"],
        name: json["name"],
        postDateString: json['published_date_string'],
        authors: json["authors"] == null
            ? []
            : List<DetailListType>.from(
                json["authors"]!.map((x) => DetailListType.fromJson(x))),
        publishedDate: json["published_date"] == null
            ? null
            : DateTime.parse(json["published_date"]),
        image: json["image"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        // "_id": id,
        "name": name,
        'published_date_string': postDateString,
        "authors": authors == null
            ? []
            : List<dynamic>.from(authors!.map((x) => x.toJson())),
        "published_date": publishedDate?.toIso8601String(),
        "image": image,
        "slug": slug,
      };
}

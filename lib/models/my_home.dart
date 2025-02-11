// To parse this JSON data, do
//
//     final myHomeRes = myHomeResFromJson(jsonString);

import 'dart:convert';

MyHomeRes myHomeResFromJson(String str) => MyHomeRes.fromJson(json.decode(str));

String myHomeResToJson(MyHomeRes data) => json.encode(data.toJson());

class MyHomeRes {
  final HomeNewsRes? recentNews;
  final HomeNewsRes? featuredNews;
  final HomeNewsRes? financialNews;

  MyHomeRes({
    this.recentNews,
    this.featuredNews,
    this.financialNews,
  });

  factory MyHomeRes.fromJson(Map<String, dynamic> json) => MyHomeRes(
        recentNews: json["recent_news"] == null
            ? null
            : HomeNewsRes.fromJson(json["recent_news"]),
        featuredNews: json["featured_news"] == null
            ? null
            : HomeNewsRes.fromJson(json["featured_news"]),
        financialNews: json["financial_news"] == null
            ? null
            : HomeNewsRes.fromJson(json["financial_news"]),
      );

  Map<String, dynamic> toJson() => {
        "recent_news": recentNews?.toJson(),
        "featured_news": featuredNews?.toJson(),
        "financial_news": financialNews?.toJson(),
      };
}

class HomeNewsRes {
  final String? title;
  final String? subTitle;
  final List<NewsItemRes>? data;

  HomeNewsRes({
    this.title,
    this.subTitle,
    this.data,
  });

  factory HomeNewsRes.fromJson(Map<String, dynamic> json) => HomeNewsRes(
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<NewsItemRes>.from(
                json["data"]!.map((x) => NewsItemRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class NewsItemRes {
  final String? id;
  final String? title;
  final String? image;
  final String? slug;
  final List<NewsAuthorRes>? authors;
  final DateTime? publishedDate;
  final String? site;

  NewsItemRes({
    this.id,
    this.title,
    this.image,
    this.slug,
    this.authors,
    this.publishedDate,
    this.site,
  });

  factory NewsItemRes.fromJson(Map<String, dynamic> json) => NewsItemRes(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        slug: json["slug"],
        authors: json["authors"] == null
            ? []
            : List<NewsAuthorRes>.from(
                json["authors"]!.map((x) => NewsAuthorRes.fromJson(x))),
        publishedDate: json["published_date"] == null
            ? null
            : DateTime.parse(json["published_date"]),
        site: json["site"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "slug": slug,
        "authors": authors == null
            ? []
            : List<dynamic>.from(authors!.map((x) => x.toJson())),
        "published_date": publishedDate?.toIso8601String(),
        "site": site,
      };
}

class NewsAuthorRes {
  final String? id;
  final String? name;

  NewsAuthorRes({
    this.id,
    this.name,
  });

  factory NewsAuthorRes.fromJson(Map<String, dynamic> json) => NewsAuthorRes(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

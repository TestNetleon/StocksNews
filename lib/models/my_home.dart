import 'dart:convert';

import 'ticker.dart';

MyHomeRes myHomeResFromJson(String str) => MyHomeRes.fromJson(json.decode(str));

String myHomeResToJson(MyHomeRes data) => json.encode(data.toJson());

class MyHomeRes {
  final HomeNewsRes? recentNews;
  final List<BaseTickerRes>? tickers;
  final HomeLoginBoxRes? loginBox;

  MyHomeRes({
    this.recentNews,
    this.tickers,
    this.loginBox,
  });

  factory MyHomeRes.fromJson(Map<String, dynamic> json) => MyHomeRes(
        loginBox: json["login_box"] == null
            ? null
            : HomeLoginBoxRes.fromJson(json["login_box"]),
        recentNews: json["recent_news"] == null
            ? null
            : HomeNewsRes.fromJson(json["recent_news"]),
        tickers: json["trending"] == null
            ? null
            : List<BaseTickerRes>.from(
                json["trending"].map((x) => BaseTickerRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "login_box": loginBox?.toJson(),
        "recent_news": recentNews?.toJson(),
        "trending": tickers == null
            ? null
            : List<dynamic>.from(tickers!.map((x) => x.toJson())),
      };
}

class HomeLoginBoxRes {
  final String? id;
  final String? agreeUrl;
  final String? buttonText;
  final String? verifyButtonText;

  HomeLoginBoxRes({
    this.id,
    this.agreeUrl,
    this.buttonText,
    this.verifyButtonText,
  });

  factory HomeLoginBoxRes.fromJson(Map<String, dynamic> json) =>
      HomeLoginBoxRes(
        id: json["id"],
        agreeUrl: json["agree_url"],
        buttonText: json['btn_text'],
        verifyButtonText: json['verify_btn_text'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "agree_url": agreeUrl,
        "btn_text": buttonText,
        'verify_btn_text': verifyButtonText,
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
  final String? publishedDate;
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
        publishedDate: json["published_date"],
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
        "published_date": publishedDate,
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

import 'dart:convert';

import 'package:stocks_news_new/modals/user_res.dart';

import 'news.dart';
import 'ticker.dart';

MyHomeRes myHomeResFromJson(String str) => MyHomeRes.fromJson(json.decode(str));

String myHomeResToJson(MyHomeRes data) => json.encode(data.toJson());

class MyHomeRes {
  final HomeNewsRes? recentNews;
  final List<BaseTickerRes>? tickers;
  final HomeLoginBoxRes? loginBox;
  final UserRes? user;
  final BaseNewsRes? bannerBlog;

  MyHomeRes({
    this.recentNews,
    this.tickers,
    this.loginBox,
    this.user,
    this.bannerBlog,
  });

  factory MyHomeRes.fromJson(Map<String, dynamic> json) => MyHomeRes(
        user: json["user"] == null ? null : UserRes.fromJson(json["user"]),
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
    bannerBlog: json["banner_blog"] == null
        ? null
        : BaseNewsRes.fromJson(json["banner_blog"]),
      );

  Map<String, dynamic> toJson() => {
        "login_box": loginBox?.toJson(),
        "banner_blog": bannerBlog?.toJson(),
        "user": user?.toJson(),
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
  final List<BaseNewsRes>? data;

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
            : List<BaseNewsRes>.from(
                json["data"]!.map((x) => BaseNewsRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

// To parse this JSON data, do
//
//     final HomeTrendingRes = HomeTrendingResFromJson(jsonString);

import 'dart:convert';
import 'package:stocks_news_new/modals/home_insider_res.dart';

import 'home_res.dart';

HomeTrendingRes homeTrendingResFromJson(String str) =>
    HomeTrendingRes.fromJson(json.decode(str));

String homeTrendingResToJson(HomeTrendingRes data) =>
    json.encode(data.toJson());

class HomeTrendingRes {
  final List<HomeTrendingData> trending;
  final List<Top> popular;
  final List<Top>? gainers;
  final List<Top>? losers;
  final List<News>? trendingNews;
  final TextRes? text;
  final BannerBlogRes? bannerBlog;
  final String? loginTitle;
  final String? loginText;
  final String? loginAgree;

  HomeTrendingRes({
    required this.trending,
    this.gainers,
    this.losers,
    required this.popular,
    this.text,
    this.trendingNews,
    this.bannerBlog,
    this.loginText,
    this.loginTitle,
    this.loginAgree,
  });

  factory HomeTrendingRes.fromJson(Map<String, dynamic> json) =>
      HomeTrendingRes(
        popular: List<Top>.from(json["actives"].map((x) => Top.fromJson(x))),
        loginAgree: json['common_login_agree'],
        trendingNews: json["trending_news"] == null
            ? []
            : List<News>.from(
                json["trending_news"]!.map((x) => News.fromJson(x))),
        text: json["text"] == null ? null : TextRes.fromJson(json["text"]),
        trending: List<HomeTrendingData>.from(
            json["trending"].map((x) => HomeTrendingData.fromJson(x))),
        gainers: json["gainers"] == null
            ? null
            : List<Top>.from(json["gainers"].map((x) => Top.fromJson(x))),
        losers: json["gainers"] == null
            ? null
            : List<Top>.from(json["losers"].map((x) => Top.fromJson(x))),
        bannerBlog: json["banner_blog"] == null
            ? null
            : BannerBlogRes.fromJson(json["banner_blog"]),
        loginTitle: json['common_login_title'],
        loginText: json['common_login_text'],
      );

  Map<String, dynamic> toJson() => {
        'common_login_title': loginTitle,
        'common_login_agree': loginAgree,
        'common_login_text': loginText,
        "trending": List<dynamic>.from(trending.map((x) => x.toJson())),
        "trending_news": trendingNews == null
            ? []
            : List<dynamic>.from(trendingNews!.map((x) => x.toJson())),
        "actives": List<dynamic>.from(popular.map((x) => x.toJson())),
        "text": text?.toJson(),
        "gainers": gainers == null
            ? null
            : List<dynamic>.from(gainers!.map((x) => x.toJson())),
        "losers": losers == null
            ? null
            : List<dynamic>.from(losers!.map((x) => x.toJson())),
        "banner_blog": bannerBlog?.toJson(),
      };
}

class TextRes {
  final String? trending;
  final String? gainers;
  final String? losers;
  final String? recentMentions;
  final String? hotStocks;
  final String? mostBullish;
  final String? mostBearish;
  final String? sectors;
  final String? generalNews;
  final String? now;
  final String? recently;
  final String? cap;
  final String? mentionText;
  final String? subTitle;
  final String? note;
  final String? other;
  final String? sentimentText;
  final String? news;
  final String? title;

  TextRes({
    this.trending,
    this.gainers,
    this.losers,
    this.recentMentions,
    this.hotStocks,
    this.mostBullish,
    this.mostBearish,
    this.sectors,
    this.generalNews,
    this.now,
    this.recently,
    this.sentimentText,
    this.subTitle,
    this.cap,
    this.mentionText,
    this.note,
    this.other,
    this.news,
    this.title,
  });

  factory TextRes.fromJson(Map<String, dynamic> json) => TextRes(
      trending: json["trending"],
      gainers: json["gainers"],
      losers: json["losers"],
      subTitle: json["sub_title"],
      news: json['news'],
      mentionText: json["mentions_text"],
      recentMentions: json["recent_mentions"],
      hotStocks: json["hot_stocks"],
      mostBullish: json["most_bullish"],
      mostBearish: json["most_bearish"],
      sectors: json["sectors"],
      generalNews: json["general_news"],
      now: json["now"],
      note: json["note"],
      sentimentText: json["sentiment_text"],
      other: json["other"],
      recently: json["recently"],
      cap: json["cap"],
      title: json["title"]);

  Map<String, dynamic> toJson() => {
        "trending": trending,
        "gainers": gainers,
        "losers": losers,
        "mentions_text": mentionText,
        "sentiment_text": sentimentText,
        "recent_mentions": recentMentions,
        "hot_stocks": hotStocks,
        "most_bullish": mostBullish,
        "most_bearish": mostBearish,
        "sub_title": subTitle,
        "sectors": sectors,
        "general_news": generalNews,
        "note": note,
        'news': news,
        "other": other,
        "now": now,
        "recently": recently,
        "cap": cap,
        "title": title,
      };
}

class Top {
  final String name;
  final String symbol;
  final String price;
  final num changesPercentage;
  final String? image;
  final bool gained;
  final String displayChange;
  num? isAlertAdded;
  num? isWatchlistAdded;

  Top({
    required this.name,
    required this.symbol,
    required this.price,
    required this.changesPercentage,
    required this.image,
    this.gained = false,
    required this.displayChange,
    this.isAlertAdded,
    this.isWatchlistAdded,
  });

  factory Top.fromJson(Map<String, dynamic> json) => Top(
        name: json["name"],
        symbol: json["symbol"],
        price: json["price"],
        displayChange: json["display_change"],
        changesPercentage: json["changesPercentage"],
        image: json["image"],
        isAlertAdded: json["is_alert_added"],
        isWatchlistAdded: json["is_watchlist_added"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "symbol": symbol,
        "price": price,
        "display_change": displayChange,
        "changesPercentage": changesPercentage,
        "image": image,
        "is_alert_added": isAlertAdded,
        "is_watchlist_added": isWatchlistAdded,
      };
}

class BannerBlogRes {
  // final String id;
  // final String blogId;
  final String? name;
  final String? image;
  final String? publishedDateString;
  final String? slug;
  final int? isPremium;
  final String? headingText;
  // final DateTime updatedAt;
  // final DateTime createdAt;

  BannerBlogRes({
    // required this.id,
    // required this.blogId,
    this.name,
    this.headingText,
    this.image,
    this.publishedDateString,
    this.slug,
    this.isPremium,
    // required this.updatedAt,
    // required this.createdAt,
  });

  factory BannerBlogRes.fromJson(Map<String, dynamic> json) => BannerBlogRes(
        // id: json["_id"],
        // blogId: json["blog_id"],
        name: json["name"],
        headingText: json["heading_text"],
        image: json["image"],
        publishedDateString: json["published_date_string"],
        slug: json["slug"],
        isPremium: json["is_premium"],
        // updatedAt: DateTime.parse(json["updated_at"]),
        // createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        // "_id": id,
        // "blog_id": blogId,
        "name": name,
        "image": image,
        "heading_text": headingText,
        "published_date_string": publishedDateString,
        "slug": slug,
        "is_premium": isPremium,
        // "updated_at": updatedAt.toIso8601String(),
        // "created_at": createdAt.toIso8601String(),
      };
}

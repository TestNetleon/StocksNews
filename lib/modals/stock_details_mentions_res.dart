import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/home_insider_res.dart';
import 'package:stocks_news_new/utils/colors.dart';

StockDetailMentionRes stockDetailMentionResFromJson(String str) =>
    StockDetailMentionRes.fromJson(json.decode(str));

String stockDetailMentionResToJson(StockDetailMentionRes data) =>
    json.encode(data.toJson());

//
class StockDetailMentionRes {
  // final KeyStats? keyStats;
  // final CompanyInfo? companyInfo;
  // num? isAlertAdded;
  // num? isWatchlistAdded;

  final List<TradingStock>? tradingStock;
  final List<Mentions>? mentions;
  final List<RedditPost>? redditPost;
  final List<News>? newsPost;
  // final List<TopPost>? topPosts;
  final String? forecastAnalyst;
  final String? mentionText;
  final String? forecastText;
  final String? technicalText;

  StockDetailMentionRes({
    // this.keyStats,
    // this.companyInfo,
    this.tradingStock,
    // this.isAlertAdded,
    // this.isWatchlistAdded,
    this.mentions,
    this.redditPost,
    this.newsPost,
    // this.topPosts,
    this.forecastAnalyst,
    this.forecastText,
    this.mentionText,
    this.technicalText,
  });

  factory StockDetailMentionRes.fromJson(Map<String, dynamic> json) =>
      StockDetailMentionRes(
        // keyStats: json["key_stats"] == null
        //     ? null
        //     : KeyStats.fromJson(json["key_stats"]),
        // companyInfo: json["company_info"] == null
        //     ? null
        //     : CompanyInfo.fromJson(json["company_info"]),
        tradingStock: json["trading_stock"] == null
            ? []
            : List<TradingStock>.from(
                json["trading_stock"]?.map((x) => TradingStock.fromJson(x))),
        // isAlertAdded: json["is_alert_added"],
        // isWatchlistAdded: json["is_watchlist_added"],
        mentions: json["mentions"] == null
            ? []
            : List<Mentions>.from(
                json["mentions"]?.map((x) => Mentions.fromJson(x))),
        redditPost: json["reddit_post"] == null
            ? []
            : List<RedditPost>.from(
                json["reddit_post"]?.map((x) => RedditPost.fromJson(x))),
        newsPost: json["top_posts"] == null
            ? []
            : List<News>.from(json["top_posts"]!.map((x) => News.fromJson(x))),
        forecastAnalyst: json["forecast_analyst"],
        forecastText: json["forecast_text"],
        mentionText: json["mention_text"],
        technicalText: json["technical_text"],
      );

  Map<String, dynamic> toJson() => {
        // "key_stats": keyStats?.toJson(),
        // "company_info": companyInfo?.toJson(),
        "trading_stock": tradingStock == null
            ? []
            : List<dynamic>.from(tradingStock!.map((x) => x.toJson())),
        // "is_alert_added": isAlertAdded,
        // "is_watchlist_added": isWatchlistAdded,
        "mentions": mentions == null
            ? []
            : List<dynamic>.from(mentions!.map((x) => x.toJson())),
        "reddit_post": redditPost == null
            ? []
            : List<dynamic>.from(redditPost!.map((x) => x)),
        "top_posts": newsPost == null
            ? []
            : List<dynamic>.from(newsPost!.map((x) => x.toJson())),
        "forecast_analyst": forecastAnalyst,
        "forecast_text": forecastText,
        "mention_text": mentionText,
        "technical_text": technicalText,
      };
}

class TopPost {
  final String? title;
  final String? image;
  final String? postDate;
  final String? site;

  TopPost({
    this.title,
    this.image,
    this.postDate,
    this.site,
  });

  factory TopPost.fromJson(Map<String, dynamic> json) => TopPost(
        title: json["title"],
        image: json["image"],
        postDate: json["post_date"],
        site: json["site"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "image": image,
        "post_date": postDate,
        "site": site,
      };
}

class TradingStock {
  // final String? id;
  // final num? rank;
  // final DateTime? date;
  final String name;
  final String symbol;
  // final num? sentiment;
  // final num? lastSentiment;
  final String? price;
  final num? change;
  final String? image;
  final num? changesPercentage;
  // final DateTime? updatedAt;
  // final DateTime? createdAt;
  // final List<Mention>? mentions;

  TradingStock({
    // this.id,
    // this.rank,
    // this.date,
    required this.name,
    required this.symbol,
    // this.sentiment,
    // this.lastSentiment,
    this.price,
    this.change,
    this.image,
    this.changesPercentage,
    // this.updatedAt,
    // this.createdAt,
    // this.mentions,
  });

  factory TradingStock.fromJson(Map<String, dynamic> json) => TradingStock(
        // id: json["_id"],
        // rank: json["rank"],
        // date: json["date"] == null ? null : DateTime.parse(json["date"]),
        name: json["name"],
        symbol: json["symbol"],
        // sentiment: json["sentiment"]?.toDouble(),
        // lastSentiment: json["last_sentiment"]?.toDouble(),
        price: json["price"],
        change: json["change"],
        image: json["image"],
        changesPercentage: json["changesPercentage"]?.toDouble(),
        // updatedAt: json["updated_at"] == null
        //     ? null
        //     : DateTime.parse(json["updated_at"]),
        // createdAt: json["created_at"] == null
        //     ? null
        //     : DateTime.parse(json["created_at"]),
        // mentions: json["mentions"] == null
        //     ? []
        //     : List<Mention>.from(
        //         json["mentions"]!.map((x) => Mention.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        // "_id": id,
        // "rank": rank,
        // "date":
        //     "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "name": name,
        "symbol": symbol,
        // "sentiment": sentiment,
        // "last_sentiment": lastSentiment,
        "price": price,
        "change": change,
        "image": image,
        "changesPercentage": changesPercentage,
        // "updated_at": updatedAt?.toIso8601String(),
        // "created_at": createdAt?.toIso8601String(),
        // "mentions": mentions == null
        //     ? []
        //     : List<dynamic>.from(mentions!.map((x) => x.toJson())),
      };
}

class Mentions {
  final String? website;
  final num? mentionCount;
  Color color;

  Mentions({
    required this.website,
    required this.mentionCount,
    this.color = ThemeColors.accent,
  });

  factory Mentions.fromJson(Map<String, dynamic> json) => Mentions(
        website: json["website"],
        mentionCount: json["mention_count"],
      );

  Map<String, dynamic> toJson() => {
        "website": website,
        "mention_count": mentionCount,
      };
}

class RedditPost {
  // final String id;
  // final dynamic token;
  // final String media;
  // final String website;
  // final String title;
  final String text;
  // final String symbol;
  final String subredditNamePrefixed;
  // final String linkFlairText;
  // final String url;
  // final String subredditId;
  // final DateTime createdAt;
  // final bool mentionStatus;
  // final bool recentMentionStatus;
  // final num status;
  // final num change;
  // final String image;
  // final String companyName;
  // final String exchange;
  // final DateTime publishedDate;
  // final DateTime updatedAt;

  RedditPost({
    // required this.id,
    // required this.token,
    // required this.media,
    // required this.website,
    // required this.title,
    required this.text,
    // required this.symbol,
    required this.subredditNamePrefixed,
    // required this.linkFlairText,
    // required this.url,
    // required this.subredditId,
    // required this.createdAt,
    // required this.mentionStatus,
    // required this.recentMentionStatus,
    // required this.status,
    // required this.change,
    // required this.image,
    // required this.companyName,
    // required this.exchange,
    // required this.publishedDate,
    // required this.updatedAt,
  });

  factory RedditPost.fromJson(Map<String, dynamic> json) => RedditPost(
        // id: json["_id"],
        // token: json["token"],
        // media: json["media"],
        // website: json["website"],
        // title: json["title"],
        text: json["text"],
        // symbol: json["symbol"],
        subredditNamePrefixed: json["subreddit_name_prefixed"],
        // linkFlairText: json["link_flair_text"],
        // url: json["url"],
        // subredditId: json["subreddit_id"],
        // createdAt: DateTime.parse(json["created_at"]),
        // mentionStatus: json["mention_status"],
        // recentMentionStatus: json["recent_mention_status"],
        // status: json["status"],
        // change: json["change"]?.toDouble(),
        // image: json["image"],
        // companyName: json["companyName"],
        // exchange: json["exchange"],
        // publishedDate: DateTime.parse(json["published_date"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        // "_id": id,
        // "token": token,
        // "media": media,
        // "website": website,
        // "title": title,
        "text": text,
        // "symbol": symbol,
        "subreddit_name_prefixed": subredditNamePrefixed,
        // "link_flair_text": linkFlairText,
        // "url": url,
        // "subreddit_id": subredditId,
        // "created_at": createdAt.toIso8601String(),
        // "mention_status": mentionStatus,
        // "recent_mention_status": recentMentionStatus,
        // "status": status,
        // "change": change,
        // "image": image,
        // "companyName": companyName,
        // "exchange": exchange,
        // "published_date": publishedDate.toIso8601String(),
        // "updated_at": updatedAt.toIso8601String(),
      };
}

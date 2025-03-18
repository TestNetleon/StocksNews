// To parse this JSON data, do
//
//     final newsDetailRes = newsDetailResFromJson(jsonString);

import 'dart:convert';

import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/models/news.dart';
import 'package:stocks_news_new/models/ticker.dart';

import '../lock.dart';

NewsDetailRes newsDetailResFromJson(String str) =>
    NewsDetailRes.fromJson(json.decode(str));

String newsDetailResToJson(NewsDetailRes data) => json.encode(data.toJson());

class NewsDetailRes {
  final NewsPostDetailRes? postDetail;
  final MoreNewsRes? moreNews;
  final FeedbackRes? feedback;
  final BaseLockInfoRes? lockInfo;
  final BaseLockInfoRes? simulatorLockInfo;

  NewsDetailRes({
    this.postDetail,
    this.moreNews,
    this.feedback,
    this.lockInfo,
    this.simulatorLockInfo,
  });

  factory NewsDetailRes.fromJson(Map<String, dynamic> json) => NewsDetailRes(
        lockInfo: json["lock_info"] == null
            ? null
            : BaseLockInfoRes.fromJson(json["lock_info"]),
        feedback: json["feedback"] == null
            ? null
            : FeedbackRes.fromJson(json["feedback"]),
        postDetail: json["post_detail"] == null
            ? null
            : NewsPostDetailRes.fromJson(json["post_detail"]),
        moreNews: json["more_news"] == null
            ? null
            : MoreNewsRes.fromJson(json["more_news"]),
      simulatorLockInfo: json["simulator_lock_info"] == null
          ? null
          : BaseLockInfoRes.fromJson(json["simulator_lock_info"]),

      );

  Map<String, dynamic> toJson() => {
        "lock_info": lockInfo?.toJson(),
        "feedback": feedback?.toJson(),
        "post_detail": postDetail?.toJson(),
        "more_news": moreNews?.toJson(),
        "simulator_lock_info": simulatorLockInfo?.toJson(),
      };
}

class MoreNewsRes {
  final String? title;
  final List<BaseNewsRes>? data;

  MoreNewsRes({
    this.title,
    this.data,
  });

  factory MoreNewsRes.fromJson(Map<String, dynamic> json) => MoreNewsRes(
        title: json["title"],
        data: json["data"] == null
            ? []
            : List<BaseNewsRes>.from(
                json["data"]!.map((x) => BaseNewsRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

FeedbackRes feedbackResFromMap(String str) => FeedbackRes.fromJson(json.decode(str));

String feedbackResToMap(FeedbackRes data) => json.encode(data.toJson());

class FeedbackRes {
  final String? title;
  String? existMessage;
  final List<MarketResData>? type;
  final String? placeholderText;
  final String? buttonText;
  FeedbackRes({
    this.title,
    this.type,
    this.existMessage,
    this.placeholderText,
    this.buttonText,
  });

  factory FeedbackRes.fromJson(Map<String, dynamic> json) => FeedbackRes(
        title: json["title"],
        existMessage: json['exist_msg'],
        type: json["type"] == null
            ? []
            : List<MarketResData>.from(
                json["type"]!.map((x) => MarketResData.fromJson(x))),
    placeholderText: json["placeholder_text"],
    buttonText: json["button_text"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        'exist_msg': existMessage,
        "type": type == null
            ? []
            : List<dynamic>.from(type!.map((x) => x.toJson())),
    "placeholder_text": placeholderText,
    "button_text": buttonText,
      };
}

class NewsPostDetailRes {
  final String? id;
  final String? title;
  final String? text;
  final String? uri;
  final List<NewsAuthorRes>? authors;
  final List<NewsAuthorRes>? categories;
  final List<NewsAuthorRes>? tags;
  final String? image;
  final String? site;
  final String? shareUrl;
  final List<BaseTickerRes>? tickers;
  final String? publishedDate;

  NewsPostDetailRes({
    this.id,
    this.title,
    this.uri,
    this.text,
    this.authors,
    this.categories,
    this.tags,
    this.image,
    this.site,
    this.shareUrl,
    this.tickers,
    this.publishedDate,
  });

  factory NewsPostDetailRes.fromJson(Map<String, dynamic> json) =>
      NewsPostDetailRes(
        id: json["_id"],
        title: json["title"],
        uri: json['uri'],
        text: json["text"],
        authors: json["authors"] == null
            ? []
            : List<NewsAuthorRes>.from(
                json["authors"].map((x) => NewsAuthorRes.fromJson(x))),
        categories: json["categories"] == null
            ? []
            : List<NewsAuthorRes>.from(
                json["categories"].map((x) => NewsAuthorRes.fromJson(x))),
        tags: json["tags"] == null
            ? []
            : List<NewsAuthorRes>.from(
                json["tags"].map((x) => NewsAuthorRes.fromJson(x))),
        image: json["image"],
        site: json["site"],
        shareUrl: json["share_url"],
        tickers: json["tickers"] == null
            ? []
            : List<BaseTickerRes>.from(
                json["tickers"].map((x) => BaseTickerRes.fromJson(x))),
        publishedDate: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "text": text,
        'uri': uri,
        "authors": authors == null
            ? []
            : List<dynamic>.from(authors!.map((x) => x.toJson())),
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "image": image,
        "site": site,
        "share_url": shareUrl,
        "tickers":
            tickers == null ? [] : List<dynamic>.from(tickers!.map((x) => x)),
        "date": publishedDate,
      };
}

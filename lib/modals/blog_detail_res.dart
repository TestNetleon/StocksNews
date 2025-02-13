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
  final List<NewsTicker>? tickers;
  // final List<BlogItemRes> categories;
  // final List<BlogItemRes> tags;
  // final BlogDetail? blogDetail;
  final DateTime? publishedDate;
  final String? postDateString;
  final String image;
  String? feedbackMsg;
  String? feedbackExistMsg;
  bool? readingStatus;
  String? readingTitle;
  String? readingSubtitle;
  String? warningText;

  bool? balanceStatus;
  dynamic totalPoints;
  dynamic pointsRequired;
  final String? popUpMessage;
  final String? popUpButton;
  final bool? premiumReaderOnly;
  dynamic showUpgradeBtn;
  dynamic showSubscribeBtn;

  BlogsDetailRes({
    required this.id,
    required this.name,
    required this.description,
    this.authors,
    this.postDateString,
    this.tickers,
    this.popUpMessage,
    this.popUpButton,
    required this.slug,
    // required this.categories,
    // required this.tags,
    this.publishedDate,
    required this.image,
    this.feedbackMsg,
    this.feedbackExistMsg,
    this.readingStatus,
    this.readingTitle,
    this.readingSubtitle,
    this.warningText,
    this.balanceStatus,
    this.totalPoints,
    this.pointsRequired,
    this.premiumReaderOnly,
    this.showUpgradeBtn,
    this.showSubscribeBtn,
  });

  factory BlogsDetailRes.fromJson(Map<String, dynamic> json) => BlogsDetailRes(
        id: json["_id"],
        premiumReaderOnly: json['premium_readers_only'],
        name: json["name"],
        popUpMessage: json["popup_message"],
        popUpButton: json["popup_button"],
        tickers: json["tickers"] == null
            ? []
            : List<NewsTicker>.from(
                json["tickers"]!.map((x) => NewsTicker.fromJson(x))),
        description: json["description"],
        warningText: json["warning_text"],

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
        readingStatus: json["reading_status"],
        readingTitle: json["reading_title"],
        readingSubtitle: json["reading_subtitle"],
        balanceStatus: json["balance_status"],
        totalPoints: json["total_points"],
        pointsRequired: json["point_required"],
        showUpgradeBtn: json["show_upgrade_btn"],
        showSubscribeBtn: json["show_subscribe_btn"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "popup_message": popUpMessage,
        "popup_button": popUpButton,
        "warning_text": warningText,

        "description": description,
        'published_date_string': postDateString,
        "slug": slug,
        "tickers": tickers == null
            ? []
            : List<dynamic>.from(tickers!.map((x) => x.toJson())),
        "authors": authors == null
            ? []
            : List<dynamic>.from(authors!.map((x) => x.toJson())),
        // "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        // "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
        "published_date": publishedDate?.toIso8601String(),
        "image": image,
        "feedback_msg": feedbackMsg,
        'premium_readers_only': premiumReaderOnly,
        "feedback_exist_msg": feedbackExistMsg,
        "reading_status": readingStatus,
        "reading_title": readingTitle,
        "reading_subtitle": readingSubtitle,
        "balance_status": balanceStatus,
        "total_points": totalPoints,
        "point_required": pointsRequired,
        "show_upgrade_btn": showUpgradeBtn,
        "show_subscribe_btn": showSubscribeBtn,
      };
}

import 'dart:convert';

NewsDetailDataRes newsDetailDataResFromJson(String str) =>
    NewsDetailDataRes.fromJson(json.decode(str));

String newsDetailDataResToJson(NewsDetailDataRes data) =>
    json.encode(data.toJson());

class NewsDetailDataRes {
  final PostDetail? postDetail;
  final List<PostDetail>? otherPost;
  String? feedbackMsg;
  String? feedbackExistMsg;

  NewsDetailDataRes({
    this.postDetail,
    this.otherPost,
    this.feedbackMsg,
    this.feedbackExistMsg,
  });

  factory NewsDetailDataRes.fromJson(Map<String, dynamic> json) =>
      NewsDetailDataRes(
        postDetail: json["post_detail"] == null
            ? null
            : PostDetail.fromJson(json["post_detail"]),
        otherPost: json["other_post"] == null
            ? []
            : List<PostDetail>.from(
                json["other_post"]!.map((x) => PostDetail.fromJson(x))),
        feedbackExistMsg: json["feedback_exist_msg"],
        feedbackMsg: json["feedback_msg"],
      );

  Map<String, dynamic> toJson() => {
        "post_detail": postDetail?.toJson(),
        "other_post": otherPost == null
            ? []
            : List<dynamic>.from(otherPost!.map((x) => x.toJson())),
        "feedback_msg": feedbackMsg,
        "feedback_exist_msg": feedbackExistMsg,
      };
}

class PostDetail {
  final String? id;
  final String? summary;
  // final String? api;
  // final String? symbol;
  final DateTime? publishedDate;
  final String? postDateString;
  final String? title;
  final String? slug;
  final String? permalink;

  final List<NewsTicker>? tickers;
  final String? image;
  final String? site;
  final String? source;
  final String? newsType;
  final String? text;
  final String? url;
  final List<DetailListType>? authors;
  final List<DetailListType>? categories;
  final List<DetailListType>? tags;
  bool? readingStatus;
  String? readingTitle;
  String? readingSubtitle;
  String? warningText;
  bool? balanceStatus;
  final String? popUpMessage;
  final String? popUpButton;
  dynamic totalPoints;
  dynamic pointsRequired;
  dynamic pointDeduction;
  dynamic showUpgradeBtn;
  dynamic showSubscribeBtn;
  final bool? premiumReaderOnly;

  // final int? status;
  // final String? sector;
  // final bool? mentionStatus;
  // final bool? recentMentionStatus;
  // final DateTime? updatedAt;
  // final DateTime? createdAt;
  // final int? views;

  PostDetail({
    this.id,
    this.summary,
    this.newsType,
    // this.api,
    // this.symbol,
    this.publishedDate,
    this.title,
    this.postDateString,
    this.slug,
    this.image,
    this.site,
    this.permalink,
    this.source,
    this.text,
    this.url,
    this.authors,
    this.tickers,
    this.categories,
    this.tags,
    this.readingStatus,
    this.readingTitle,
    this.readingSubtitle,
    this.warningText,
    this.balanceStatus,
    this.totalPoints,
    this.pointsRequired,
    this.pointDeduction,
    this.showUpgradeBtn,
    this.showSubscribeBtn,
    this.popUpMessage,
    this.popUpButton,
    this.premiumReaderOnly,
    // this.status,
    // this.sector,
    // this.mentionStatus,
    // this.recentMentionStatus,
    // this.updatedAt,
    // this.createdAt,
    // this.views,
  });

  factory PostDetail.fromJson(Map<String, dynamic> json) => PostDetail(
        id: json["_id"],
        newsType: json['news_type'],
        premiumReaderOnly: json['premium_readers_only'],
        // api: json["api"],
        // symbol: json["symbol"],
        publishedDate: json["published_date"] == null
            ? null
            : DateTime.parse(json["published_date"]),
        title: json["title"],
        source: json["source"],
        permalink: json["permalink"],
        readingStatus: json["reading_status"],
        summary: json['summary'],
        readingTitle: json["reading_title"],
        readingSubtitle: json["reading_subtitle"],
        warningText: json["warning_text"],

        balanceStatus: json["balance_status"],
        postDateString: json['published_date_string'],
        slug: json["slug"],
        popUpMessage: json["popup_message"],
        popUpButton: json["popup_button"],
        authors: json["authors"] == null
            ? []
            : List<DetailListType>.from(
                json["authors"]!.map((x) => DetailListType.fromJson(x))),
        categories: json["categories"] == null
            ? []
            : List<DetailListType>.from(
                json["categories"]!.map((x) => DetailListType.fromJson(x))),
        tags: json["tags"] == null
            ? []
            : List<DetailListType>.from(
                json["tags"]!.map((x) => DetailListType.fromJson(x))),
        image: json["image"],
        tickers: json["tickers"] == null
            ? []
            : List<NewsTicker>.from(
                json["tickers"]!.map((x) => NewsTicker.fromJson(x))),

        site: json["site"],
        text: json["text"],
        url: json["url"],
        totalPoints: json["total_points"],
        pointsRequired: json["point_required"],
        pointDeduction: json["point_deduction"],
        showUpgradeBtn: json["show_upgrade_btn"],
        showSubscribeBtn: json["show_subscribe_btn"],
        // status: json["status"],
        // sector: json["sector"],
        // mentionStatus: json["mention_status"],
        // recentMentionStatus: json["recent_mention_status"],
        // updatedAt: json["updated_at"] == null
        //     ? null
        //     : DateTime.parse(json["updated_at"]),
        // createdAt: json["created_at"] == null
        //     ? null
        //     : DateTime.parse(json["created_at"]),
        // views: json["views"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        // "api": api,
        // "symbol": symbol,
        "published_date": publishedDate?.toIso8601String(),
        "title": title,
        "slug": slug,
        'premium_readers_only': premiumReaderOnly,
        "news_type": newsType,
        "permalink": permalink,
        "reading_status": readingStatus,
        "reading_title": readingTitle,
        "source": source,
        "reading_subtitle": readingSubtitle,
        "warning_text": warningText,

        "balance_status": balanceStatus,
        'summary': summary,
        'published_date_string': postDateString,
        "image": image,
        "site": site,
        "tickers": tickers == null
            ? []
            : List<dynamic>.from(tickers!.map((x) => x.toJson())),

        "text": text,
        "url": url,
        "popup_message": popUpMessage,
        "popup_button": popUpButton,
        "authors": authors == null
            ? []
            : List<dynamic>.from(authors!.map((x) => x.toJson())),
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "tags": tags == null
            ? []
            : List<dynamic>.from(tags!.map((x) => x.toJson())),
        // "status": status,
        // "sector": sector,
        // "mention_status": mentionStatus,
        // "recent_mention_status": recentMentionStatus,
        // "updated_at": updatedAt?.toIso8601String(),
        // "created_at": createdAt?.toIso8601String(),
        // "views": views,
        "total_points": totalPoints,
        "point_required": pointsRequired,
        "point_deduction": pointDeduction,
        "show_upgrade_btn": showUpgradeBtn,
        "show_subscribe_btn": showSubscribeBtn,
      };
}

class DetailListType {
  final String? id;
  final String? name;
  final String? designation;
  final String? text;
  final String? image;
  final String? slug;
  final bool? show;

  DetailListType({
    this.id,
    this.name,
    this.show,
    this.designation,
    this.text,
    this.image,
    this.slug,
  });

  factory DetailListType.fromJson(Map<String, dynamic> json) => DetailListType(
        id: json["_id"],
        name: json["name"],
        designation: json['designation'],
        show: json['show_bio'],
        image: json['image'],
        slug: json['slug'],
        text: json['text'],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        'show_bio': show,
        "designation": designation,
        "image": image,
        "slug": slug,
        "text": text,
      };
}

class NewsTicker {
  final String? id;
  final String? symbol;
  final String? name;
  final String? image;

  NewsTicker({
    this.id,
    this.symbol,
    this.name,
    this.image,
  });

  factory NewsTicker.fromJson(Map<String, dynamic> json) => NewsTicker(
        id: json["_id"],
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "symbol": symbol,
        "name": name,
        "image": image,
      };
}

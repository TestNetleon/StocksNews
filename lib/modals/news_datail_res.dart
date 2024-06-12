import 'dart:convert';

NewsDetailDataRes newsDetailDataResFromJson(String str) =>
    NewsDetailDataRes.fromJson(json.decode(str));

String newsDetailDataResToJson(NewsDetailDataRes data) =>
    json.encode(data.toJson());

class NewsDetailDataRes {
  final PostDetail? postDetail;
  final List<PostDetail>? otherPost;
//
  NewsDetailDataRes({
    this.postDetail,
    this.otherPost,
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
      );

  Map<String, dynamic> toJson() => {
        "post_detail": postDetail?.toJson(),
        "other_post": otherPost == null
            ? []
            : List<dynamic>.from(otherPost!.map((x) => x.toJson())),
      };
}

class PostDetail {
  // final String? id;
  // final String? api;
  // final String? symbol;
  final DateTime? publishedDate;
  final String? postDateString;
  final String? title;
  final String? slug;
  final String? image;
  final String? site;
  final String? text;
  final String? url;
  final List<DetailListType>? authors;
  final List<DetailListType>? categories;
  final List<DetailListType>? tags;

  // final int? status;
  // final String? sector;
  // final bool? mentionStatus;
  // final bool? recentMentionStatus;
  // final DateTime? updatedAt;
  // final DateTime? createdAt;
  // final int? views;

  PostDetail({
    // this.id,
    // this.api,
    // this.symbol,
    this.publishedDate,
    this.title,
    this.postDateString,
    this.slug,
    this.image,
    this.site,
    this.text,
    this.url,
    this.authors,
    this.categories,
    this.tags,
    // this.status,
    // this.sector,
    // this.mentionStatus,
    // this.recentMentionStatus,
    // this.updatedAt,
    // this.createdAt,
    // this.views,
  });

  factory PostDetail.fromJson(Map<String, dynamic> json) => PostDetail(
        // id: json["_id"],
        // api: json["api"],
        // symbol: json["symbol"],
        publishedDate: json["published_date"] == null
            ? null
            : DateTime.parse(json["published_date"]),
        title: json["title"],
        postDateString: json['published_date_string'],
        slug: json["slug"],
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
        site: json["site"],
        text: json["text"],
        url: json["url"],
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
        // "_id": id,
        // "api": api,
        // "symbol": symbol,
        "published_date": publishedDate?.toIso8601String(),
        "title": title,
        "slug": slug,
        'published_date_string': postDateString,
        "image": image,
        "site": site,
        "text": text,
        "url": url,
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

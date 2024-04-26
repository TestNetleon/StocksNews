import 'dart:convert';

import 'news_datail_res.dart';

NewsRes newsResFromJson(String str) => NewsRes.fromJson(json.decode(str));

String newsResToJson(NewsRes data) => json.encode(data.toJson());

class NewsRes {
  // final num currentPage;
  final List<NewsData> data;
  // final String firstPageUrl;
  // final num from;
  final num lastPage;
  // final String lastPageUrl;
  // final List<Link> links;
  // final String nextPageUrl;
  // final String path;
  // final num perPage;
  // final dynamic prevPageUrl;
  // final num to;
  // final num total;

  NewsRes({
    // required this.currentPage,
    required this.data,
    // required this.firstPageUrl,
    // required this.from,
    required this.lastPage,
    // required this.lastPageUrl,
    // required this.links,
    // required this.nextPageUrl,
    // required this.path,
    // required this.perPage,
    // required this.prevPageUrl,
    // required this.to,
    // required this.total,
  });

  factory NewsRes.fromJson(Map<String, dynamic> json) => NewsRes(
        // currentPage: json["current_page"],
        data:
            List<NewsData>.from(json["data"].map((x) => NewsData.fromJson(x))),
        // firstPageUrl: json["first_page_url"],
        // from: json["from"],
        lastPage: json["last_page"],
        // lastPageUrl: json["last_page_url"],
        // links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        // nextPageUrl: json["next_page_url"],
        // path: json["path"],
        // perPage: json["per_page"],
        // prevPageUrl: json["prev_page_url"],
        // to: json["to"],
        // total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        // "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        // "first_page_url": firstPageUrl,
        // "from": from,
        "last_page": lastPage,
        // "last_page_url": lastPageUrl,
        // "links": List<dynamic>.from(links.map((x) => x.toJson())),
        // "next_page_url": nextPageUrl,
        // "path": path,
        // "per_page": perPage,
        // "prev_page_url": prevPageUrl,
        // "to": to,
        // "total": total,
      };
}

class NewsData {
  // final String id;
  // final String? api;
  // final String symbol;
  final DateTime publishedDate;
  final String title;
  final String slug;
  final String image;
  final String? site;
  final String? postDate;
  final String? text;
  final String? url;
  final List<DetailListType>? authors;

  // final num status;
  // final String sector;
  // final bool mentionStatus;
  // final bool recentMentionStatus;
  // final DateTime updatedAt;
  // final DateTime createdAt;

  NewsData({
    // required this.id,
    // required this.api,
    // required this.symbol,
    required this.publishedDate,
    required this.title,
    required this.slug,
    required this.image,
    required this.site,
    required this.postDate,
    required this.text,
    required this.url,
    this.authors,

    // required this.status,
    // required this.sector,
    // required this.mentionStatus,
    // required this.recentMentionStatus,
    // required this.updatedAt,
    // required this.createdAt,
  });

  factory NewsData.fromJson(Map<String, dynamic> json) => NewsData(
        // id: json["_id"],
        // api: json["api"],
        // symbol: json["symbol"],
        publishedDate: DateTime.parse(json["published_date"]),
        title: json["title"],
        slug: json["slug"],
        image: json["image"],
        site: json["site"],
        postDate: json["post_date"],
        text: json["text"],
        url: json["url"],
        authors: json["authors"] == null
            ? []
            : List<DetailListType>.from(
                json["authors"]!.map((x) => DetailListType.fromJson(x))),
        // status: json["status"],
        // sector: json["sector"],
        // mentionStatus: json["mention_status"],
        // recentMentionStatus: json["recent_mention_status"],
        // updatedAt: DateTime.parse(json["updated_at"]),
        // createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        // "_id": id,
        // "api": api,
        // "symbol": symbol,
        "published_date": publishedDate.toIso8601String(),
        "title": title,
        "slug": slug,
        "image": image,
        "site": site,
        "post_date": postDate,
        "text": text,
        "url": url,
        "authors": authors == null
            ? []
            : List<dynamic>.from(authors!.map((x) => x.toJson())),
        // "status": status,
        // "sector": sector,
        // "mention_status": mentionStatus,
        // "recent_mention_status": recentMentionStatus,
        // "updated_at": updatedAt.toIso8601String(),
        // "created_at": createdAt.toIso8601String(),
      };
}

class Link {
  final String? url;
  final String label;
  final bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}

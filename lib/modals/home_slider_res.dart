import 'dart:convert';

import 'news_datail_res.dart';

HomeSliderRes homeSliderResFromJson(String str) =>
    HomeSliderRes.fromJson(json.decode(str));

String homeSliderResToJson(HomeSliderRes data) => json.encode(data.toJson());

class HomeSliderRes {
  final List<SliderPost>? sliderPosts;
  final int totalAlerts;
  final int totalWatchList;
  final String? whatsappLink;
  final String? telegramLink;
  final String? shareUrl;
  final String? shareText;
  final TextSliderRes text;

  HomeSliderRes({
    this.sliderPosts,
    this.whatsappLink,
    this.telegramLink,
    this.shareUrl,
    this.shareText,
    required this.totalAlerts,
    required this.text,
    required this.totalWatchList,
  });
//
  factory HomeSliderRes.fromJson(Map<String, dynamic> json) => HomeSliderRes(
        totalAlerts: json["total_alerts"],
        whatsappLink: json["whats-app-link"],
        text: TextSliderRes.fromJson(json["text"]),
        telegramLink: json['telegram-link'],
        shareUrl: json["share-url"],
        shareText: json["share_text"],
        totalWatchList: json["total_watchlist"],
        sliderPosts: json["slider_posts"] == null
            ? []
            : List<SliderPost>.from(
                json["slider_posts"]!.map((x) => SliderPost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "slider_posts": sliderPosts == null
            ? []
            : List<dynamic>.from(sliderPosts!.map((x) => x.toJson())),
        "total_alerts": totalAlerts,
        "share-url": shareUrl,
        "share_text": shareText,
        "text": text.toJson(),
        "total_watchlist": totalWatchList,
        "telegram-link": telegramLink,
        "whats-app-link": whatsappLink,
      };
}

class SliderPost {
  final String? title;
  final String? image;
  final String? publishedDate;
  final String? url;
  final String? slug;
  final List<DetailListType>? authors;

  SliderPost({
    this.title,
    this.image,
    this.publishedDate,
    this.url,
    this.slug,
    this.authors,
  });

  factory SliderPost.fromJson(Map<String, dynamic> json) => SliderPost(
        title: json["title"],
        image: json["image"],
        publishedDate: json["published_date"],
        url: json["url"],
        slug: json["slug"],
        authors: json["authors"] == null
            ? []
            : List<DetailListType>.from(
                json["authors"]!.map((x) => DetailListType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "image": image,
        "published_date": publishedDate,
        "url": url,
        "slug": slug,
        "authors": authors == null
            ? []
            : List<dynamic>.from(authors!.map((x) => x.toJson())),
      };
}

class TextSliderRes {
  final String drawerHeader;

  TextSliderRes({
    required this.drawerHeader,
  });

  factory TextSliderRes.fromJson(Map<String, dynamic> json) => TextSliderRes(
        drawerHeader: json["drawer_header"],
      );

  Map<String, dynamic> toJson() => {
        "drawer_header": drawerHeader,
      };
}

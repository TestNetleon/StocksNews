import 'dart:convert';

SdNewsRes sdNewsResFromJson(String str) => SdNewsRes.fromJson(json.decode(str));

String sdNewsResToJson(SdNewsRes data) => json.encode(data.toJson());

class SdNewsRes {
  final List<TopPost>? topPosts;
  final String? newsText;
  final num? sentimentsPer;

  SdNewsRes({
    this.topPosts,
    this.newsText,
    this.sentimentsPer,
  });

  factory SdNewsRes.fromJson(Map<String, dynamic> json) => SdNewsRes(
      topPosts: json["top_posts"] == null
          ? []
          : List<TopPost>.from(
              json["top_posts"]!.map((x) => TopPost.fromJson(x))),
      newsText: json["news_text"],
      sentimentsPer: json['sentiments_per']);

  Map<String, dynamic> toJson() => {
        "top_posts": topPosts == null
            ? []
            : List<dynamic>.from(topPosts!.map((x) => x.toJson())),
        "news_text": newsText,
        "sentiments_per": sentimentsPer,
      };
}

class TopPost {
  final String? title;
  final String? url;
  final String? image;
  final String? postDate;
  final String? publishedDateString;
  final String? site;
  final String? slug;

  TopPost({
    this.title,
    this.url,
    this.image,
    this.postDate,
    this.publishedDateString,
    this.site,
    this.slug,
  });

  factory TopPost.fromJson(Map<String, dynamic> json) => TopPost(
        title: json["title"],
        url: json["url"],
        image: json["image"],
        postDate: json["post_date"],
        publishedDateString: json["published_date_string"],
        site: json["site"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "url": url,
        "image": image,
        "post_date": postDate,
        "published_date_string": publishedDateString,
        "site": site,
        "slug": slug,
      };
}

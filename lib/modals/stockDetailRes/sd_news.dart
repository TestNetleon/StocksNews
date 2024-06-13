import 'dart:convert';

SdNewsRes sdNewsResFromJson(String str) => SdNewsRes.fromJson(json.decode(str));

String sdNewsResToJson(SdNewsRes data) => json.encode(data.toJson());

class SdNewsRes {
  final List<TopPost> topPosts;
  final String? newsText;

  SdNewsRes({
    required this.topPosts,
    this.newsText,
  });

  factory SdNewsRes.fromJson(Map<String, dynamic> json) => SdNewsRes(
        topPosts: List<TopPost>.from(
            json["top_posts"].map((x) => TopPost.fromJson(x))),
        newsText: json["news_text"],
      );

  Map<String, dynamic> toJson() => {
        "top_posts": List<dynamic>.from(topPosts.map((x) => x.toJson())),
        "news_text": newsText,
      };
}

class TopPost {
  final String? title;
  final String? url;
  final String? image;
  final String? postDate;
  final String? publishedDateString;
  final String? site;

  TopPost({
    this.title,
    this.url,
    this.image,
    this.postDate,
    this.publishedDateString,
    this.site,
  });

  factory TopPost.fromJson(Map<String, dynamic> json) => TopPost(
        title: json["title"],
        url: json["url"],
        image: json["image"],
        postDate: json["post_date"],
        publishedDateString: json["published_date_string"],
        site: json["site"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "url": url,
        "image": image,
        "post_date": postDate,
        "published_date_string": publishedDateString,
        "site": site,
      };
}

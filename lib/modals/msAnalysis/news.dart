import 'dart:convert';

List<MsNewsRes> msNewsResFromJson(String str) =>
    List<MsNewsRes>.from(json.decode(str).map((x) => MsNewsRes.fromJson(x)));

String msNewsResToJson(List<MsNewsRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MsNewsRes {
  final String? title;
  final String? slug;
  final dynamic url;
  final String? image;
  final String? postDate;
  final String? publishedDateString;
  final String? site;

  MsNewsRes({
    this.title,
    this.slug,
    this.url,
    this.image,
    this.postDate,
    this.publishedDateString,
    this.site,
  });

  factory MsNewsRes.fromJson(Map<String, dynamic> json) => MsNewsRes(
        title: json["title"],
        slug: json["slug"],
        url: json["url"],
        image: json["image"],
        postDate: json["post_date"],
        publishedDateString: json["published_date_string"],
        site: json["site"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "slug": slug,
        "url": url,
        "image": image,
        "post_date": postDate,
        "published_date_string": publishedDateString,
        "site": site,
      };
}

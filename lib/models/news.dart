import 'dart:convert';

List<BaseNewsRes> baseNewsResFromJson(String str) => List<BaseNewsRes>.from(
    json.decode(str).map((x) => BaseNewsRes.fromJson(x)));

String baseNewsResToJson(List<BaseNewsRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BaseNewsRes {
  final String? id;
  final String? title;
  final String? image;
  final String? slug;
  final List<NewsAuthorRes>? authors;
  final String? publishedDate;
  final String? site;

  BaseNewsRes({
    this.id,
    this.title,
    this.image,
    this.slug,
    this.authors,
    this.publishedDate,
    this.site,
  });

  factory BaseNewsRes.fromJson(Map<String, dynamic> json) => BaseNewsRes(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        slug: json["slug"],
        authors: json["authors"] == null
            ? []
            : List<NewsAuthorRes>.from(
                json["authors"]!.map((x) => NewsAuthorRes.fromJson(x))),
        publishedDate: json["date"],
        site: json["site"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "slug": slug,
        "authors": authors == null
            ? []
            : List<dynamic>.from(authors!.map((x) => x.toJson())),
        "date": publishedDate,
        "site": site,
      };
}

class NewsAuthorRes {
  final String? id;
  final String? name;

  NewsAuthorRes({
    this.id,
    this.name,
  });

  factory NewsAuthorRes.fromJson(Map<String, dynamic> json) => NewsAuthorRes(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

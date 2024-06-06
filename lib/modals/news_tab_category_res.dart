import 'dart:convert';

import 'package:stocks_news_new/modals/news_res.dart';

List<NewsTabsRes> nesCategoryTabResFromJson(String str) =>
    List<NewsTabsRes>.from(
        json.decode(str).map((x) => NewsTabsRes.fromJson(x)));

String nesCategoryTabResToJson(List<NewsTabsRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewsTabsRes {
  final String id;
  final String name;

  NewsTabsRes({
    required this.id,
    required this.name,
  });

  factory NewsTabsRes.fromJson(Map<String, dynamic> json) => NewsTabsRes(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class TabsNewsHolder {
  NewsRes? data;
  int currentPage;
  String? error;
  bool loading;

  TabsNewsHolder({
    this.data,
    this.currentPage = 1,
    this.loading = true,
    this.error,
  });
}

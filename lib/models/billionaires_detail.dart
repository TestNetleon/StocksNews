import 'dart:convert';

import 'package:stocks_news_new/models/billionaires_res.dart';

BillionairesDetailRes billionairesDetailResFromJson(String str) => BillionairesDetailRes.fromMap(json.decode(str));

String billionairesDetailResToMap(BillionairesDetailRes data) => json.encode(data.toMap());

class BillionairesDetailRes {
  final String? title;
  final BillionaireInfo? billionaireInfo;
  final RecentTweet? recentTweet;
  final SymbolMentionList? symbolMentionList;

  BillionairesDetailRes({
    this.title,
    this.billionaireInfo,
    this.recentTweet,
    this.symbolMentionList,
  });

  factory BillionairesDetailRes.fromMap(Map<String, dynamic> json) => BillionairesDetailRes(
    title: json["title"],
    billionaireInfo: json["billionaire_info"] == null ? null : BillionaireInfo.fromMap(json["billionaire_info"]),
    recentTweet: json["recent_tweet"] == null ? null : RecentTweet.fromMap(json["recent_tweet"]),
    symbolMentionList: json["symbol_Mention_list"] == null ? null : SymbolMentionList.fromMap(json["symbol_Mention_list"]),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "billionaire_info": billionaireInfo?.toMap(),
    "recent_tweet": recentTweet?.toMap(),
    "symbol_Mention_list": symbolMentionList?.toMap(),
  };
}

class BillionaireInfo {
  final String? name;
  final String? designation;
  final String? image;
  final String? description;

  BillionaireInfo({
    this.name,
    this.designation,
    this.image,
    this.description,
  });

  factory BillionaireInfo.fromMap(Map<String, dynamic> json) => BillionaireInfo(
    name: json["name"],
    designation: json["designation"],
    image: json["image"],
    description: json["description"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "designation": designation,
    "image": image,
    "description": description,
  };
}

class RecentTweet {
  final String? title;
  final String? subTitle;
  final List<CryptoTweetPost>? data;

  RecentTweet({
    this.title,
    this.subTitle,
    this.data,
  });

  factory RecentTweet.fromMap(Map<String, dynamic> json) => RecentTweet(
    title: json["title"],
    subTitle: json["sub_title"],
    data: json["data"] == null ? [] : List<CryptoTweetPost>.from(json["data"]!.map((x) => CryptoTweetPost.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "sub_title": subTitle,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

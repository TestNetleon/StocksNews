import 'dart:convert';

import 'package:stocks_news_new/models/crypto_models/billionaires_res.dart';


BillionairesDetailRes billionairesDetailResFromJson(String str) => BillionairesDetailRes.fromMap(json.decode(str));

String billionairesDetailResToMap(BillionairesDetailRes data) => json.encode(data.toMap());

class BillionairesDetailRes {
  final String? title;
  final CryptoTweetPost? billionaireInfo;
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
    billionaireInfo: json["billionaire_info"] == null ? null : CryptoTweetPost.fromMap(json["billionaire_info"]),
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

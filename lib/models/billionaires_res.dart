
import 'dart:convert';

import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/models/ticker.dart';

BillionairesRes billionairesResFromJson(String str) => BillionairesRes.fromMap(json.decode(str));

String billionairesResToJson(BillionairesRes data) => json.encode(data.toMap());

class BillionairesRes {
  final String? title;
  final List<CryptoTweetPost>? cryptoTweetPost;
  final TopTab? topTab;
  final RecentMentions? recentMentions;
  final SymbolMentionList? symbolMentionList;

  BillionairesRes({
    this.title,
    this.topTab,
    this.cryptoTweetPost,
    this.recentMentions,
    this.symbolMentionList,
  });

  factory BillionairesRes.fromMap(Map<String, dynamic> json) => BillionairesRes(
    title: json["title"],
    topTab: json["top_tab"] == null ? null : TopTab.fromMap(json["top_tab"]),
    cryptoTweetPost: json["crypto_tweet_post"] == null ? [] : List<CryptoTweetPost>.from(json["crypto_tweet_post"]!.map((x) => CryptoTweetPost.fromMap(x))),
    recentMentions: json["recent_mentions"] == null ? null : RecentMentions.fromMap(json["recent_mentions"]),
    symbolMentionList: json["symbol_Mention_list"] == null ? null : SymbolMentionList.fromMap(json["symbol_Mention_list"]),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "top_tab": topTab?.toMap(),
    "crypto_tweet_post": cryptoTweetPost == null ? [] : List<dynamic>.from(cryptoTweetPost!.map((x) => x.toMap())),
    "recent_mentions": recentMentions?.toMap(),
    "symbol_Mention_list": symbolMentionList?.toMap(),
  };
}

class CryptoTweetPost {
  final String? twitterName;
  final String? tweet;
  final String? name;
  final String? slug;
  final String? image;
  final String? twitterX;
  final String? qouteLeft;
  final String? deleteIcon;
  final String? designation;
  final int? totalMentions;
  final List<Symbols>? symbols;


  CryptoTweetPost({
    this.twitterName,
    this.tweet,
    this.slug,
    this.name,
    this.image,
    this.twitterX,
    this.qouteLeft,
    this.deleteIcon,
    this.designation,
    this.totalMentions,
    this.symbols,
  });

  factory CryptoTweetPost.fromMap(Map<String, dynamic> json) => CryptoTweetPost(
    twitterName: json["twitter_name"],
    tweet: json["tweet"],
    slug: json["slug"],
    name: json["name"],
    image: json["image"],
    twitterX: json["twitter_x"],
    qouteLeft: json["qoute_left"],
    deleteIcon: json["delete_icon"],
    designation: json["designation"],
    totalMentions: json["total_mentions"],
    symbols: json["symbols"] == null ? [] : List<Symbols>.from(json["symbols"]!.map((x) => Symbols.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "twitter_name": twitterName,
    "tweet": tweet,
    "slug": slug,
    "name": name,
    "image": image,
    "twitter_x": twitterX,
    "qoute_left": qouteLeft,
    "delete_icon": deleteIcon,
    "designation": designation,
    "total_mentions": totalMentions,
    "symbols": symbols == null ? [] : List<dynamic>.from(symbols!.map((x) => x.toMap())),
  };
}

class RecentMentions {
  final String? title;
  final String? subTitle;
  final List<CryptoTweetPost>? data;

  RecentMentions({
    this.title,
    this.subTitle,
    this.data,
  });

  factory RecentMentions.fromMap(Map<String, dynamic> json) => RecentMentions(
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


class Symbols {
  final String? symbol;
  final String? image;
  final int? count;

  Symbols({
    this.symbol,
    this.image,
    this.count,
  });

  factory Symbols.fromMap(Map<String, dynamic> json) => Symbols(
    symbol: json["symbol"],
    image: json["image"],
    count: json["count"],
  );

  Map<String, dynamic> toMap() => {
    "symbol":symbol,
    "image":image,
    "count": count,
  };
}


class SymbolMentionList {
  final String? title;
  final String? subTitle;
  final List<BaseTickerRes>? data;

  SymbolMentionList({
    this.title,
    this.subTitle,
    this.data,
  });

  factory SymbolMentionList.fromMap(Map<String, dynamic> json) => SymbolMentionList(
    title: json["title"],
    subTitle: json["sub_title"],
    data: json["data"] == null ? [] : List<BaseTickerRes>.from(json["data"]!.map((x) => BaseTickerRes.fromJson(x))),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "sub_title": subTitle,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class TopTab {
  final List<MarketResData>? data;
  final List<CryptoTweetPost>? topBillionaires;
  final List<CryptoTweetPost>? topCeoRes;

  TopTab({
    this.data,
    this.topBillionaires,
    this.topCeoRes,
  });

  factory TopTab.fromMap(Map<String, dynamic> json) => TopTab(
    data: json["data"] == null ? [] : List<MarketResData>.from(json["data"]!.map((x) => MarketResData.fromJson(x))),
    topBillionaires: json["top-billionaires"] == null ? [] : List<CryptoTweetPost>.from(json["top-billionaires"]!.map((x) => CryptoTweetPost.fromMap(x))),
    topCeoRes: json["top-ceo"] == null ? [] : List<CryptoTweetPost>.from(json["top-ceo"]!.map((x) => CryptoTweetPost.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "top-billionaires": topBillionaires == null ? [] : List<dynamic>.from(topBillionaires!.map((x) => x.toMap())),
    "top-ceo": topCeoRes == null ? [] : List<dynamic>.from(topCeoRes!.map((x) => x.toMap())),
  };
}



import 'dart:convert';

import 'package:stocks_news_new/models/market/market_res.dart';

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
  final String? slug;
  final String? image;
  final String? twitterX;
  final String? qouteLeft;

  CryptoTweetPost({
    this.twitterName,
    this.tweet,
    this.slug,
    this.image,
    this.twitterX,
    this.qouteLeft,
  });

  factory CryptoTweetPost.fromMap(Map<String, dynamic> json) => CryptoTweetPost(
    twitterName: json["twitter_name"],
    tweet: json["tweet"],
    slug: json["slug"],
    image: json["image"],
    twitterX: json["twitter_x"],
    qouteLeft: json["qoute_left"],
  );

  Map<String, dynamic> toMap() => {
    "twitter_name": twitterName,
    "tweet": tweet,
    "slug": slug,
    "image": image,
    "twitter_x": twitterX,
    "qoute_left": qouteLeft,
  };
}

class RecentMentions {
  final String? title;
  final String? subTitle;
  final List<RecentMentionsRes>? data;

  RecentMentions({
    this.title,
    this.subTitle,
    this.data,
  });

  factory RecentMentions.fromMap(Map<String, dynamic> json) => RecentMentions(
    title: json["title"],
    subTitle: json["sub_title"],
    data: json["data"] == null ? [] : List<RecentMentionsRes>.from(json["data"]!.map((x) => RecentMentionsRes.fromMap(x))),
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
  final List<SymbolMentionListRes>? data;

  SymbolMentionList({
    this.title,
    this.subTitle,
    this.data,
  });

  factory SymbolMentionList.fromMap(Map<String, dynamic> json) => SymbolMentionList(
    title: json["title"],
    subTitle: json["sub_title"],
    data: json["data"] == null ? [] : List<SymbolMentionListRes>.from(json["data"]!.map((x) => SymbolMentionListRes.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "sub_title": subTitle,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class SymbolMentionListRes {
  final String? symbol;
  final int? count;
  final String? name;
  final num? price;
  final String? displayPrice;
  final String? exchange;
  final String? change;
  final num? changesPercentage;
  final String? yearLow;
  final String? yearHigh;
  final String? open;
  final String? previousClose;
  final String? image;

  SymbolMentionListRes({
    this.symbol,
    this.count,
    this.name,
    this.price,
    this.displayPrice,
    this.exchange,
    this.change,
    this.changesPercentage,
    this.yearLow,
    this.yearHigh,
    this.open,
    this.previousClose,
    this.image,
  });

  factory SymbolMentionListRes.fromMap(Map<String, dynamic> json) => SymbolMentionListRes(
    symbol: json["symbol"],
    count: json["count"],
    name: json["name"],
    price: json["price"]?.toDouble(),
    displayPrice: json["display_price"],
    exchange: json["exchange"],
    change: json["change"],
    changesPercentage: json["changesPercentage"]?.toDouble(),
    yearLow: json["yearLow"],
    yearHigh: json["yearHigh"],
    open: json["open"],
    previousClose: json["previousClose"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "symbol": symbol,
    "count": count,
    "name": name,
    "price": price,
    "display_price": displayPrice,
    "exchange": exchange,
    "change": change,
    "changesPercentage": changesPercentage,
    "yearLow": yearLow,
    "yearHigh": yearHigh,
    "open": open,
    "previousClose": previousClose,
    "image": image,
  };
}
class TopTab {
  final List<MarketResData>? data;
  final List<RecentMentionsRes>? topBillionaires;
  final List<RecentMentionsRes>? topCeoRes;

  TopTab({
    this.data,
    this.topBillionaires,
    this.topCeoRes,
  });

  factory TopTab.fromMap(Map<String, dynamic> json) => TopTab(
    data: json["data"] == null ? [] : List<MarketResData>.from(json["data"]!.map((x) => MarketResData.fromJson(x))),
    topBillionaires: json["top-billionaires"] == null ? [] : List<RecentMentionsRes>.from(json["top-billionaires"]!.map((x) => RecentMentionsRes.fromMap(x))),
    topCeoRes: json["top-ceo"] == null ? [] : List<RecentMentionsRes>.from(json["top-ceo"]!.map((x) => RecentMentionsRes.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "top-billionaires": topBillionaires == null ? [] : List<dynamic>.from(topBillionaires!.map((x) => x.toMap())),
    "top-ceo": topCeoRes == null ? [] : List<dynamic>.from(topCeoRes!.map((x) => x.toMap())),
  };
}
class RecentMentionsRes {
  final String? name;
  final String? slug;
  final String? designation;
  final String? twitterName;
  final String? image;
  final String? deleteIcon;
  final int? totalMentions;
  final List<Symbols>? symbols;

  RecentMentionsRes({
    this.name,
    this.slug,
    this.designation,
    this.twitterName,
    this.image,
    this.totalMentions,
    this.deleteIcon,
    this.symbols,
  });

  factory RecentMentionsRes.fromMap(Map<String, dynamic> json) => RecentMentionsRes(
    name: json["name"],
    slug: json["slug"],
    designation: json["designation"],
    twitterName: json["twitter_name"],
    image: json["image"],
    totalMentions: json["total_mentions"],
    deleteIcon: json["delete_icon"],
    symbols: json["symbols"] == null ? [] : List<Symbols>.from(json["symbols"]!.map((x) => Symbols.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "slug": slug,
    "designation": designation,
    "twitter_name": twitterName,
    "image": image,
    "total_mentions": totalMentions,
    "delete_icon": deleteIcon,
    "symbols": symbols == null ? [] : List<dynamic>.from(symbols!.map((x) => x.toMap())),
  };
}


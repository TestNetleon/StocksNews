import 'dart:convert';

import 'package:stocks_news_new/models/billionaires_res.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/models/ticker.dart';

CryptoDetailRes cryptoWatchResFromJson(String str) => CryptoDetailRes.fromMap(json.decode(str));

String cryptoWatchResToJson(CryptoDetailRes data) => json.encode(data.toMap());

class CryptoDetailRes {
  final BaseTickerRes? cryptoInfo;
  final DataRes? pricePerformance;
  final DataRes? marketCap;
  final DataRes? tradingVolume;
  final DataRes? supply;
  final RecentTweetPost? recentTweetPost;
  final SymbolMentionList? symbolMentionList;

  CryptoDetailRes({
    this.cryptoInfo,
    this.pricePerformance,
    this.marketCap,
    this.tradingVolume,
    this.supply,
    this.recentTweetPost,
    this.symbolMentionList,
  });

  factory CryptoDetailRes.fromMap(Map<String, dynamic> json) => CryptoDetailRes(
    cryptoInfo: json["crypto_info"] == null ? null : BaseTickerRes.fromJson(json["crypto_info"]),
    pricePerformance: json["price_performance"] == null ? null : DataRes.fromMap(json["price_performance"]),
    marketCap: json["market_cap"] == null ? null : DataRes.fromMap(json["market_cap"]),
    tradingVolume: json["trading_volume"] == null ? null : DataRes.fromMap(json["trading_volume"]),
    supply: json["supply"] == null ? null : DataRes.fromMap(json["supply"]),
    recentTweetPost: json["recent_tweet_post"] == null ? null : RecentTweetPost.fromMap(json["recent_tweet_post"]),
    symbolMentionList: json["symbol_Mention_list"] == null ? null : SymbolMentionList.fromMap(json["symbol_Mention_list"]),
  );

  Map<String, dynamic> toMap() => {
    "crypto_info": cryptoInfo?.toJson(),
    "price_performance": pricePerformance?.toMap(),
    "market_cap": marketCap?.toMap(),
    "trading_volume": tradingVolume?.toMap(),
    "supply": supply?.toMap(),
    "recent_tweet_post": recentTweetPost?.toMap(),
    "symbol_Mention_list": symbolMentionList?.toMap(),
  };
}


class DataRes {
  final String? title;
  final List<BaseKeyValueRes>? data;

  DataRes({
    this.title,
    this.data,
  });

  factory DataRes.fromMap(Map<String, dynamic> json) => DataRes(
    title: json["title"],
    data: json["data"] == null ? [] : List<BaseKeyValueRes>.from(json["data"]!.map((x) => BaseKeyValueRes.fromJson(x))),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}



class RecentTweetPost {
  final String? title;
  final String? subTitle;
  final List<CryptoTweetPost>? data;

  RecentTweetPost({
    this.title,
    this.subTitle,
    this.data,
  });

  factory RecentTweetPost.fromMap(Map<String, dynamic> json) => RecentTweetPost(
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

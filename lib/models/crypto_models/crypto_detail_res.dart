import 'dart:convert';

import 'package:stocks_news_new/models/crypto_models/billionaires_res.dart';
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
  //final List<Rate>? rates;
  final CryptoData? cryptoData;
  CryptoDetailRes({
    this.cryptoInfo,
    this.pricePerformance,
    this.marketCap,
    this.tradingVolume,
    this.supply,
    this.recentTweetPost,
    this.symbolMentionList,
    this.cryptoData,
  });

  factory CryptoDetailRes.fromMap(Map<String, dynamic> json) => CryptoDetailRes(
    cryptoInfo: json["crypto_info"] == null ? null : BaseTickerRes.fromJson(json["crypto_info"]),
    pricePerformance: json["price_performance"] == null ? null : DataRes.fromMap(json["price_performance"]),
    marketCap: json["market_cap"] == null ? null : DataRes.fromMap(json["market_cap"]),
    tradingVolume: json["trading_volume"] == null ? null : DataRes.fromMap(json["trading_volume"]),
    supply: json["supply"] == null ? null : DataRes.fromMap(json["supply"]),
    recentTweetPost: json["recent_tweet_post"] == null ? null : RecentTweetPost.fromMap(json["recent_tweet_post"]),
    symbolMentionList: json["symbol_Mention_list"] == null ? null : SymbolMentionList.fromMap(json["symbol_Mention_list"]),
    cryptoData: json["crypto_data"] == null ? null : CryptoData.fromMap(json["crypto_data"]),
  );

  Map<String, dynamic> toMap() => {
    "crypto_info": cryptoInfo?.toJson(),
    "price_performance": pricePerformance?.toMap(),
    "market_cap": marketCap?.toMap(),
    "trading_volume": tradingVolume?.toMap(),
    "supply": supply?.toMap(),
    "recent_tweet_post": recentTweetPost?.toMap(),
    "symbol_Mention_list": symbolMentionList?.toMap(),
    "crypto_data": cryptoData?.toMap(),
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



class CryptoData {
  final String? title;
  List<Rate>? cryptoSymbol;
  final List<Rate>? rates;

  CryptoData({
    this.title,
    this.cryptoSymbol,
    this.rates,
  });

  factory CryptoData.fromMap(Map<String, dynamic> json) => CryptoData(
    title: json["title"],
    cryptoSymbol: json["crypto_symbol"] == null ? [] : List<Rate>.from(json["crypto_symbol"]!.map((x) => Rate.fromMap(x))),
    rates: json["rates"] == null ? [] : List<Rate>.from(json["rates"]!.map((x) => Rate.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "crypto_symbol": cryptoSymbol == null ? [] : List<dynamic>.from(cryptoSymbol!.map((x) => x.toMap())),
    "rates": rates == null ? [] : List<dynamic>.from(rates!.map((x) => x.toMap())),
  };
}

List<Rate> rateResFromMap(String str) => List<Rate>.from(json.decode(str).map((x) => Rate.fromMap(x)));

String ratResToMap(List<Rate> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Rate {
  final String? id;
  final String? currency;
  final double? price;
  final String? symbol;
  final String? imageUrl;

  Rate({
    this.id,
    this.currency,
    this.price,
    this.symbol,
    this.imageUrl,
  });

  factory Rate.fromMap(Map<String, dynamic> json) => Rate(
    id: json["_id"],
    currency: json["currency"],
    price: json["price"]?.toDouble(),
    symbol: json["symbol"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "currency": currency,
    "price": price,
    "symbol": symbol,
    "image_url": imageUrl,
  };
}

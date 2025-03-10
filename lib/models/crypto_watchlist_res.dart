
import 'dart:convert';

import 'package:stocks_news_new/models/billionaires_res.dart';

CryptoWatchRes cryptoWatchlistResFromJson(String str) => CryptoWatchRes.fromMap(json.decode(str));

String cryptoWatchlistResToJson(CryptoWatchRes data) => json.encode(data.toMap());

class CryptoWatchRes {
  final String? title;
  final RecentTweetPost? recentTweetPost;
  final FavoritePerson? favoritePerson;
  final SymbolMentionList? watchlistData;

  CryptoWatchRes({
    this.title,
    this.recentTweetPost,
    this.favoritePerson,
    this.watchlistData,
  });

  factory CryptoWatchRes.fromMap(Map<String, dynamic> json) => CryptoWatchRes(
    title: json["title"],
    recentTweetPost: json["recent_tweet_post"] == null ? null : RecentTweetPost.fromMap(json["recent_tweet_post"]),
    favoritePerson: json["favorite_person"] == null ? null : FavoritePerson.fromMap(json["favorite_person"]),
    watchlistData: json["watchlist_data"] == null ? null : SymbolMentionList.fromMap(json["watchlist_data"]),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "recent_tweet_post": recentTweetPost?.toMap(),
    "favorite_person": favoritePerson?.toMap(),
    "watchlist_data": watchlistData?.toMap(),
  };
}

class FavoritePerson {
  final String? title;
  final String? subTitle;
  final List<CryptoTweetPost>? data;

  FavoritePerson({
    this.title,
    this.subTitle,
    this.data,
  });

  factory FavoritePerson.fromMap(Map<String, dynamic> json) => FavoritePerson(
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
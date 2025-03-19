import 'dart:convert';

import 'package:stocks_news_new/models/crypto_models/billionaires_res.dart';


RecentTweetRes recentTweetResFromJson(String str) => RecentTweetRes.fromMap(json.decode(str));

String recentTweetResToJson(RecentTweetRes data) => json.encode(data.toMap());

class RecentTweetRes {
  final List<CryptoTweetPost>? tweets;

  RecentTweetRes({
    this.tweets,
  });

  factory RecentTweetRes.fromMap(Map<String, dynamic> json) => RecentTweetRes(
    tweets: json["tweets"] == null ? [] : List<CryptoTweetPost>.from(json["tweets"]!.map((x) => CryptoTweetPost.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "tweets": tweets == null ? [] : List<dynamic>.from(tweets!.map((x) => x.toMap())),
  };
}

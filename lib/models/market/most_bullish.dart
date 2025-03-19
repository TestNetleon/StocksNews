import 'dart:convert';

import 'package:stocks_news_new/models/lock.dart';
import 'package:stocks_news_new/models/ticker.dart';

MarketDataRes marketDataResFromJson(String str) =>
    MarketDataRes.fromJson(json.decode(str));

String marketDataResToJson(MarketDataRes data) => json.encode(data.toJson());

class MarketDataRes {
  final List<BaseTickerRes>? data;
  final int? totalPages;
  final BaseLockInfoRes? lockInfo;
  final String? title;
  final String? subtitle;

  MarketDataRes({
    required this.data,
    this.totalPages,
    this.lockInfo,
    this.title,
    this.subtitle,
  });

  factory MarketDataRes.fromJson(Map<String, dynamic> json) => MarketDataRes(
        data: json["data"] == null
            ? null
            : List<BaseTickerRes>.from(
                json["data"].map((x) => BaseTickerRes.fromJson(x)),
              ),
        totalPages: json["total_pages"],
        lockInfo: json["lock_info"] == null
            ? null
            : BaseLockInfoRes.fromJson(json["lock_info"]),
        title: json["title"],
        subtitle: json["subtitle"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total_pages": totalPages,
        "lock_info": lockInfo?.toJson(),
        "title": title,
        "subtitle": subtitle,
      };
}

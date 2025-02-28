import 'dart:convert';

import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/models/ticker.dart';

SDRes stocksDetailResFromJson(String str) => SDRes.fromJson(json.decode(str));

String stocksDetailResToJson(SDRes data) => json.encode(data.toJson());

class SDRes {
  final BaseTickerRes? tickerDetail;
  final List<MarketResData>? tabs;

  SDRes({
    this.tickerDetail,
    this.tabs,
  });

  factory SDRes.fromJson(Map<String, dynamic> json) => SDRes(
        tickerDetail: json["ticker_data"] == null
            ? null
            : BaseTickerRes.fromJson(json["ticker_data"]),
        tabs: json["tabs"] == null
            ? []
            : List<MarketResData>.from(
                json["tabs"]!.map((x) => MarketResData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ticker_data": tickerDetail?.toJson(),
        "tabs": tabs == null
            ? []
            : List<dynamic>.from(tabs!.map((x) => x.toJson())),
      };
}

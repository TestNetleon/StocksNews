import 'dart:convert';

import 'package:stocks_news_new/models/ticker.dart';

MarketDataRes marketDataResFromJson(String str) =>
    MarketDataRes.fromJson(json.decode(str));

String marketDataResToJson(MarketDataRes data) => json.encode(data.toJson());

class MarketDataRes {
  final List<BaseTickerRes>? mostBullish;

  MarketDataRes({required this.mostBullish});

  factory MarketDataRes.fromJson(Map<String, dynamic> json) => MarketDataRes(
        mostBullish: json["data"] == null
            ? null
            : List<BaseTickerRes>.from(
                json["data"].map((x) => BaseTickerRes.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "data": mostBullish == null
            ? null
            : List<dynamic>.from(mostBullish!.map((x) => x.toJson())),
      };
}

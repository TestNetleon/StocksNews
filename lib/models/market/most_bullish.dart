import 'dart:convert';

import 'package:stocks_news_new/models/ticker.dart';

MostBullishRes mostBullishResFromJson(String str) =>
    MostBullishRes.fromJson(json.decode(str));

String mostBullishResToJson(MostBullishRes data) => json.encode(data.toJson());

class MostBullishRes {
  final List<BaseTickerRes>? mostBullish;

  MostBullishRes({required this.mostBullish});

  factory MostBullishRes.fromJson(Map<String, dynamic> json) => MostBullishRes(
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

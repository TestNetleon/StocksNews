import 'dart:convert';

import 'package:stocks_news_new/models/ticker.dart';

import 'overview.dart';

SDStocksAnalysisRes sdStocksAnalysisResFromJson(String str) =>
    SDStocksAnalysisRes.fromJson(json.decode(str));

String sdStocksAnalysisResToJson(SDStocksAnalysisRes data) =>
    json.encode(data.toJson());

class SDStocksAnalysisRes {
  final StocksPeersRes? peersData;
  final List<BaseKeyValueRes>? basicData;

  SDStocksAnalysisRes({
    this.peersData,
    this.basicData,
  });

  factory SDStocksAnalysisRes.fromJson(Map<String, dynamic> json) =>
      SDStocksAnalysisRes(
        peersData: json["peers_data"] == null
            ? null
            : StocksPeersRes.fromJson(json["peers_data"]),
        basicData: json["basic_details"] == null
            ? []
            : List<BaseKeyValueRes>.from(
                json["basic_details"]!.map((x) => BaseKeyValueRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "peers_data": peersData?.toJson(),
        "basic_details": basicData == null
            ? []
            : List<dynamic>.from(basicData!.map((x) => x.toJson())),
      };
}

class StocksPeersRes {
  final String? title;
  final String? subTitle;
  final List<BaseTickerRes>? data;

  StocksPeersRes({
    this.title,
    this.subTitle,
    this.data,
  });

  factory StocksPeersRes.fromJson(Map<String, dynamic> json) => StocksPeersRes(
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<BaseTickerRes>.from(
                json["data"]!.map(
                  (x) => BaseTickerRes.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

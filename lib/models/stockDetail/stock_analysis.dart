import 'dart:convert';

import 'package:stocks_news_new/models/ticker.dart';

import 'overview.dart';

SDStocksAnalysisRes sdStocksAnalysisResFromJson(String str) =>
    SDStocksAnalysisRes.fromJson(json.decode(str));

String sdStocksAnalysisResToJson(SDStocksAnalysisRes data) =>
    json.encode(data.toJson());

class SDStocksAnalysisRes {
  final PeersData? peersData;
  final List<BaseKeyValueRes>? data;

  SDStocksAnalysisRes({
    this.peersData,
    this.data,
  });

  factory SDStocksAnalysisRes.fromJson(Map<String, dynamic> json) =>
      SDStocksAnalysisRes(
        peersData: json["peers_data"] == null
            ? null
            : PeersData.fromJson(json["peers_data"]),
        data: json["data"] == null
            ? []
            : List<BaseKeyValueRes>.from(
                json["data"]!.map((x) => BaseKeyValueRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "peers_data": peersData?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class PeersData {
  final String? title;
  final String? subTitle;
  final List<BaseTickerRes>? data;

  PeersData({
    this.title,
    this.subTitle,
    this.data,
  });

  factory PeersData.fromJson(Map<String, dynamic> json) => PeersData(
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

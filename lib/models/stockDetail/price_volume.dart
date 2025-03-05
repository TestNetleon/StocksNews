import 'dart:convert';

import 'package:stocks_news_new/models/stockDetail/overview.dart';

AIPriceVolumeRes AIPriceVolumeResFromJson(String str) =>
    AIPriceVolumeRes.fromJson(json.decode(str));

String AIPriceVolumeResToJson(AIPriceVolumeRes data) =>
    json.encode(data.toJson());

class AIPriceVolumeRes {
  final List<BaseKeyValueRes>? data;

  AIPriceVolumeRes({
    this.data,
  });

  factory AIPriceVolumeRes.fromJson(Map<String, dynamic> json) =>
      AIPriceVolumeRes(
        data: json["data"] == null
            ? []
            : List<BaseKeyValueRes>.from(
                json["data"]!.map((x) => BaseKeyValueRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

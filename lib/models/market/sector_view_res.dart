
import 'dart:convert';

import 'package:stocks_news_new/models/ticker.dart';

SectorViewRes sectorViewResFromJson(String str) => SectorViewRes.fromMap(json.decode(str));

String sectorViewResToJson(SectorViewRes data) => json.encode(data.toMap());

class SectorViewRes {
  final String? title;
  final String? subTitle;
  final Chart? chart;
  final List<BaseTickerRes>? data;
  final int? totalPages;

  SectorViewRes({
    this.title,
    this.subTitle,
    this.chart,
    this.data,
    this.totalPages,
  });

  factory SectorViewRes.fromMap(Map<String, dynamic> json) => SectorViewRes(
    title: json["title"],
    subTitle: json["sub_title"],
    chart: json["chart"] == null ? null : Chart.fromMap(json["chart"]),
    data: json["data"] == null ? [] : List<BaseTickerRes>.from(json["data"]!.map((x) => BaseTickerRes.fromJson(x))),
    totalPages: json["total_pages"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "sub_title": subTitle,
    "chart": chart?.toMap(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total_pages": totalPages,
  };
}

class Chart {
  final List<String>? dates;
  final List<double>? values;

  Chart({
    this.dates,
    this.values,
  });

  factory Chart.fromMap(Map<String, dynamic> json) => Chart(
    dates: json["dates"] == null ? [] : List<String>.from(json["dates"]!.map((x) => x)),
    values: json["values"] == null ? [] : List<double>.from(json["values"]!.map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toMap() => {
    "dates": dates == null ? [] : List<dynamic>.from(dates!.map((x) => x)),
    "values": values == null ? [] : List<dynamic>.from(values!.map((x) => x)),
  };
}

import 'dart:convert';

import 'package:stocks_news_new/models/faq.dart';
import 'package:stocks_news_new/models/my_home.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';

import '../my_home_premium.dart';

SDInsiderTradesRes SDInsiderTradesResFromJson(String str) =>
    SDInsiderTradesRes.fromJson(json.decode(str));

String SDInsiderTradesResToJson(SDInsiderTradesRes data) =>
    json.encode(data.toJson());

class SDInsiderTradesRes {
  final InsiderTradeListRes? insiderData;
  final PoliticianTradeListRes? congressionalData;
  final List<BaseKeyValueRes>? top;
  final BaseFaqRes? faq;

  SDInsiderTradesRes({
    this.insiderData,
    this.congressionalData,
    this.top,
    this.faq,
  });

  factory SDInsiderTradesRes.fromJson(Map<String, dynamic> json) =>
      SDInsiderTradesRes(
        insiderData: json["insider_data"] == null
            ? null
            : InsiderTradeListRes.fromJson(json["insider_data"]),
        congressionalData: json["congressional_data"] == null
            ? null
            : PoliticianTradeListRes.fromJson(json["congressional_data"]),
        top: json["top"] == null
            ? []
            : List<BaseKeyValueRes>.from(
                json["top"]!.map((x) => BaseKeyValueRes.fromJson(x))),
        faq: json["faq"] == null ? null : BaseFaqRes.fromJson(json["faq"]),
      );

  Map<String, dynamic> toJson() => {
        "insider_data": insiderData?.toJson(),
        "congressional_data": congressionalData?.toJson(),
        "top":
            top == null ? [] : List<dynamic>.from(top!.map((x) => x.toJson())),
        "faq": faq?.toJson(),
      };
}

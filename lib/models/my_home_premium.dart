import 'dart:convert';

import 'my_home.dart';

MyHomePremiumRes myHomePremiumResFromJson(String str) =>
    MyHomePremiumRes.fromJson(json.decode(str));

String myHomePremiumResToJson(MyHomePremiumRes data) =>
    json.encode(data.toJson());

class MyHomePremiumRes {
  final InsiderTradeListRes? insiderTrading;
  final PoliticianTradeListRes? congressionalStocks;
  final HomeNewsRes? featuredNews;
  final HomeNewsRes? financialNews;

  MyHomePremiumRes({
    this.insiderTrading,
    this.congressionalStocks,
    this.featuredNews,
    this.financialNews,
  });

  factory MyHomePremiumRes.fromJson(Map<String, dynamic> json) =>
      MyHomePremiumRes(
        featuredNews: json["featured_news"] == null
            ? null
            : HomeNewsRes.fromJson(json["featured_news"]),
        financialNews: json["financial_news"] == null
            ? null
            : HomeNewsRes.fromJson(json["financial_news"]),
        insiderTrading: json["insider_trading"] == null
            ? null
            : InsiderTradeListRes.fromJson(json["insider_trading"]),
        congressionalStocks: json["congressional_stocks"] == null
            ? null
            : PoliticianTradeListRes.fromJson(json["congressional_stocks"]),
      );

  Map<String, dynamic> toJson() => {
        "featured_news": featuredNews?.toJson(),
        "financial_news": financialNews?.toJson(),
        "insider_trading": insiderTrading?.toJson(),
        "congressional_stocks": congressionalStocks?.toJson(),
      };
}

class PoliticianTradeListRes {
  final String? title;
  final String? subTitle;
  final List<PoliticianTradeRes>? data;

  PoliticianTradeListRes({
    this.title,
    this.subTitle,
    this.data,
  });

  factory PoliticianTradeListRes.fromJson(Map<String, dynamic> json) =>
      PoliticianTradeListRes(
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<PoliticianTradeRes>.from(
                json["data"]!.map((x) => PoliticianTradeRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class PoliticianTradeRes {
  final String? id;
  final String? image;
  final String? name;
  final String? slug;
  final String? symbol;
  final String? company;
  final String? type;
  final String? userImage;
  final String? memberType;
  final String? office;

  PoliticianTradeRes({
    this.id,
    this.image,
    this.name,
    this.slug,
    this.symbol,
    this.company,
    this.type,
    this.userImage,
    this.memberType,
    this.office,
  });

  factory PoliticianTradeRes.fromJson(Map<String, dynamic> json) =>
      PoliticianTradeRes(
        id: json["_id"],
        image: json["image"],
        name: json["name"],
        slug: json["slug"],
        symbol: json["symbol"],
        company: json["company"],
        type: json["type"],
        userImage: json["user_image"],
        memberType: json["member_type"],
        office: json["office"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "image": image,
        "name": name,
        "slug": slug,
        "symbol": symbol,
        "company": company,
        "type": type,
        "user_image": userImage,
        "member_type": memberType,
        "office": office,
      };
}

class InsiderTradeListRes {
  final String? title;
  final String? subTitle;
  final List<InsiderTradeRes>? data;

  InsiderTradeListRes({
    this.title,
    this.subTitle,
    this.data,
  });

  factory InsiderTradeListRes.fromJson(Map<String, dynamic> json) =>
      InsiderTradeListRes(
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<InsiderTradeRes>.from(
                json["data"]!.map((x) => InsiderTradeRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class InsiderTradeRes {
  final String? id;
  final String? reportingName;
  final String? reportingSlug;
  final String? typeOfOwner;
  final String? symbol;
  final String? exchangeShortName;
  final String? companyName;
  final String? companySlug;
  final String? image;
  final String? transactionType;

  InsiderTradeRes({
    this.id,
    this.reportingName,
    this.reportingSlug,
    this.typeOfOwner,
    this.symbol,
    this.exchangeShortName,
    this.companyName,
    this.companySlug,
    this.image,
    this.transactionType,
  });

  factory InsiderTradeRes.fromJson(Map<String, dynamic> json) =>
      InsiderTradeRes(
        id: json["_id"],
        reportingName: json["reportingName"],
        reportingSlug: json["reportingSlug"],
        typeOfOwner: json["typeOfOwner"],
        symbol: json["symbol"],
        exchangeShortName: json["exchange_short_name"],
        companyName: json["companyName"],
        companySlug: json["companySlug"],
        image: json["image"],
        transactionType: json["transactionType"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "reportingName": reportingName,
        "reportingSlug": reportingSlug,
        "typeOfOwner": typeOfOwner,
        "symbol": symbol,
        "exchange_short_name": exchangeShortName,
        "companyName": companyName,
        "companySlug": companySlug,
        "image": image,
        "transactionType": transactionType,
      };
}

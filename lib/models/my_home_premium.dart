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
  // final String? reportingSlug;
  final String? typeOfOwner;
  final String? symbol;
  final String? price;
  final String? exchangeShortName;
  final String? companyName;
  final String? companyCik;
  final String? image;
  final String? transactionType;
  final String? totalTransaction;
  final String? securityTransacted;
  final String? securitiesOwned;
  final String? transactionDate;
  final String? link;
  final String? reportingCik;

  InsiderTradeRes({
    this.id,
    this.reportingName,
    this.reportingCik,
    // this.reportingSlug,
    this.typeOfOwner,
    this.symbol,
    this.price,
    this.exchangeShortName,
    this.companyName,
    this.companyCik,
    this.image,
    this.totalTransaction,
    this.transactionType,
    this.securityTransacted,
    this.securitiesOwned,
    this.transactionDate,
    this.link,
  });

  factory InsiderTradeRes.fromJson(Map<String, dynamic> json) =>
      InsiderTradeRes(
        id: json["_id"],
        price: json['price'],
        link: json['link'],
        reportingCik: json['reportingCik'],
        totalTransaction: json['totalTransaction'],
        reportingName: json["reportingName"],
        securityTransacted: json['securitiesTransacted'],
        // reportingSlug: json["reportingSlug"],
        typeOfOwner: json["typeOfOwner"],
        symbol: json["symbol"],
        exchangeShortName: json["exchange_short_name"],
        companyName: json["name"],
        companyCik: json["companyCik"],
        image: json["image"],
        transactionDate: json['transactionDate'],
        transactionType: json["transactionType"],
        securitiesOwned: json['securitiesOwned'],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        'price': price,
        'link': link,
        'reportingCik': reportingCik,
        "reportingName": reportingName,
        'totalTransaction': totalTransaction,
        // "reportingSlug": reportingSlug,
        'securitiesTransacted': securityTransacted,
        "typeOfOwner": typeOfOwner,
        "symbol": symbol,
        "exchange_short_name": exchangeShortName,
        "name": companyName,
        "companyCik": companyCik,
        "image": image,
        "transactionType": transactionType,
        'securitiesOwned': securitiesOwned,
        'transactionDate': transactionDate,
      };
}

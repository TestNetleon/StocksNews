import 'dart:convert';
import 'lock.dart';
import 'my_home.dart';

MyHomePremiumRes myHomePremiumResFromJson(String str) =>
    MyHomePremiumRes.fromJson(json.decode(str));

String myHomePremiumResToJson(MyHomePremiumRes data) =>
    json.encode(data.toJson());

class MyHomePremiumRes {
  // final InsiderTradeListRes? insiderTrading;
  final PoliticianTradeListRes? congressionalStocks;
  final HomeNewsRes? featuredNews;
  final HomeNewsRes? financialNews;
  final HomeNewsRes? recentNews;

  MyHomePremiumRes({
    this.recentNews,
    this.congressionalStocks,
    this.featuredNews,
    this.financialNews,
  });

  factory MyHomePremiumRes.fromJson(Map<String, dynamic> json) =>
      MyHomePremiumRes(
        recentNews: json["recent_news"] == null
            ? null
            : HomeNewsRes.fromJson(json["recent_news"]),
        featuredNews: json["featured_news"] == null
            ? null
            : HomeNewsRes.fromJson(json["featured_news"]),
        financialNews: json["financial_news"] == null
            ? null
            : HomeNewsRes.fromJson(json["financial_news"]),
        // insiderTrading: json["insider_trading"] == null
        //     ? null
        //     : InsiderTradeListRes.fromJson(json["insider_trading"]),
        congressionalStocks: json["congressional_stocks"] == null
            ? null
            : PoliticianTradeListRes.fromJson(json["congressional_stocks"]),
      );

  Map<String, dynamic> toJson() => {
        "featured_news": featuredNews?.toJson(),
        "financial_news": financialNews?.toJson(),
        // "insider_trading": insiderTrading?.toJson(),
        "recent_news": recentNews?.toJson(),

        "congressional_stocks": congressionalStocks?.toJson(),
      };
}

class PoliticianTradeListRes {
  final String? title;
  final String? subTitle;
  final List<PoliticianTradeRes>? data;
  final BaseLockInfoRes? lockInfo;

  PoliticianTradeListRes({
    this.title,
    this.subTitle,
    this.data,
    this.lockInfo,
  });

  factory PoliticianTradeListRes.fromJson(Map<String, dynamic> json) =>
      PoliticianTradeListRes(
        lockInfo: json["lock_info"] == null
            ? null
            : BaseLockInfoRes.fromJson(json["lock_info"]),
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<PoliticianTradeRes>.from(
                json["data"]!.map((x) => PoliticianTradeRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lock_info": lockInfo?.toJson(),
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class PoliticianTradeRes {
  final String? image;
  final String? userName;
  final String? userSlug;
  final String? symbol;
  final String? name;
  final String? type;
  final String? userImage;
  final String? office;
  final String? exchangeShortName;
  final String? amount;
  final String? transactionDate;
  final String? receivedDate;

  PoliticianTradeRes({
    this.image,
    this.userName,
    this.userSlug,
    this.symbol,
    this.name,
    this.type,
    this.userImage,
    this.office,
    this.amount,
    this.exchangeShortName,
    this.transactionDate,
    this.receivedDate,
  });

  factory PoliticianTradeRes.fromJson(Map<String, dynamic> json) =>
      PoliticianTradeRes(
        image: json["image"],
        userName: json["user_name"],
        userSlug: json["user_slug"],
        symbol: json["symbol"],
        name: json["name"],
        type: json["type"],
        userImage: json["user_image"],
        office: json["office"],
        amount: json['amount'],
        transactionDate: json['transactionDate'],
        exchangeShortName: json['exchange_short_name'],
        receivedDate: json['receivedDate'],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "user_name": userName,
        "user_slug": userSlug,
        "symbol": symbol,
        "name": name,
        "type": type,
        "user_image": userImage,
        "office": office,
        'exchange_short_name': exchangeShortName,
        'transactionDate': transactionDate,
        'receivedDate': receivedDate,
      };
}

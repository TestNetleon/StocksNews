import 'dart:convert';

import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/models/lock.dart';

import 'news.dart';
import 'ticker.dart';

MyHomeRes myHomeResFromJson(String str) => MyHomeRes.fromJson(json.decode(str));

String myHomeResToJson(MyHomeRes data) => json.encode(data.toJson());

class MyHomeRes {
  final HomeNewsRes? recentNews;
  final List<BaseTickerRes>? tickers;
  final HomeLoginBoxRes? loginBox;
  final UserRes? user;
  final BaseNewsRes? bannerBlog;
  final InsiderTradeListRes? insiderTrading;

  MyHomeRes({
    this.recentNews,
    this.tickers,
    this.loginBox,
    this.user,
    this.bannerBlog,
    this.insiderTrading,
  });

  factory MyHomeRes.fromJson(Map<String, dynamic> json) => MyHomeRes(
        user: json["user"] == null ? null : UserRes.fromJson(json["user"]),
        loginBox: json["login_box"] == null
            ? null
            : HomeLoginBoxRes.fromJson(json["login_box"]),
        recentNews: json["recent_news"] == null
            ? null
            : HomeNewsRes.fromJson(json["recent_news"]),
        tickers: json["trending"] == null
            ? null
            : List<BaseTickerRes>.from(
                json["trending"].map((x) => BaseTickerRes.fromJson(x))),
        bannerBlog: json["banner_blog"] == null
            ? null
            : BaseNewsRes.fromJson(json["banner_blog"]),
        insiderTrading: json["insider_trading"] == null
            ? null
            : InsiderTradeListRes.fromJson(json["insider_trading"]),
      );

  Map<String, dynamic> toJson() => {
        "login_box": loginBox?.toJson(),
        "banner_blog": bannerBlog?.toJson(),
        "user": user?.toJson(),
        "recent_news": recentNews?.toJson(),
        "trending": tickers == null
            ? null
            : List<dynamic>.from(tickers!.map((x) => x.toJson())),
        "insider_trading": insiderTrading?.toJson(),
      };
}

class HomeLoginBoxRes {
  final String? id;
  final String? agreeUrl;
  final String? buttonText;
  final String? verifyButtonText;

  HomeLoginBoxRes({
    this.id,
    this.agreeUrl,
    this.buttonText,
    this.verifyButtonText,
  });

  factory HomeLoginBoxRes.fromJson(Map<String, dynamic> json) =>
      HomeLoginBoxRes(
        id: json["id"],
        agreeUrl: json["agree_url"],
        buttonText: json['btn_text'],
        verifyButtonText: json['verify_btn_text'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "agree_url": agreeUrl,
        "btn_text": buttonText,
        'verify_btn_text': verifyButtonText,
      };
}

class HomeNewsRes {
  final String? title;
  final String? subTitle;
  final List<BaseNewsRes>? data;

  HomeNewsRes({
    this.title,
    this.subTitle,
    this.data,
  });

  factory HomeNewsRes.fromJson(Map<String, dynamic> json) => HomeNewsRes(
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<BaseNewsRes>.from(
                json["data"]!.map((x) => BaseNewsRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class InsiderTradeListRes {
  final String? title;
  final String? subTitle;
  final List<InsiderTradeRes>? data;
  final BaseLockInfoRes? lockInfo;

  InsiderTradeListRes({
    this.title,
    this.subTitle,
    this.data,
    this.lockInfo,
  });

  factory InsiderTradeListRes.fromJson(Map<String, dynamic> json) =>
      InsiderTradeListRes(
        lockInfo: json["lock_info"] == null
            ? null
            : BaseLockInfoRes.fromJson(json["lock_info"]),
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<InsiderTradeRes>.from(
                json["data"]!.map((x) => InsiderTradeRes.fromJson(x))),
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

class InsiderTradeRes {
  final String? id;
  final String? reportingName;
  // final String? reportingSlug;
  final String? typeOfOwner;
  final String? symbol;
  final String? price;
  final String? exchangeShortName;
  final String? name;
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
    this.name,
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
        name: json["name"],
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
        "name": name,
        "companyCik": companyCik,
        "image": image,
        "transactionType": transactionType,
        'securitiesOwned': securitiesOwned,
        'transactionDate': transactionDate,
      };
}

import 'dart:convert';

import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/models/lock.dart';

import '../ui/tabs/tools/scanner/models/scanner_port.dart';
import 'news.dart';
import 'ticker.dart';

MyHomeRes myHomeResFromJson(String str) => MyHomeRes.fromJson(json.decode(str));

String myHomeResToJson(MyHomeRes data) => json.encode(data.toJson());

class MyHomeRes {
  final List<BaseTickerRes>? tickers;
  final HomeLoginBoxRes? loginBox;
  final HomeLoginBoxRes? loginBoxDrawer;
  final UserRes? user;
  final BaseNewsRes? bannerBlog;
  final bool? showCrypto;
  // final InsiderTradeListRes? insiderTrading;
  final ScannerPortRes? scannerPort;
  final List<BaseNewsRes>? recentNews;
  final HomePopularRes? popular;
  final AdManagersRes? adManagers;

  MyHomeRes({
    this.tickers,
    this.loginBox,
    this.loginBoxDrawer,
    this.user,
    this.adManagers,
    this.popular,
    this.recentNews,
    this.bannerBlog,
    this.showCrypto,
    // this.insiderTrading,
    this.scannerPort,
  });

  factory MyHomeRes.fromJson(Map<String, dynamic> json) => MyHomeRes(
        adManagers: json["ad_managers"] == null
            ? null
            : AdManagersRes.fromJson(json["ad_managers"]),
        popular: json["popular"] == null
            ? null
            : HomePopularRes.fromJson(json["popular"]),
        recentNews: json["recent_news"] == null
            ? []
            : List<BaseNewsRes>.from(
                json["recent_news"]!.map((x) => BaseNewsRes.fromJson(x))),
        user: json["user"] == null ? null : UserRes.fromJson(json["user"]),
        loginBox: json["login_box"] == null
            ? null
            : HomeLoginBoxRes.fromJson(json["login_box"]),

        loginBoxDrawer: json["login_box_drawer"] == null
            ? null
            : HomeLoginBoxRes.fromJson(json["login_box_drawer"]),

        tickers: json["trending"] == null
            ? null
            : List<BaseTickerRes>.from(
                json["trending"].map((x) => BaseTickerRes.fromJson(x))),
        bannerBlog: json["banner_blog"] == null
            ? null
            : BaseNewsRes.fromJson(json["banner_blog"]),
        showCrypto: json['show_crypto'],
        // insiderTrading: json["insider_trading"] == null
        //     ? null
        //     : InsiderTradeListRes.fromJson(json["insider_trading"]),
        scannerPort: json["home_scanner"] == null
            ? null
            : ScannerPortRes.fromJson(json["home_scanner"]),
      );

  Map<String, dynamic> toJson() => {
        "ad_managers": adManagers?.toJson(),

        "popular": popular?.toJson(),
        "recent_news": recentNews == null
            ? []
            : List<dynamic>.from(recentNews!.map((x) => x.toJson())),
        "login_box": loginBox?.toJson(),

        "login_box_drawer": loginBoxDrawer?.toJson(),

        "banner_blog": bannerBlog?.toJson(),
        "user": user?.toJson(),
        "trending": tickers == null
            ? null
            : List<dynamic>.from(tickers!.map((x) => x.toJson())),
        "show_crypto": showCrypto,
        // "insider_trading": insiderTrading?.toJson(),
        "home_scanner": scannerPort?.toJson(),
      };
}

class HomeLoginBoxRes {
  final String? id;
  final String? title;
  final String? subtitle;
  final String? agreeUrl;
  final String? buttonText;
  final String? verifyButtonText;
  final num? androidBuildCode;
  final num? iosBuildCode;

  HomeLoginBoxRes({
    this.id,
    this.androidBuildCode,
    this.iosBuildCode,
    this.agreeUrl,
    this.title,
    this.subtitle,
    this.buttonText,
    this.verifyButtonText,
  });

  factory HomeLoginBoxRes.fromJson(Map<String, dynamic> json) =>
      HomeLoginBoxRes(
        id: json["id"],
        title: json['title'],
        subtitle: json['subtitle'],
        agreeUrl: json["agree_url"],
        buttonText: json['btn_text'],
        androidBuildCode: json["android_build_code"],
        iosBuildCode: json["ios_build_code"],
        verifyButtonText: json['verify_btn_text'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        'title': title,
        'subtitle': subtitle,
        "android_build_code": androidBuildCode,
        "ios_build_code": iosBuildCode,
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
  final String? reportingImage;
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
    this.reportingImage,
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
        reportingImage: json['reportingImage'],
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
        'reportingImage': reportingImage,
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

class HomePopularRes {
  final String? title;
  final List<BaseTickerRes>? data;

  HomePopularRes({
    this.title,
    this.data,
  });

  factory HomePopularRes.fromJson(Map<String, dynamic> json) => HomePopularRes(
        title: json["title"],
        data: json["data"] == null
            ? []
            : List<BaseTickerRes>.from(
                json["data"]!.map((x) => BaseTickerRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

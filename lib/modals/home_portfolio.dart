// To parse this JSON data, do
//
//     final homePortfolioRes = homePortfolioResFromJson(jsonString);

import 'dart:convert';

HomePortfolioRes homePortfolioResFromJson(String str) =>
    HomePortfolioRes.fromJson(json.decode(str));

String homePortfolioResToJson(HomePortfolioRes data) =>
    json.encode(data.toJson());

class HomePortfolioRes {
  final PortfolioTop? top;
  final PortfolioKeys? keys;
  final PortfolioBottom? bottom;

  HomePortfolioRes({
    this.top,
    this.keys,
    this.bottom,
  });

  factory HomePortfolioRes.fromJson(Map<String, dynamic> json) =>
      HomePortfolioRes(
        top: json["top"] == null ? null : PortfolioTop.fromJson(json["top"]),
        keys:
            json["keys"] == null ? null : PortfolioKeys.fromJson(json["keys"]),
        bottom: json["bottom"] == null
            ? null
            : PortfolioBottom.fromJson(json["bottom"]),
      );

  Map<String, dynamic> toJson() => {
        "top": top?.toJson(),
        "keys": keys?.toJson(),
        "bottom": bottom?.toJson(),
      };
}

class PortfolioBottom {
  final String? title;
  final String? subTitle;
  final String? currentBalance;
  final String? closePrice;

  PortfolioBottom({
    this.currentBalance,
    this.closePrice,
    this.title,
    this.subTitle,
  });

  factory PortfolioBottom.fromJson(Map<String, dynamic> json) =>
      PortfolioBottom(
        currentBalance: json["current_balance"],
        closePrice: json["close_price"],
        title: json["title"],
        subTitle: json["sub_title"],
      );

  Map<String, dynamic> toJson() => {
        "current_balance": currentBalance,
        "close_price": closePrice,
        "title": title,
        "sub_title": subTitle,
      };
}

class PortfolioKeys {
  final String? plaidClient;
  final String? plaidSecret;
  final String? plaidEnv;

  PortfolioKeys({
    this.plaidClient,
    this.plaidSecret,
    this.plaidEnv,
  });

  factory PortfolioKeys.fromJson(Map<String, dynamic> json) => PortfolioKeys(
        plaidClient: json["plaid_client"],
        plaidSecret: json["plaid_secret"],
        plaidEnv: json["plaid_env"],
      );

  Map<String, dynamic> toJson() => {
        "plaid_client": plaidClient,
        "plaid_secret": plaidSecret,
        "plaid_env": plaidEnv,
      };
}

class PortfolioTop {
  final String? title;
  final String? subTitle;
  final String? p1;
  final String? p2;
  final String? p3;

  PortfolioTop({
    this.title,
    this.subTitle,
    this.p1,
    this.p2,
    this.p3,
  });

  factory PortfolioTop.fromJson(Map<String, dynamic> json) => PortfolioTop(
        title: json["title"],
        subTitle: json["sub_title"],
        p1: json['p1'],
        p2: json['p2'],
        p3: json['p3'],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        'p1': p1,
        'p2': p2,
        'p3': p3,
      };
}

List<String> homePortfolioTabResFromJson(String str) =>
    List<String>.from(json.decode(str).map((x) => x));

String homePortfolioTabResToJson(List<String> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x)));

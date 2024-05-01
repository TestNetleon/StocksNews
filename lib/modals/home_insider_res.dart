import 'dart:convert';

import 'package:stocks_news_new/modals/news_datail_res.dart';

HomeInsiderRes homeInsiderResFromJson(String str) =>
    HomeInsiderRes.fromJson(json.decode(str));

String homeInsiderResToJson(HomeInsiderRes data) => json.encode(data.toJson());

//
class HomeInsiderRes {
  final List<InsiderTrading> insiderTrading;
  final List<RecentMention>? recentMentions;
  final List<News> news;

  HomeInsiderRes({
    this.recentMentions,
    required this.insiderTrading,
    required this.news,
  });

  factory HomeInsiderRes.fromJson(Map<String, dynamic> json) => HomeInsiderRes(
        insiderTrading: List<InsiderTrading>.from(
            json["insider_trading"].map((x) => InsiderTrading.fromJson(x))),
        news: List<News>.from(json["news"].map((x) => News.fromJson(x))),
        recentMentions: json["recent_mentions"] == null
            ? []
            : List<RecentMention>.from(
                json["recent_mentions"]!.map((x) => RecentMention.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "insider_trading":
            List<dynamic>.from(insiderTrading.map((x) => x.toJson())),
        "news": List<dynamic>.from(news.map((x) => x.toJson())),
        "recent_mentions": recentMentions == null
            ? []
            : List<dynamic>.from(recentMentions!.map((x) => x.toJson())),
      };
}

class RecentMention {
  final String? id;
  final String symbol;
  final num? mentionCount;
  final DateTime? publishedDate;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final String? price;
  final num? change;
  final num? changesPercentage;
  final String? name;
  final String? image;

  RecentMention({
    this.id,
    required this.symbol,
    this.mentionCount,
    this.publishedDate,
    this.updatedAt,
    this.createdAt,
    this.price,
    this.change,
    this.changesPercentage,
    this.name,
    this.image,
  });

  factory RecentMention.fromJson(Map<String, dynamic> json) => RecentMention(
        id: json["_id"],
        symbol: json["symbol"],
        mentionCount: json["mention_count"],
        publishedDate: json["published_date"] == null
            ? null
            : DateTime.parse(json["published_date"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        price: json["price"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "symbol": symbol,
        "mention_count": mentionCount,
        "published_date":
            "${publishedDate!.year.toString().padLeft(4, '0')}-${publishedDate!.month.toString().padLeft(2, '0')}-${publishedDate!.day.toString().padLeft(2, '0')}",
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "price": price,
        "change": change,
        "changesPercentage": changesPercentage,
        "name": name,
        "image": image,
      };
}

class InsiderTrading {
  // final String id;
  final String symbol;
  // final DateTime transactionDate;
  // final String reportingCik;
  final num securitiesTransacted;
  // final DateTime filingDate;
  final String transactionType;
  final String securitiesOwned;
  // final String companyCik;
  final String reportingName;
  final String reportingSlug;
  final String typeOfOwner;
  // final String acquistionOrDisposition;
  // final String formType;
  // final num price;
  // final String securityName;
  final String link;
  // final num insiderTradingTotalTransaction;
  // final num change;
  // final String image;
  final String exchangeShortName;
  final String companyName;
  final String companySlug;
  final String exchange;
  // final String cap;
  // final String sector;
  // final DateTime updatedAt;
  // final DateTime createdAt;
  final String totalTransaction;
  final String transactionDateNew;

  InsiderTrading({
    // required this.id,
    required this.symbol,
    // required this.transactionDate,
    // required this.reportingCik,
    required this.securitiesTransacted,
    // required this.filingDate,
    required this.transactionType,
    required this.securitiesOwned,
    // required this.companyCik,
    required this.reportingName,
    required this.reportingSlug,
    required this.typeOfOwner,
    // required this.acquistionOrDisposition,
    // required this.formType,
    // required this.price,
    // required this.securityName,
    required this.link,
    // required this.insiderTradingTotalTransaction,
    // required this.change,
    // required this.image,
    required this.exchangeShortName,
    required this.companyName,
    required this.companySlug,
    required this.exchange,
    // required this.cap,
    // required this.sector,
    // required this.updatedAt,
    // required this.createdAt,
    required this.totalTransaction,
    required this.transactionDateNew,
  });

  factory InsiderTrading.fromJson(Map<String, dynamic> json) => InsiderTrading(
        // id: json["_id"],
        symbol: json["symbol"],
        // transactionDate: DateTime.parse(json["transactionDate"]),
        // reportingCik: json["reportingCik"],
        securitiesTransacted: json["securitiesTransacted"]?.toDouble(),
        // filingDate: DateTime.parse(json["filingDate"]),
        transactionType: json["transactionType"],
        securitiesOwned: json["securitiesOwned"],
        // companyCik: json["companyCik"],
        reportingName: json["reportingName"],
        reportingSlug: json["reportingSlug"],
        typeOfOwner: json["typeOfOwner"],
        // acquistionOrDisposition: json["acquistionOrDisposition"],
        // formType: json["formType"],
        // price: json["price"]?.toDouble(),
        // securityName: json["securityName"],
        link: json["link"],
        // insiderTradingTotalTransaction: json["total_transaction"],
        // change: json["change"]?.toDouble(),
        // image: json["image"],
        exchangeShortName: json["exchange_short_name"],
        companyName: json["companyName"],
        companySlug: json["companySlug"],
        exchange: json["exchange"],
        // cap: json["cap"],
        // sector: json["sector"],
        // updatedAt: DateTime.parse(json["updated_at"]),
        // createdAt: DateTime.parse(json["created_at"]),
        totalTransaction: json["total_transaction"],
        transactionDateNew: json["transactionDateNew"],
      );

  Map<String, dynamic> toJson() => {
        // "_id": id,
        "symbol": symbol,
        // "transactionDate": transactionDate.toIso8601String(),
        // "reportingCik": reportingCik,
        "securitiesTransacted": securitiesTransacted,
        // "filingDate": filingDate.toIso8601String(),
        "transactionType": transactionType,
        "securitiesOwned": securitiesOwned,
        // "companyCik": companyCik,
        "reportingName": reportingName,
        "reportingSlug": reportingSlug,
        "typeOfOwner": typeOfOwner,
        // "acquistionOrDisposition": acquistionOrDisposition,
        // "formType": formType,
        // "price": price,
        // "securityName": securityName,
        "link": link,
        // "total_transaction": insiderTradingTotalTransaction,
        // "change": change,
        // "image": image,
        "exchange_short_name": exchangeShortName,
        "companyName": companyName,
        "companySlug": companySlug,
        "exchange": exchange,
        // "cap": cap,
        // "sector": sector,
        // "updated_at": updatedAt.toIso8601String(),
        // "created_at": createdAt.toIso8601String(),
        "total_transaction": totalTransaction,
        "transactionDateNew": transactionDateNew,
      };
}

class News {
  // final String id;
  // final DateTime publishedDate;
  final String title;
  final String image;
  final String site;
  final String? url;
  final String postDate;
  final String? slug;
  final List<DetailListType>? authors;

  News({
    // required this.id,
    // required this.publishedDate,
    required this.title,
    required this.image,
    required this.site,
    this.url,
    this.slug,
    required this.postDate,
    this.authors,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
        // id: json["_id"],
        // publishedDate: DateTime.parse(json["published_date"]),
        title: json["title"],
        image: json["image"],
        site: json["site"],
        url: json["url"],
        postDate: json["post_date"],
        slug: json["slug"],
        authors: json["authors"] == null
            ? []
            : List<DetailListType>.from(
                json["authors"]!.map((x) => DetailListType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        // "_id": id,
        // "published_date": publishedDate.toIso8601String(),
        "title": title,
        "image": image,
        "site": site,
        "url": url,
        "post_date": postDate,
        "slug": slug,
        "authors": authors == null
            ? []
            : List<dynamic>.from(authors!.map((x) => x.toJson())),
      };
}

// // To parse this JSON data, do
// //
// //     final homeRes = homeResFromJson(jsonString);

// import 'dart:convert';

// HomeRes homeResFromJson(String str) => HomeRes.fromJson(json.decode(str));

// String homeResToJson(HomeRes data) => json.encode(data.toJson());

// class HomeRes {
//   // final List<HomeTrendingData> trending;
//   // final List<Top> gainers;
//   // final List<Top> losers;
//   final List<InsiderTrading> insiderTrading;
//   final List<RecentMention>? recentMentions;
//   final List<SliderPost>? sliderPosts;

//   final List<News> news;
//   final num? avgSentiment;
//   final num? commentVolume;
//   final num? sentimentTrending;

//   HomeRes({
//     // required this.trending,
//     this.recentMentions,
//     this.sliderPosts,
//     // required this.gainers,
//     // required this.losers,
//     required this.insiderTrading,
//     required this.news,
//     required this.avgSentiment,
//     required this.commentVolume,
//     required this.sentimentTrending,
//   });

//   factory HomeRes.fromJson(Map<String, dynamic> json) => HomeRes(
//         // trending: List<HomeTrendingData>.from(
//         //     json["trending"].map((x) => HomeTrendingData.fromJson(x))),
//         // gainers: List<Top>.from(json["gainers"].map((x) => Top.fromJson(x))),
//         // losers: List<Top>.from(json["losers"].map((x) => Top.fromJson(x))),
//         sliderPosts: json["slider_posts"] == null
//             ? []
//             : List<SliderPost>.from(
//                 json["slider_posts"]!.map((x) => SliderPost.fromJson(x))),
//         insiderTrading: List<InsiderTrading>.from(
//             json["insider_trading"].map((x) => InsiderTrading.fromJson(x))),
//         news: List<News>.from(json["news"].map((x) => News.fromJson(x))),
//         recentMentions: json["recent_mentions"] == null
//             ? []
//             : List<RecentMention>.from(
//                 json["recent_mentions"]!.map((x) => RecentMention.fromJson(x))),
//         avgSentiment: json["avg_sentiment"],
//         commentVolume: json["comment_volume_per"],
//         sentimentTrending: json["sentiment_trending"],
//       );

//   Map<String, dynamic> toJson() => {
//         // "trending": List<dynamic>.from(trending.map((x) => x.toJson())),
//         // "gainers": List<dynamic>.from(gainers.map((x) => x.toJson())),
//         // "losers": List<dynamic>.from(losers.map((x) => x.toJson())),
//         "insider_trading":
//             List<dynamic>.from(insiderTrading.map((x) => x.toJson())),
//         "slider_posts": sliderPosts == null
//             ? []
//             : List<dynamic>.from(sliderPosts!.map((x) => x.toJson())),
//         "news": List<dynamic>.from(news.map((x) => x.toJson())),
//         "recent_mentions": recentMentions == null
//             ? []
//             : List<dynamic>.from(recentMentions!.map((x) => x.toJson())),
//         "avg_sentiment": avgSentiment,
//         "comment_volume_per": commentVolume,
//         "sentiment_trending": sentimentTrending,
//       };
// }

// class SliderPost {
//   final String? title;
//   final String? image;
//   final String? publishedDate;
//   final String? url;

//   SliderPost({
//     this.title,
//     this.image,
//     this.publishedDate,
//     this.url,
//   });

//   factory SliderPost.fromJson(Map<String, dynamic> json) => SliderPost(
//         title: json["title"],
//         image: json["image"],
//         publishedDate: json["published_date"],
//         url: json["url"],
//       );

//   Map<String, dynamic> toJson() => {
//         "title": title,
//         "image": image,
//         "published_date": publishedDate,
//         "url": url,
//       };
// }

// // class Trending {
// //   final String? symbol;
// //   final String? name;
// //   final int? rank;
// //   final int? sentiment;
// //   final int? lastSentiment;
// //   final String? price;
// //   final double? change;
// //   final String? image;

// //   Trending({
// //     this.symbol,
// //     this.name,
// //     this.rank,
// //     this.sentiment,
// //     this.lastSentiment,
// //     this.price,
// //     this.change,
// //     this.image,
// //   });

// //   factory Trending.fromJson(Map<String, dynamic> json) => Trending(
// //         symbol: json["symbol"],
// //         name: json["name"],
// //         rank: json["rank"],
// //         sentiment: json["sentiment"],
// //         lastSentiment: json["last_sentiment"],
// //         price: json["price"],
// //         change: json["change"]?.toDouble(),
// //         image: json["image"],
// //       );

// //   Map<String, dynamic> toJson() => {
// //         "symbol": symbol,
// //         "name": name,
// //         "rank": rank,
// //         "sentiment": sentiment,
// //         "last_sentiment": lastSentiment,
// //         "price": price,
// //         "change": change,
// //         "image": image,
// //       };
// // }

// class RecentMention {
//   final String? id;
//   final String symbol;
//   final num? mentionCount;
//   final DateTime? publishedDate;
//   final DateTime? updatedAt;
//   final DateTime? createdAt;
//   final String? price;
//   final num? change;
//   final num? changesPercentage;
//   final String? name;
//   final String? image;

//   RecentMention({
//     this.id,
//     required this.symbol,
//     this.mentionCount,
//     this.publishedDate,
//     this.updatedAt,
//     this.createdAt,
//     this.price,
//     this.change,
//     this.changesPercentage,
//     this.name,
//     this.image,
//   });

//   factory RecentMention.fromJson(Map<String, dynamic> json) => RecentMention(
//         id: json["_id"],
//         symbol: json["symbol"],
//         mentionCount: json["mention_count"],
//         publishedDate: json["published_date"] == null
//             ? null
//             : DateTime.parse(json["published_date"]),
//         updatedAt: json["updated_at"] == null
//             ? null
//             : DateTime.parse(json["updated_at"]),
//         createdAt: json["created_at"] == null
//             ? null
//             : DateTime.parse(json["created_at"]),
//         price: json["price"],
//         change: json["change"],
//         changesPercentage: json["changesPercentage"],
//         name: json["name"],
//         image: json["image"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "symbol": symbol,
//         "mention_count": mentionCount,
//         "published_date":
//             "${publishedDate!.year.toString().padLeft(4, '0')}-${publishedDate!.month.toString().padLeft(2, '0')}-${publishedDate!.day.toString().padLeft(2, '0')}",
//         "updated_at": updatedAt?.toIso8601String(),
//         "created_at": createdAt?.toIso8601String(),
//         "price": price,
//         "change": change,
//         "changesPercentage": changesPercentage,
//         "name": name,
//         "image": image,
//       };
// }

// // class Top {
// //   final String name;
// //   final String symbol;
// //   final String price;
// //   final num changesPercentage;
// //   final String image;
// //   final bool gained;

// //   Top({
// //     required this.name,
// //     required this.symbol,
// //     required this.price,
// //     required this.changesPercentage,
// //     required this.image,
// //     this.gained = false,
// //   });

// //   factory Top.fromJson(Map<String, dynamic> json) => Top(
// //         name: json["name"],
// //         symbol: json["symbol"],
// //         price: json["price"],
// //         changesPercentage: json["changesPercentage"]?.toDouble(),
// //         image: json["image"],
// //       );

// //   Map<String, dynamic> toJson() => {
// //         "name": name,
// //         "symbol": symbol,
// //         "price": price,
// //         "changesPercentage": changesPercentage,
// //         "image": image,
// //       };
// // }

// class InsiderTrading {
//   // final String id;
//   final String symbol;
//   // final DateTime transactionDate;
//   // final String reportingCik;
//   final num securitiesTransacted;
//   // final DateTime filingDate;
//   final String transactionType;
//   final String securitiesOwned;
//   // final String companyCik;
//   final String reportingName;
//   final String reportingSlug;
//   final String typeOfOwner;
//   // final String acquistionOrDisposition;
//   // final String formType;
//   // final num price;
//   // final String securityName;
//   final String link;
//   // final num insiderTradingTotalTransaction;
//   // final num change;
//   // final String image;
//   final String exchangeShortName;
//   final String companyName;
//   // final String companySlug;
//   final String exchange;
//   // final String cap;
//   // final String sector;
//   // final DateTime updatedAt;
//   // final DateTime createdAt;
//   final String totalTransaction;
//   final String transactionDateNew;

//   InsiderTrading({
//     // required this.id,
//     required this.symbol,
//     // required this.transactionDate,
//     // required this.reportingCik,
//     required this.securitiesTransacted,
//     // required this.filingDate,
//     required this.transactionType,
//     required this.securitiesOwned,
//     // required this.companyCik,
//     required this.reportingName,
//     required this.reportingSlug,
//     required this.typeOfOwner,
//     // required this.acquistionOrDisposition,
//     // required this.formType,
//     // required this.price,
//     // required this.securityName,
//     required this.link,
//     // required this.insiderTradingTotalTransaction,
//     // required this.change,
//     // required this.image,
//     required this.exchangeShortName,
//     required this.companyName,
//     // required this.companySlug,
//     required this.exchange,
//     // required this.cap,
//     // required this.sector,
//     // required this.updatedAt,
//     // required this.createdAt,
//     required this.totalTransaction,
//     required this.transactionDateNew,
//   });

//   factory InsiderTrading.fromJson(Map<String, dynamic> json) => InsiderTrading(
//         // id: json["_id"],
//         symbol: json["symbol"],
//         // transactionDate: DateTime.parse(json["transactionDate"]),
//         // reportingCik: json["reportingCik"],
//         securitiesTransacted: json["securitiesTransacted"]?.toDouble(),
//         // filingDate: DateTime.parse(json["filingDate"]),
//         transactionType: json["transactionType"],
//         securitiesOwned: json["securitiesOwned"],
//         // companyCik: json["companyCik"],
//         reportingName: json["reportingName"],
//         reportingSlug: json["reportingSlug"],
//         typeOfOwner: json["typeOfOwner"],
//         // acquistionOrDisposition: json["acquistionOrDisposition"],
//         // formType: json["formType"],
//         // price: json["price"]?.toDouble(),
//         // securityName: json["securityName"],
//         link: json["link"],
//         // insiderTradingTotalTransaction: json["total_transaction"],
//         // change: json["change"]?.toDouble(),
//         // image: json["image"],
//         exchangeShortName: json["exchange_short_name"],
//         companyName: json["companyName"],
//         // companySlug: json["companySlug"],
//         exchange: json["exchange"],
//         // cap: json["cap"],
//         // sector: json["sector"],
//         // updatedAt: DateTime.parse(json["updated_at"]),
//         // createdAt: DateTime.parse(json["created_at"]),
//         totalTransaction: json["totalTransaction"],
//         transactionDateNew: json["transactionDateNew"],
//       );

//   Map<String, dynamic> toJson() => {
//         // "_id": id,
//         "symbol": symbol,
//         // "transactionDate": transactionDate.toIso8601String(),
//         // "reportingCik": reportingCik,
//         "securitiesTransacted": securitiesTransacted,
//         // "filingDate": filingDate.toIso8601String(),
//         "transactionType": transactionType,
//         "securitiesOwned": securitiesOwned,
//         // "companyCik": companyCik,
//         "reportingName": reportingName,
//         "reportingSlug": reportingSlug,
//         "typeOfOwner": typeOfOwner,
//         // "acquistionOrDisposition": acquistionOrDisposition,
//         // "formType": formType,
//         // "price": price,
//         // "securityName": securityName,
//         "link": link,
//         // "total_transaction": insiderTradingTotalTransaction,
//         // "change": change,
//         // "image": image,
//         "exchange_short_name": exchangeShortName,
//         "companyName": companyName,
//         // "companySlug": companySlug,
//         "exchange": exchange,
//         // "cap": cap,
//         // "sector": sector,
//         // "updated_at": updatedAt.toIso8601String(),
//         // "created_at": createdAt.toIso8601String(),
//         "totalTransaction": totalTransaction,
//         "transactionDateNew": transactionDateNew,
//       };
// }

// class News {
//   // final String id;
//   // final DateTime publishedDate;
//   final String title;
//   final String image;
//   final String site;
//   final String url;
//   final String postDate;

//   News({
//     // required this.id,
//     // required this.publishedDate,
//     required this.title,
//     required this.image,
//     required this.site,
//     required this.url,
//     required this.postDate,
//   });

//   factory News.fromJson(Map<String, dynamic> json) => News(
//         // id: json["_id"],
//         // publishedDate: DateTime.parse(json["published_date"]),
//         title: json["title"],
//         image: json["image"],
//         site: json["site"],
//         url: json["url"],
//         postDate: json["post_date"],
//       );

//   Map<String, dynamic> toJson() => {
//         // "_id": id,
//         // "published_date": publishedDate.toIso8601String(),
//         "title": title,
//         "image": image,
//         "site": site,
//         "url": url,
//         "post_date": postDate,
//       };
// }

class HomeTrendingData {
  final String symbol;
  final String name;
  // final num rank;
  final num sentiment;
  // final num lastSentiment;
  final String price;
  // final num change;
  final String image;
  final String displayChange;
  final num displayPercentage;

  HomeTrendingData({
    required this.symbol,
    required this.name,
    // required this.rank,
    required this.sentiment,
    // required this.lastSentiment,
    required this.price,
    // required this.change,
    required this.image,
    required this.displayChange,
    required this.displayPercentage,
  });

  factory HomeTrendingData.fromJson(Map<String, dynamic> json) =>
      HomeTrendingData(
        symbol: json["symbol"],
        name: json["name"],
        // rank: json["rank"],
        sentiment: json["sentiment"],
        // lastSentiment: json["last_sentiment"],
        price: json["price"],
        displayChange: json["display_change"],
        displayPercentage: json["changesPercentage"],
        // change: json["change"]?.toDouble(),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        // "rank": rank,
        "sentiment": sentiment,
        "changesPercentage": displayPercentage,
        "display_change": displayChange,
        // "last_sentiment": lastSentiment,
        "price": price,
        // "change": change,
        "image": image,
      };
}
//
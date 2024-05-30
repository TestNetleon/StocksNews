// To parse this JSON data, do
//
//     final alertRes = alertResFromJson(jsonString);

import 'dart:convert';

AlertRes alertResFromJson(String str) => AlertRes.fromJson(json.decode(str));

String alertResToJson(AlertRes data) => json.encode(data.toJson());

class AlertRes {
  final num currentPage;
  final List<AlertData>? data;
  final num lastPage;

  AlertRes({
    required this.currentPage,
    required this.data,
    required this.lastPage,
  });

  factory AlertRes.fromJson(Map<String, dynamic> json) => AlertRes(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<AlertData>.from(
                json["data"]!.map((x) => AlertData.fromJson(x))),
        lastPage: json["last_page"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "last_page": lastPage,
      };
}

class AlertData {
  final String id;
  // final String userId;
  final String symbol;
  final String name;
  final String image;
  // final String sentiment;
  final String price;
  final num changes;
  final String displayChange;
  final num changesPercentage;
  // final num mentions;
  // final num rank;
  // final String alertName;
  // final bool sentimentSpike;
  // final bool mentionSpike;
  // final DateTime updatedAt;
  // final DateTime createdAt;

  AlertData({
    required this.id,
    // required this.userId,
    required this.symbol,
    required this.displayChange,
    required this.changesPercentage,
    required this.name,
    required this.image,
    // required this.sentiment,
    required this.price,
    required this.changes,
    // required this.mentions,
    // required this.rank,
    // required this.alertName,
    // required this.sentimentSpike,
    // required this.mentionSpike,
    // required this.updatedAt,
    // required this.createdAt,
  });

  factory AlertData.fromJson(Map<String, dynamic> json) => AlertData(
        id: json["_id"],
        // userId: json["user_id"]!,
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],

        displayChange: json["display_change"],
        changesPercentage: json["changesPercentage"],
        // sentiment: json["sentiment"]!,
        price: json["price"],
        changes: json["changes"]?.toDouble(),
        // mentions: json["mentions"],
        // rank: json["rank"],
        // alertName: json["alert_name"],
        // sentimentSpike: json["sentiment_spike"]!,
        // mentionSpike: json["mention_spike"]!,
        // updatedAt: DateTime.parse(json["updated_at"]),
        // createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        // "user_id": userId,
        "symbol": symbol,
        "name": name,
        "image": image,
        "display_change": displayChange,
        "changesPercentage": changesPercentage,
        // "sentiment": sentiment,
        "price": price,
        "changes": changes,
        // "mentions": mentions,
        // "rank": rank,
        // "alert_name": alertName,
        // "sentiment_spike": sentimentSpike,
        // "mention_spike": mentionSpike,
        // "updated_at": updatedAt.toIso8601String(),
        // "created_at": createdAt.toIso8601String(),
        //
      };
}

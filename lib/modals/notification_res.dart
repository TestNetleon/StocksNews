// To parse this JSON data, do
//
//     final notificationsRes = notificationsResFromJson(jsonString);

import 'dart:convert';

NotificationsRes notificationsResFromJson(String str) =>
    NotificationsRes.fromJson(json.decode(str));

String notificationsResToJson(NotificationsRes data) =>
    json.encode(data.toJson());

class NotificationsRes {
  final List<NotificationData>? data;
  final int lastPage;

  NotificationsRes({
    this.data,
    required this.lastPage,
  });

  factory NotificationsRes.fromJson(Map<String, dynamic> json) =>
      NotificationsRes(
        data: json["data"] == null
            ? []
            : List<NotificationData>.from(
                json["data"]!.map((x) => NotificationData.fromJson(x))),
        lastPage: json["last_page"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "last_page": lastPage,
      };
}

class NotificationData {
  final String title;
  final String type;
  final String message;
  final String? image;
  final String? slug;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  NotificationData({
    required this.title,
    required this.type,
    required this.message,
    this.updatedAt,
    this.image,
    this.slug,
    this.createdAt,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        title: json["title"],
        type: json["type"],
        slug: json['slug'],
        message: json["message"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "type": type,
        "message": message,
        "image": image,
        'slug': slug,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
      };
}

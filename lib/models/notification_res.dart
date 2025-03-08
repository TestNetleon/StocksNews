import 'dart:convert';

NotificationRes notificationResFromJson(String str) => NotificationRes.fromMap(json.decode(str));

String notificationResToJson(NotificationRes data) => json.encode(data.toMap());

class NotificationRes {
  final String? title;
  final List<Notifications>? notifications;
  final int? totalPages;

  NotificationRes({
    this.title,
    this.notifications,
    this.totalPages,
  });

  factory NotificationRes.fromMap(Map<String, dynamic> json) => NotificationRes(
    notifications: json["data"] == null ? [] : List<Notifications>.from(json["data"]!.map((x) => Notifications.fromMap(x))),
    title: json["title"],
    totalPages: json["total_pages"],
  );

  Map<String, dynamic> toMap() => {
    "data": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x.toMap())),
    "title": title,
    "total_pages": totalPages,
  };
}

class Notifications {
  final String? id;
  final String? title;
  final String? message;
  final String? image;
  final String? type;
  final String? slug;
  final DateTime? createdAt;
  final String? date;

  Notifications({
    this.id,
    this.title,
    this.message,
    this.image,
    this.type,
    this.slug,
    this.createdAt,
    this.date,
  });

  factory Notifications.fromMap(Map<String, dynamic> json) => Notifications(
    id: json["_id"],
    title: json["title"],
    message: json["message"],
    image: json["image"],
    type: json["type"],
    slug: json["slug"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    date: json["date"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "title": title,
    "message": message,
    "image": image,
    "type": type,
    "slug": slug,
    "created_at": createdAt?.toIso8601String(),
    "date": date,
  };
}

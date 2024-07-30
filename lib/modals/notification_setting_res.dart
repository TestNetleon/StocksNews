import 'dart:convert';

List<NotificationSettingRes> notificationSettingResFromJson(String str) =>
    List<NotificationSettingRes>.from(
        json.decode(str).map((x) => NotificationSettingRes.fromJson(x)));

String notificationSettingResToJson(List<NotificationSettingRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationSettingRes {
  final String title;
  final String slug;
  int selected;

  NotificationSettingRes({
    required this.title,
    required this.slug,
    required this.selected,
  });

  factory NotificationSettingRes.fromJson(Map<String, dynamic> json) =>
      NotificationSettingRes(
        title: json["title"],
        slug: json["slug"],
        selected: json["selected"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "slug": slug,
        "selected": selected,
      };
}

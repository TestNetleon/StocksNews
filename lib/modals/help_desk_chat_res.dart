// To parse this JSON data, do
//
//     final helpDeskChatRes = helpDeskChatResFromJson(jsonString);

import 'dart:convert';

HelpDeskChatRes helpDeskChatResFromJson(String str) =>
    HelpDeskChatRes.fromJson(json.decode(str));

String helpDeskChatResToJson(HelpDeskChatRes data) =>
    json.encode(data.toJson());

class HelpDeskChatRes {
  final String? subject;
  List<Log>? logs;

  HelpDeskChatRes({
    this.subject,
    this.logs,
  });

  factory HelpDeskChatRes.fromJson(Map<String, dynamic> json) =>
      HelpDeskChatRes(
        subject: json["subject"],
        logs: json["logs"] == null || json["logs"].isEmpty
            ? null
            : List<Log>.from(json["logs"].map((x) => Log.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subject": subject,
        "logs": logs == null || logs?.isEmpty == true
            ? null
            : List<dynamic>.from(logs!.map((x) => x.toJson())),
      };
}

class Log {
  final String? id;
  final String? reply;
  final int? replyFrom;
  final String? replyTime;

  Log({
    this.id,
    this.reply,
    this.replyFrom,
    this.replyTime,
  });

  factory Log.fromJson(Map<String, dynamic> json) => Log(
        id: json["_id"],
        reply: json["reply"],
        replyFrom: json["reply_from"],
        replyTime: json["reply_date"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "reply": reply,
        "reply_from": replyFrom,
        "reply_date": replyTime,
      };
}

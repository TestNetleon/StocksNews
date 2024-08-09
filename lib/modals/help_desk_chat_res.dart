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
  final String? closeMsg;
  final num? status;
  List<Log>? logs;
  final num? ticketNo;

  HelpDeskChatRes({
    this.subject,
    this.ticketNo,
    this.logs,
    this.closeMsg,
    this.status,
  });

  factory HelpDeskChatRes.fromJson(Map<String, dynamic> json) =>
      HelpDeskChatRes(
        subject: json["subject"],
        closeMsg: json["close_msg"],
        status: json['status'],
        ticketNo: json['ticket_no'],
        logs: json["logs"] == null || json["logs"].isEmpty
            ? null
            : List<Log>.from(json["logs"].map((x) => Log.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subject": subject,
        "ticket_no": ticketNo,
        "status": status,
        "close_msg": closeMsg,
        "logs": logs == null || logs?.isEmpty == true
            ? null
            : List<dynamic>.from(logs!.map((x) => x.toJson())),
      };
}

class Log {
  // final String? id;
  // final String? reply;
  final String? replyHTML;

  final int? replyFrom;
  final String? replyTime;

  Log({
    // this.id,
    // this.reply,
    this.replyHTML,
    this.replyFrom,
    this.replyTime,
  });

  factory Log.fromJson(Map<String, dynamic> json) => Log(
        // id: json["_id"],
        // reply: json["reply"],
        replyHTML: json["reply_html"],
        replyFrom: json["reply_from"],
        replyTime: json["reply_date"],
      );

  Map<String, dynamic> toJson() => {
        // "_id": id,
        // "reply": reply,
        "reply_html": replyHTML,
        "reply_from": replyFrom,
        "reply_date": replyTime,
      };
}

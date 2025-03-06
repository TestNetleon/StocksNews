
import 'dart:convert';

HelpDeskChatRes helpDeskChatResFromMap(String str) => HelpDeskChatRes.fromMap(json.decode(str));

String helpDeskChatResToMap(HelpDeskChatRes data) => json.encode(data.toMap());

class HelpDeskChatRes {
  final String? title;
  final String? subTitle;
  final ChatRes? chatRes;

  HelpDeskChatRes({
    this.title,
    this.subTitle,
    this.chatRes,
  });

  factory HelpDeskChatRes.fromMap(Map<String, dynamic> json) => HelpDeskChatRes(
    title: json["title"],
    subTitle: json["sub_title"],
    chatRes: json["data"] == null ? null : ChatRes.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "sub_title": subTitle,
    "data": chatRes?.toMap(),
  };
}

class ChatRes {
  final int? ticketNo;
  final String? subject;
  final int? status;
  final List<Log>? logs;
  final String? closeMsg;
  ChatRes({
    this.ticketNo,
    this.subject,
    this.status,
    this.logs,
    this.closeMsg,
  });

  factory ChatRes.fromMap(Map<String, dynamic> json) => ChatRes(
    ticketNo: json["ticket_no"],
    subject: json["subject"],
    status: json["status"],
    closeMsg: json["close_msg"],
    logs: json["logs"] == null ? [] : List<Log>.from(json["logs"]!.map((x) => Log.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "ticket_no": ticketNo,
    "subject": subject,
    "status": status,
    "closeMsg": closeMsg,
    "logs": logs == null ? [] : List<dynamic>.from(logs!.map((x) => x.toMap())),
  };
}

class Log {
  final String? reply;
  final String? replyHtml;
  final int? replyFrom;
  final String? replyDate;

  Log({
    this.reply,
    this.replyHtml,
    this.replyFrom,
    this.replyDate,
  });

  factory Log.fromMap(Map<String, dynamic> json) => Log(
    reply: json["reply"],
    replyHtml: json["reply_html"],
    replyFrom: json["reply_from"],
    replyDate: json["reply_date"],
  );

  Map<String, dynamic> toMap() => {
    "reply": reply,
    "reply_html": replyHtml,
    "reply_from": replyFrom,
    "reply_date": replyDate,
  };
}

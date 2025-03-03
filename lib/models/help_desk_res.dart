// To parse this JSON data, do
//
//     final helpDeskRes = helpDeskResFromMap(jsonString);

import 'dart:convert';

HelpDeskRes helpDeskResFromMap(String str) => HelpDeskRes.fromMap(json.decode(str));

String helpDeskResToMap(HelpDeskRes data) => json.encode(data.toMap());

class HelpDeskRes {
  final String? title;
  final String? subTitle;
  final HelpDesk? helpDesk;

  HelpDeskRes({
    this.title,
    this.subTitle,
    this.helpDesk,
  });

  factory HelpDeskRes.fromMap(Map<String, dynamic> json) => HelpDeskRes(
    title: json["title"],
    subTitle: json["sub_title"],
    helpDesk: json["data"] == null ? null : HelpDesk.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "sub_title": subTitle,
    "data": helpDesk?.toMap(),
  };
}

class HelpDesk {
  final Header? header;
  final List<TicketList>? ticketList;
  final Footer? footer;
  final String? noTicketsMessage;
  final int? totalTickets;
  final List<Subject>? subjects;

  HelpDesk({
    this.header,
    this.ticketList,
    this.footer,
    this.noTicketsMessage,
    this.totalTickets,
    this.subjects,
  });

  factory HelpDesk.fromMap(Map<String, dynamic> json) => HelpDesk(
    header: json["header"] == null ? null : Header.fromMap(json["header"]),
    ticketList: json["ticket_list"] == null ? [] : List<TicketList>.from(json["ticket_list"]!.map((x) => TicketList.fromMap(x))),
    footer: json["footer"] == null ? null : Footer.fromMap(json["footer"]),
    noTicketsMessage: json["no_tickets_message"],
    totalTickets: json["total_tickets"],
    subjects: json["subjects"] == null ? [] : List<Subject>.from(json["subjects"]!.map((x) => Subject.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "header": header?.toMap(),
    "ticket_list": ticketList == null ? [] : List<dynamic>.from(ticketList!.map((x) => x.toMap())),
    "footer": footer?.toMap(),
    "no_tickets_message": noTicketsMessage,
    "total_tickets": totalTickets,
    "subjects": subjects == null ? [] : List<dynamic>.from(subjects!.map((x) => x.toMap())),
  };
}

class Footer {
  final String? text;

  Footer({
    this.text,
  });

  factory Footer.fromMap(Map<String, dynamic> json) => Footer(
    text: json["text"],
  );

  Map<String, dynamic> toMap() => {
    "text": text,
  };
}

class Header {
  final String? icon;
  final String? title;
  final int? activeTicketsCount;
  final String? actionButton;

  Header({
    this.icon,
    this.title,
    this.activeTicketsCount,
    this.actionButton,
  });

  factory Header.fromMap(Map<String, dynamic> json) => Header(
    icon: json["icon"],
    title: json["title"],
    activeTicketsCount: json["active_tickets_count"],
    actionButton: json["action_button"],
  );

  Map<String, dynamic> toMap() => {
    "icon": icon,
    "title": title,
    "active_tickets_count": activeTicketsCount,
    "action_button": actionButton,
  };
}

class Subject {
  final String? id;
  final String? title;

  Subject({
    this.id,
    this.title,
  });

  factory Subject.fromMap(Map<String, dynamic> json) => Subject(
    id: json["_id"],
    title: json["title"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "title": title,
  };
}

class TicketList {
  final String? icon;
  final String? ticketId;
  final int? ticketNo;
  final String? subject;
  final String? message;
  final String? ticketDate;
  final int? status;
  final String? statusLabel;
  final String? resolveDate;

  TicketList({
    this.icon,
    this.ticketId,
    this.ticketNo,
    this.subject,
    this.message,
    this.ticketDate,
    this.status,
    this.statusLabel,
    this.resolveDate,
  });

  factory TicketList.fromMap(Map<String, dynamic> json) => TicketList(
    icon: json["icon"],
    ticketId: json["ticket_id"],
    ticketNo: json["ticket_no"],
    subject: json["subject"],
    message: json["message"],
    ticketDate: json["ticket_date"],
    status: json["status"],
    statusLabel: json["status_label"],
    resolveDate: json["resolve_date"],
  );

  Map<String, dynamic> toMap() => {
    "icon": icon,
    "ticket_id": ticketId,
    "ticket_no": ticketNo,
    "subject": subject,
    "message": message,
    "ticket_date": ticketDate,
    "status": status,
    "status_label": statusLabel,
    "resolve_date": resolveDate,
  };
}

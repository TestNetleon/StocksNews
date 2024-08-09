// // To parse this JSON data, do
// //
// //     final helpDeskRes = helpDeskResFromJson(jsonString);

// import 'dart:convert';

// HelpDeskRes helpDeskResFromJson(String str) =>
//     HelpDeskRes.fromJson(json.decode(str));

// String helpDeskResToJson(HelpDeskRes data) => json.encode(data.toJson());

// class HelpDeskRes {
//   final String? noTicketMsg;

//   final List<Ticket>? tickets;
//   final List<Subject>? subjects;

//   HelpDeskRes({
//     this.noTicketMsg,
//     this.tickets,
//     this.subjects,
//   });

//   factory HelpDeskRes.fromJson(Map<String, dynamic> json) => HelpDeskRes(
//         noTicketMsg: json["no_ticket_msg"],
//         tickets: json["tickets"] == null
//             ? null
//             : List<Ticket>.from(json["tickets"].map((x) => Ticket.fromJson(x))),
//         subjects: json["subjects"] == null
//             ? null
//             : List<Subject>.from(
//                 json["subjects"].map((x) => Subject.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "no_ticket_msg": noTicketMsg,
//         "tickets": tickets == null
//             ? null
//             : List<dynamic>.from(tickets!.map((x) => x.toJson())),
//         "subjects": subjects == null
//             ? null
//             : List<dynamic>.from(subjects!.map((x) => x.toJson())),
//       };
// }

// class Ticket {
//   final String? id;
//   final int? ticketNo;
//   final String? message;
//   final String? ticketDate;
//   final String? subject;

//   Ticket({
//     this.id,
//     this.ticketNo,
//     this.message,
//     this.ticketDate,
//     this.subject,
//   });

//   factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
//         id: json["_id"],
//         ticketNo: json["ticket_no"],
//         message: json["message"],
//         ticketDate: json["ticket_date"],
//         subject: json["subject"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "ticket_no": ticketNo,
//         "message": message,
//         "ticket_date": ticketDate,
//         "subject": subject,
//       };
// }

// class Subject {
//   final String? id;
//   final String? title;
//   final int? status;
//   final String? updatedAt;
//   final String? createdAt;

//   Subject({
//     this.id,
//     this.title,
//     this.status,
//     this.updatedAt,
//     this.createdAt,
//   });

//   factory Subject.fromJson(Map<String, dynamic> json) => Subject(
//         id: json["_id"],
//         title: json["title"],
//         status: json["status"],
//         updatedAt: json["updated_at"],
//         createdAt: json["created_at"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "title": title,
//         "status": status,
//         "updated_at": updatedAt,
//         "created_at": createdAt,
//       };
// }
// To parse this JSON data, do
//
//     final helpDeskRes = helpDeskResFromJson(jsonString);

import 'dart:convert';

HelpDeskRes helpDeskResFromJson(String str) =>
    HelpDeskRes.fromJson(json.decode(str));

String helpDeskResToJson(HelpDeskRes data) => json.encode(data.toJson());

class HelpDeskRes {
  final String? noTicketMsg;
  final int? totalTickets;
  final int? totalActive;

  final List<Ticket>? tickets;
  final List<Subject>? subjects;

  HelpDeskRes({
    this.noTicketMsg,
    this.totalActive,
    this.totalTickets,
    this.tickets,
    this.subjects,
  });

  factory HelpDeskRes.fromJson(Map<String, dynamic> json) => HelpDeskRes(
        noTicketMsg: json["no_ticket_msg"],
        totalTickets: json["total_tickets"],
        totalActive: json['total_active_tickets'],
        tickets: json["tickets"] == [] || json["tickets"] == null
            ? null
            : List<Ticket>.from(json["tickets"].map((x) => Ticket.fromJson(x))),
        subjects: json["subjects"] == null
            ? null
            : List<Subject>.from(
                json["subjects"].map((x) => Subject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "no_ticket_msg": noTicketMsg,
        "total_tickets": totalTickets,
        "total_active_tickets": totalActive,
        "tickets": tickets == [] || tickets == null
            ? null
            : List<dynamic>.from(tickets!.map((x) => x.toJson())),
        "subjects": subjects == null
            ? null
            : List<dynamic>.from(subjects!.map((x) => x.toJson())),
      };
}

class Subject {
  final String? id;
  final String? title;

  Subject({
    this.id,
    this.title,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: json["_id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
      };
}

class Ticket {
  final int? ticketNo;
  final String? ticketId;

  final String? subject;
  final String? message;
  final String? ticketDate;
  final String? resolvedOn;

  final int? status;
  final String? statusText;

  Ticket({
    this.ticketNo,
    this.resolvedOn,
    this.ticketId,
    this.subject,
    this.message,
    this.ticketDate,
    this.status,
    this.statusText,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        ticketNo: json["ticket_no"],
        ticketId: json["ticket_id"],
        resolvedOn: json['resolve_date'],
        subject: json["subject"],
        message: json["message"],
        ticketDate: json["ticket_date"],
        status: json["status"],
        statusText: json["status_text"],
      );

  Map<String, dynamic> toJson() => {
        "ticket_no": ticketNo,
        "ticket_id": ticketId,
        "subject": subject,
        "resolve_date": resolvedOn,
        "message": message,
        "ticket_date": ticketDate,
        "status": status,
        "status_text": statusText,
      };
}

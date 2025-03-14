import 'dart:convert';

List<ClaimPointsRes> claimPointsResFromJson(String str) =>
    List<ClaimPointsRes>.from(
        json.decode(str).map((x) => ClaimPointsRes.fromJson(x)));

String claimPointsResToJson(List<ClaimPointsRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClaimPointsRes {
  final String? title;
  final String? type;

  final int? points;
  final int? targetPoints;
  final int? claimPoints;
  final bool status;
  final String? text;

  ClaimPointsRes({
    this.title,
    this.type,
    this.points,
    this.targetPoints,
    this.claimPoints,
    this.text,
    required this.status,
  });

  factory ClaimPointsRes.fromJson(Map<String, dynamic> json) => ClaimPointsRes(
        title: json["title"],
        text: json['text'],
        type: json["type"],
        points: json["points"],
        targetPoints: json["targetPoints"],
        claimPoints: json["claimPoints"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "type": type,
        "points": points,
        'text': text,
        "targetPoints": targetPoints,
        "claimPoints": claimPoints,
        "status": status,
      };
}

// To parse this JSON data, do
//
//     final faQsRes = faQsResFromJson(jsonString);

import 'dart:convert';

List<FaQsRes> faQsResFromJson(String str) =>
    List<FaQsRes>.from(json.decode(str).map((x) => FaQsRes.fromJson(x)));

String faQsResToJson(List<FaQsRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FaQsRes {
  final String question;
  final String answer;
  
  FaQsRes({
    required this.question,
    required this.answer,
  });

  factory FaQsRes.fromJson(Map<String, dynamic> json) => FaQsRes(
        question: json["question"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "answer": answer,
      };
}

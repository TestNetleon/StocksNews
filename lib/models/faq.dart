import 'dart:convert';

List<BaseFaqRes> baseFaqResFromJson(String str) =>
    List<BaseFaqRes>.from(json.decode(str).map((x) => BaseFaqRes.fromJson(x)));

String baseFaqResToJson(List<BaseFaqRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BaseFaqRes {
  final String? question;
  final String? answer;

  BaseFaqRes({
    this.question,
    this.answer,
  });

  factory BaseFaqRes.fromJson(Map<String, dynamic> json) => BaseFaqRes(
        question: json["question"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "answer": answer,
      };
}

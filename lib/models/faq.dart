import 'dart:convert';

BaseFaqRes baseFaqResFromJson(String str) =>
    BaseFaqRes.fromJson(json.decode(str));

String baseFaqResToJson(BaseFaqRes data) => json.encode(data.toJson());

class BaseFaqRes {
  final String? title;
  final String? subTitle;
  final List<BaseFaqDataRes>? data;

  BaseFaqRes({
    this.title,
    this.subTitle,
    this.data,
  });

  factory BaseFaqRes.fromJson(Map<String, dynamic> json) => BaseFaqRes(
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<BaseFaqDataRes>.from(
                json["data"]!.map((x) => BaseFaqDataRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class BaseFaqDataRes {
  final String? question;
  final String? answer;

  BaseFaqDataRes({
    this.question,
    this.answer,
  });

  factory BaseFaqDataRes.fromJson(Map<String, dynamic> json) => BaseFaqDataRes(
        question: json["question"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "answer": answer,
      };
}

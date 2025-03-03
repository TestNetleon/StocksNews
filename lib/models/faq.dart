import 'dart:convert';

BaseFaqRes baseFaqResFromJson(String str) =>
    BaseFaqRes.fromJson(json.decode(str));

String baseFaqResToJson(BaseFaqRes data) => json.encode(data.toJson());

class BaseFaqRes {
  final String? title;
  final String? subTitle;
  final List<BaseFaqDataRes>? faqs;

  BaseFaqRes({
    this.title,
    this.subTitle,
    this.faqs,
  });

  factory BaseFaqRes.fromJson(Map<String, dynamic> json) => BaseFaqRes(
        title: json["title"],
        subTitle: json["sub_title"],
    faqs: json["data"] == null
            ? []
            : List<BaseFaqDataRes>.from(
                json["data"]!.map((x) => BaseFaqDataRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": faqs == null
            ? []
            : List<dynamic>.from(faqs!.map((x) => x.toJson())),
      };
}

class BaseFaqDataRes {
  final String? id;
  final String? question;
  final String? answer;

  BaseFaqDataRes({
    this.id,
    this.question,
    this.answer,
  });

  factory BaseFaqDataRes.fromJson(Map<String, dynamic> json) => BaseFaqDataRes(
        id: json["_id"],
        question: json["question"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "question": question,
        "answer": answer,
      };
}

import 'dart:convert';

FeedbackSendRes feedbackSendResFromMap(String str) => FeedbackSendRes.fromMap(json.decode(str));

String feedbackSendResToMap(FeedbackSendRes data) => json.encode(data.toMap());

class FeedbackSendRes {
  final String? image;
  final String? title;
  final String? subTitle;
  final String? firstButtonText;
  final String? secondButtonText;
  final String? url;

  FeedbackSendRes({
    this.image,
    this.title,
    this.subTitle,
    this.firstButtonText,
    this.secondButtonText,
    this.url,
  });

  factory FeedbackSendRes.fromMap(Map<String, dynamic> json) => FeedbackSendRes(
    image: json["image"],
    title: json["title"],
    subTitle: json["sub_title"],
    firstButtonText: json["first_button_text"],
    secondButtonText: json["second_button_text"],
    url: json["url"],
  );

  Map<String, dynamic> toMap() => {
    "image": image,
    "title": title,
    "sub_title": subTitle,
    "first_button_text": firstButtonText,
    "second_button_text": secondButtonText,
    "url": url,
  };
}

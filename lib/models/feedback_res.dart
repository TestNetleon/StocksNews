import 'dart:convert';

FeedbackRes feedbackResFromMap(String str) => FeedbackRes.fromMap(json.decode(str));

String feedbackResToMap(FeedbackRes data) => json.encode(data.toMap());

class FeedbackRes {
  final String? title;
  final String? subTitle;
  final List<Option>? options;
  final String? placeholderText;
  final String? buttonText;

  FeedbackRes({
    this.title,
    this.subTitle,
    this.options,
    this.placeholderText,
    this.buttonText,
  });

  factory FeedbackRes.fromMap(Map<String, dynamic> json) => FeedbackRes(
    title: json["title"],
    subTitle: json["sub_title"],
    options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromMap(x))),
    placeholderText: json["placeholder_text"],
    buttonText: json["button_text"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "sub_title": subTitle,
    "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toMap())),
    "placeholder_text": placeholderText,
    "button_text": buttonText,
  };
}

class Option {
  final String? image;
  final String? type;
  final String? title;

  Option({
    this.image,
    this.type,
    this.title,
  });

  factory Option.fromMap(Map<String, dynamic> json) => Option(
    image: json["image"],
    type: json["type"],
    title: json["title"],
  );

  Map<String, dynamic> toMap() => {
    "image": image,
    "type": type,
    "title": title,
  };
}

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

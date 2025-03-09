class BaseLockInfoRes {
  final String? title;
  final String? subTitle;
  final List<String>? text;
  final String? btn;
  final String? viewBtn;
  final String? image;

  BaseLockInfoRes({
    this.title,
    this.text,
    this.subTitle,
    this.btn,
    this.viewBtn,
    this.image,
  });

  factory BaseLockInfoRes.fromJson(Map<String, dynamic> json) =>
      BaseLockInfoRes(
        subTitle: json['subtitle'],
        title: json["title"],
        text: json["text"] == null
            ? []
            : List<String>.from(json["text"]!.map((x) => x)),
        btn: json["btn"],
        viewBtn: json["view_btn"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        'subtitle': subTitle,
        "title": title,
        "text": text == null ? [] : List<dynamic>.from(text!.map((x) => x)),
        "btn": btn,
        "view_btn": viewBtn,
        "image": image,
      };
}

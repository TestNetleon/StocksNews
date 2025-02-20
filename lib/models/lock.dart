class BaseLockInfoRes {
  final String? title;
  final List<String>? text;
  final String? btn;
  final String? viewBtn;

  BaseLockInfoRes({
    this.title,
    this.text,
    this.btn,
    this.viewBtn,
  });

  factory BaseLockInfoRes.fromJson(Map<String, dynamic> json) =>
      BaseLockInfoRes(
        title: json["title"],
        text: json["text"] == null
            ? []
            : List<String>.from(json["text"]!.map((x) => x)),
        btn: json["btn"],
        viewBtn: json["view_btn"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "text": text == null ? [] : List<dynamic>.from(text!.map((x) => x)),
        "btn": btn,
        "view_btn": viewBtn,
      };
}

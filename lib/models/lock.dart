class BaseLockInfoRes {
  final String? title;
  final String? subTitle;
  final String? other;
  final List<String>? text;
  final String? btn;
  final String? viewBtn;
  final String? image;
  final String? imageDark;
  final num? pointsRequired;
  final String? popUpMessage;
  final String? popUpButton;
  final String? warningText;
  final num? bottomHeight;

  BaseLockInfoRes({
    this.title,
    this.text,
    this.other,
    this.subTitle,
    this.btn,
    this.viewBtn,
    this.image,
    this.imageDark,
    this.pointsRequired,
    this.popUpMessage,
    this.popUpButton,
    this.warningText,
    this.bottomHeight,
  });

  factory BaseLockInfoRes.fromJson(Map<String, dynamic> json) =>
      BaseLockInfoRes(
        pointsRequired: json['point_required'],
        popUpButton: json['popup_button'],
        popUpMessage: json['popup_message'],
        subTitle: json['subtitle'],
        other: json['other'],
        bottomHeight: json['bottom_height'],
        title: json["title"],
        warningText: json['warning_text'],
        text: json["text"] == null
            ? []
            : List<String>.from(json["text"]!.map((x) => x)),
        btn: json["btn"],
        viewBtn: json["view_btn"],
        image: json["image"],
        imageDark: json["image_dark"],
      );

  Map<String, dynamic> toJson() => {
        'point_required': pointsRequired,
        'popup_message': popUpMessage,
        'popup_button': popUpButton,
        'subtitle': subTitle,
        'other': other,
        'bottom_height': bottomHeight,
        "title": title,
        "text": text == null ? [] : List<dynamic>.from(text!.map((x) => x)),
        "btn": btn,
        'warning_text': warningText,
        "view_btn": viewBtn,
        "image": image,
        "image_dark": imageDark,
      };
}

class LockInformation {
  final bool? readingStatus;
  final String? title;
  final String? readingSubtitle;
  final String? readingTitle;
  final bool? balanceStatus;
  final int? totalPoints;
  final int? pointRequired;
  final String? popUpMessage;
  final String? popUpButton;
  final dynamic showSubscribeBtn;
  final dynamic showUpgradeBtn;
  final dynamic showViewBtn;

  LockInformation({
    this.readingStatus,
    this.title,
    this.readingSubtitle,
    this.readingTitle,
    this.balanceStatus,
    this.totalPoints,
    this.pointRequired,
    this.popUpMessage,
    this.popUpButton,
    this.showSubscribeBtn,
    this.showUpgradeBtn,
    this.showViewBtn,
  });

  factory LockInformation.fromJson(Map<String, dynamic> json) =>
      LockInformation(
        readingStatus: json["reading_status"],
        title: json["title"],
        readingSubtitle: json["reading_subtitle"],
        readingTitle: json["reading_title"],
        balanceStatus: json["balance_status"],
        totalPoints: json["total_points"],
        pointRequired: json["point_required"],
        popUpMessage: json["popup_message"],
        popUpButton: json["popup_button"],
        showSubscribeBtn: json["show_subscribe_btn"],
        showUpgradeBtn: json["show_upgrade_btn"],
        showViewBtn: json["show_view_btn"],
      );

  Map<String, dynamic> toJson() => {
        "reading_status": readingStatus,
        "title": title,
        "reading_subtitle": readingSubtitle,
        "reading_title": readingTitle,
        "balance_status": balanceStatus,
        "total_points": totalPoints,
        "point_required": pointRequired,
        "popup_message": popUpMessage,
        "popup_button": popUpButton,
        "show_subscribe_btn": showSubscribeBtn,
        "show_upgrade_btn": showUpgradeBtn,
        "show_view_btn": showViewBtn,
      };
}

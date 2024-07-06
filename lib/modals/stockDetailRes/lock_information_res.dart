class LockInformation {
    final bool? readingStatus;
    final String? title;
    final String? readingSubtitle;
    final String? readingTitle;
    final bool? balanceStatus;
    final int? totalPoints;
    final int? pointRequired;

    LockInformation({
        this.readingStatus,
        this.title,
        this.readingSubtitle,
        this.readingTitle,
        this.balanceStatus,
        this.totalPoints,
        this.pointRequired,
    });

    factory LockInformation.fromJson(Map<String, dynamic> json) => LockInformation(
        readingStatus: json["reading_status"],
        title: json["title"],
        readingSubtitle: json["reading_subtitle"],
        readingTitle: json["reading_title"],
        balanceStatus: json["balance_status"],
        totalPoints: json["total_points"],
        pointRequired: json["point_required"],
    );

    Map<String, dynamic> toJson() => {
        "reading_status": readingStatus,
        "title": title,
        "reading_subtitle": readingSubtitle,
        "reading_title": readingTitle,
        "balance_status": balanceStatus,
        "total_points": totalPoints,
        "point_required": pointRequired,
    };
}
class LoginVisibility {
  final String screenName;
  final String lastVisible;
  final int count;
  final int status;
  final int maxCount;

  LoginVisibility({
    required this.screenName,
    required this.lastVisible,
    required this.count,
    required this.status,
    required this.maxCount,
  });

  factory LoginVisibility.fromJson(Map<String, dynamic> json) =>
      LoginVisibility(
        screenName: json["screen_name"],
        lastVisible: json["last_visible"],
        count: json["visible_count"],
        status: json["status"],
        maxCount: json["max_visible_count"],
      );

  Map<String, dynamic> toJson() => {
        "screen_name": screenName,
        "last_visible": lastVisible,
        "visible_count": count,
        "status": status,
        "max_visible_count": maxCount,
      };
}

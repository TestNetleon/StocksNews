class WeeklyLoginRes {
  final String? userID;
  final String? name;
  final String? email;
  final String? phone;
  final String? phoneCode;
  final DateTime openTime;

  WeeklyLoginRes({
    this.userID,
    this.name,
    this.email,
    this.phone,
    this.phoneCode,
    required this.openTime,
  });

  factory WeeklyLoginRes.fromJson(Map<String, dynamic> json) => WeeklyLoginRes(
        userID: json["user_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        phoneCode: json["phone_code"],
        openTime: DateTime.parse(json["open_time"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userID,
        "name": name,
        "email": email,
        "phone": phone,
        "phone_code": phoneCode,
        "open_time": openTime.toIso8601String(),
      };
}

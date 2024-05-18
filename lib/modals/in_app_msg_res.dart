class InAppNotification {
  final String id;
  final String title;
  final String description;
  final String image;
  final String popupType;

  InAppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.popupType,
  });

  factory InAppNotification.fromJson(Map<String, dynamic> json) =>
      InAppNotification(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        popupType: json["popup_type"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "image": image,
        "popup_type": popupType,
      };
}

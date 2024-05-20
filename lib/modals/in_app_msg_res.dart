class InAppNotification {
  final String id;
  final String title;
  final String popupType;
  final String? description;
  final String? image;
  final String? redirectOn;
  final String? slug;

  InAppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.popupType,
    required this.redirectOn,
    required this.slug,
  });

  factory InAppNotification.fromJson(Map<String, dynamic> json) =>
      InAppNotification(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        popupType: json["popup_type"],
        redirectOn: json["redirect_on"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "image": image,
        "popup_type": popupType,
        "redirect_on": redirectOn,
        "slug": slug,
      };
}

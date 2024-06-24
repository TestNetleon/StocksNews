class DeeplinkData {
  Uri? uri;
  String? type;
  String? slug;
  String? path;
  String? from;
  bool? onDeepLink;

  DeeplinkData({
    required this.uri,
    required this.from,
    required this.onDeepLink,
    this.type,
    this.slug,
    this.path,
  });

  Map<String, dynamic> toJson() {
    return {
      'uri': uri?.toString(),
      'type': type,
      'slug': slug,
      'path': path,
      'from': from,
      'onDeepLink': onDeepLink,
    };
  }

  factory DeeplinkData.fromJson(Map<String, dynamic> json) {
    return DeeplinkData(
      uri: json['uri'] != null ? Uri.parse(json['uri']) : null,
      type: json['type'],
      slug: json['slug'],
      path: json['path'],
      from: json['from'],
      onDeepLink: json['onDeepLink'],
    );
  }
}

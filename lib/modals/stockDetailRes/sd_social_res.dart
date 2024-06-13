import 'dart:convert';

SdSocialRes sdSocialResFromJson(String str) =>
    SdSocialRes.fromJson(json.decode(str));

String sdSocialResToJson(SdSocialRes data) => json.encode(data.toJson());

class SdSocialRes {
  final List<AllMention> allMention;
  final String? mentionText;

  SdSocialRes({
    required this.allMention,
    this.mentionText,
  });

  factory SdSocialRes.fromJson(Map<String, dynamic> json) => SdSocialRes(
        allMention: List<AllMention>.from(
            json["all_mention"].map((x) => AllMention.fromJson(x))),
        mentionText: json["mention_text"],
      );

  Map<String, dynamic> toJson() => {
        "all_mention": List<dynamic>.from(allMention.map((x) => x.toJson())),
        "mention_text": mentionText,
      };
}

class AllMention {
  final String? website;
  final int? mentionCount;

  AllMention({
    this.website,
    this.mentionCount,
  });

  factory AllMention.fromJson(Map<String, dynamic> json) => AllMention(
        website: json["website"],
        mentionCount: json["mention_count"],
      );

  Map<String, dynamic> toJson() => {
        "website": website,
        "mention_count": mentionCount,
      };
}

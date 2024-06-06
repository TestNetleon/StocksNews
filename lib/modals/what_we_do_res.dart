// To parse this JSON data, do
//
//     final whatWeDoTabRes = whatWeDoTabResFromJson(jsonString);

import 'dart:convert';

WhatWeDoTabRes whatWeDoTabResFromJson(String str) =>
    WhatWeDoTabRes.fromJson(json.decode(str));

String whatWeDoTabResToJson(WhatWeDoTabRes data) => json.encode(data.toJson());

class WhatWeDoTabRes {
  final List<WhatWeDoTabDataRes> list;

  WhatWeDoTabRes({
    required this.list,
  });

  factory WhatWeDoTabRes.fromJson(Map<String, dynamic> json) => WhatWeDoTabRes(
        list: List<WhatWeDoTabDataRes>.from(
            json["list"].map((x) => WhatWeDoTabDataRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class WhatWeDoTabDataRes {
  final String slug;
  final String title;

  WhatWeDoTabDataRes({
    required this.slug,
    required this.title,
  });

  factory WhatWeDoTabDataRes.fromJson(Map<String, dynamic> json) =>
      WhatWeDoTabDataRes(
        slug: json["slug"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "slug": slug,
        "title": title,
      };
}

// To parse this JSON data, do
//
//     final whatWeDoRes = whatWeDoResFromJson(jsonString);

import 'dart:convert';

WhatWeDoRes whatWeDoResFromJson(String str) =>
    WhatWeDoRes.fromJson(json.decode(str));

String whatWeDoResToJson(WhatWeDoRes data) => json.encode(data.toJson());

class WhatWeDoRes {
  final WhatWeDoDataRes page;
  final String title;
  final dynamic subTitle;

  WhatWeDoRes({
    required this.page,
    required this.title,
    required this.subTitle,
  });

  factory WhatWeDoRes.fromJson(Map<String, dynamic> json) => WhatWeDoRes(
        page: WhatWeDoDataRes.fromJson(json["page"]),
        title: json["title"],
        subTitle: json["sub_title"],
      );

  Map<String, dynamic> toJson() => {
        "page": page.toJson(),
        "title": title,
        "sub_title": subTitle,
      };
}

class WhatWeDoDataRes {
  final String description;

  WhatWeDoDataRes({
    required this.description,
  });

  factory WhatWeDoDataRes.fromJson(Map<String, dynamic> json) =>
      WhatWeDoDataRes(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}

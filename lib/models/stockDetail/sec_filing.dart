import 'dart:convert';

SDSecFilingRes SDSecFilingResFromJson(String str) =>
    SDSecFilingRes.fromJson(json.decode(str));

String SDSecFilingResToJson(SDSecFilingRes data) => json.encode(data.toJson());

class SDSecFilingRes {
  final String? title;
  final String? subTitle;
  final List<SecFilingDataRes>? data;

  SDSecFilingRes({
    this.title,
    this.subTitle,
    this.data,
  });

  factory SDSecFilingRes.fromJson(Map<String, dynamic> json) => SDSecFilingRes(
        title: json["title"],
        subTitle: json["sub_title"],
        data: json["data"] == null
            ? []
            : List<SecFilingDataRes>.from(
                json["data"]!.map((x) => SecFilingDataRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SecFilingDataRes {
  final String? fillingDate;
  final String? acceptedDate;
  final String? link;

  SecFilingDataRes({
    this.fillingDate,
    this.acceptedDate,
    this.link,
  });

  factory SecFilingDataRes.fromJson(Map<String, dynamic> json) =>
      SecFilingDataRes(
        fillingDate: json["fillingDate"],
        acceptedDate: json["acceptedDate"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "fillingDate": fillingDate,
        "acceptedDate": acceptedDate,
        "link": link,
      };
}

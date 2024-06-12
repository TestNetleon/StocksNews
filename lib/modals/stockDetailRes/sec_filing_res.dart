import 'dart:convert';

SecFilingRes secFilingResFromJson(String str) =>
    SecFilingRes.fromJson(json.decode(str));

String secFilingResToJson(SecFilingRes data) => json.encode(data.toJson());

class SecFilingRes {
  final List<SecFiling> secFilings;

  SecFilingRes({
    required this.secFilings,
  });

  factory SecFilingRes.fromJson(Map<String, dynamic> json) => SecFilingRes(
        secFilings: List<SecFiling>.from(
            json["sec_filings"].map((x) => SecFiling.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sec_filings": List<dynamic>.from(secFilings.map((x) => x.toJson())),
      };
}

class SecFiling {
  final String fillingDate;
  final String acceptedDate;
  final String link;

  SecFiling({
    required this.fillingDate,
    required this.acceptedDate,
    required this.link,
  });

  factory SecFiling.fromJson(Map<String, dynamic> json) => SecFiling(
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

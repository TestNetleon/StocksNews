import 'dart:convert';

SdMergersRes sdMergersResFromJson(String str) =>
    SdMergersRes.fromJson(json.decode(str));

String sdMergersResToJson(SdMergersRes data) => json.encode(data.toJson());

class SdMergersRes {
  final List<MergersList>? mergersList;

  SdMergersRes({
    this.mergersList,
  });

  factory SdMergersRes.fromJson(Map<String, dynamic> json) => SdMergersRes(
        mergersList: json["mergers_list"] == null
            ? null
            : List<MergersList>.from(
                json["mergers_list"].map((x) => MergersList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mergers_list": mergersList == null
            ? null
            : List<dynamic>.from(mergersList!.map((x) => x.toJson())),
      };
}

class MergersList {
  final String? targetedCompanyName;
  final String? symbol;
  final String? transactionDate;
  final String? acceptanceTime;
  final String? link;

  MergersList({
    this.targetedCompanyName,
    this.symbol,
    this.transactionDate,
    this.acceptanceTime,
    this.link,
  });

  factory MergersList.fromJson(Map<String, dynamic> json) => MergersList(
        targetedCompanyName: json["targetedCompanyName"],
        symbol: json["symbol"],
        transactionDate: json["transactionDate"],
        acceptanceTime: json["acceptanceTime"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "targetedCompanyName": targetedCompanyName,
        "symbol": symbol,
        "transactionDate": transactionDate,
        "acceptanceTime": acceptanceTime,
        "link": link,
      };
}

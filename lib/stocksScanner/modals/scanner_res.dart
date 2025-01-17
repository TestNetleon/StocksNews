import 'dart:convert';

// List<ScannerRes> scannerResFromJson(String str) =>
//     List<ScannerRes>.from(json.decode(str).map((x) => ScannerRes.fromJson(x)));

List<ScannerRes> scannerResFromJson(List<dynamic> data) =>
    List<ScannerRes>.from(data.map((x) => ScannerRes.fromJson(x)));

String scannerResToJson(List<ScannerRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ScannerRes {
  final dynamic identifier;
  final dynamic name;
  final dynamic sector;
  final dynamic ask;
  final dynamic bid;
  final dynamic price;
  final dynamic change;
  final dynamic changesPercentage;
  final dynamic volume;
  final dynamic time;
  final dynamic closeDate;
  final Ext? ext;

  ScannerRes({
    required this.identifier,
    required this.name,
    required this.sector,
    required this.ask,
    required this.bid,
    required this.price,
    required this.change,
    required this.changesPercentage,
    required this.volume,
    required this.time,
    required this.closeDate,
    required this.ext,
  });

  factory ScannerRes.fromJson(Map<String, dynamic> json) => ScannerRes(
        identifier: json["Identifier"],
        name: json["name"],
        sector: json["sector"],
        ask: json["ask"],
        bid: json["bid"],
        price: json["price"],
        change: json["change"],
        changesPercentage: json["changesPercentage"],
        volume: json["volume"],
        time: json["time"],
        closeDate: json["closeDate"],
        ext: json["Ext"] == null ? null : Ext.fromJson(json["Ext"]),
      );

  Map<String, dynamic> toJson() => {
        "Identifier": identifier,
        "name": name,
        "sector": sector,
        "ask": ask,
        "bid": bid,
        "price": price,
        "change": change,
        "changesPercentage": changesPercentage,
        "volume": volume,
        "time": time,
        "closeDate": closeDate,
        "Ext": ext?.toJson(),
      };
}

class Ext {
  final dynamic extendedHoursDate;
  final dynamic extendedHoursTime;
  final dynamic extendedHoursType;
  final dynamic extendedHoursPrice;
  final dynamic extendedHoursChange;
  final dynamic extendedHoursPercentChange;

  Ext({
    required this.extendedHoursDate,
    required this.extendedHoursTime,
    required this.extendedHoursType,
    required this.extendedHoursPrice,
    required this.extendedHoursChange,
    required this.extendedHoursPercentChange,
  });

  factory Ext.fromJson(Map<String, dynamic> json) => Ext(
        extendedHoursDate: json["ExtendedHoursDate"],
        extendedHoursTime: json["ExtendedHoursTime"],
        extendedHoursType: json["ExtendedHoursType"],
        extendedHoursPrice: json["ExtendedHoursPrice"],
        extendedHoursChange: json["ExtendedHoursChange"],
        extendedHoursPercentChange: json["ExtendedHoursPercentChange"],
      );

  Map<String, dynamic> toJson() => {
        "ExtendedHoursDate": extendedHoursDate,
        "ExtendedHoursTime": extendedHoursTime,
        "ExtendedHoursType": extendedHoursType,
        "ExtendedHoursPrice": extendedHoursPrice,
        "ExtendedHoursChange": extendedHoursChange,
        "ExtendedHoursPercentChange": extendedHoursPercentChange,
      };
}

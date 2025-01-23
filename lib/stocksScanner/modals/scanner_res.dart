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
  final String? image;

  ScannerRes({
    this.identifier,
    this.name,
    this.sector,
    this.ask,
    this.bid,
    this.price,
    this.change,
    this.changesPercentage,
    this.volume,
    this.time,
    this.closeDate,
    this.ext,
    this.image,
  });

  factory ScannerRes.fromJson(Map<String, dynamic> json) => ScannerRes(
        identifier: json["Identifier"],
        image: json['image'],
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
        'image': image,
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

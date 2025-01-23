// To parse this JSON data, do
//
//     final scannerPortsRes = scannerPortsResFromJson(jsonString);

import 'dart:convert';

ScannerPortsRes scannerPortsResFromJson(String str) =>
    ScannerPortsRes.fromJson(json.decode(str));

String scannerPortsResToJson(ScannerPortsRes data) =>
    json.encode(data.toJson());

class ScannerPortsRes {
  final PortRes? port;

  ScannerPortsRes({
    this.port,
  });

  factory ScannerPortsRes.fromJson(Map<String, dynamic> json) =>
      ScannerPortsRes(
        port: json["port"] == null ? null : PortRes.fromJson(json["port"]),
      );

  Map<String, dynamic> toJson() => {
        "port": port?.toJson(),
      };
}

class PortRes {
  final ScannerPortRes? scannerPort;
  final GainerLoserPortRes? gainerLoserPort;
  final OtherPortRes? otherPortRes;
  final CheckMarketOpenApiRes? checkMarketOpenApi;

  PortRes({
    this.scannerPort,
    this.gainerLoserPort,
    this.otherPortRes,
    this.checkMarketOpenApi,
  });

  factory PortRes.fromJson(Map<String, dynamic> json) => PortRes(
        scannerPort: json["scannerPort"] == null
            ? null
            : ScannerPortRes.fromJson(json["scannerPort"]),
        gainerLoserPort: json["gainerLoserPort"] == null
            ? null
            : GainerLoserPortRes.fromJson(json["gainerLoserPort"]),
        otherPortRes:
            json["other"] == null ? null : OtherPortRes.fromJson(json["other"]),
        checkMarketOpenApi: json["checkMarketOpenApi"] == null
            ? null
            : CheckMarketOpenApiRes.fromJson(json["checkMarketOpenApi"]),
      );

  Map<String, dynamic> toJson() => {
        "scannerPort": scannerPort?.toJson(),
        "gainerLoserPort": gainerLoserPort?.toJson(),
        "other": otherPortRes?.toJson(),
        "checkMarketOpenApi": checkMarketOpenApi?.toJson(),
      };
}

class CheckMarketOpenApiRes {
  final bool? isHoliday;
  final bool? isMarketOpen;
  final String? extendedHoursType;
  final String? extendedHoursTime;
  final DateTime? extendedHoursDate;
  final bool? checkPostMarket;
  final bool? checkPreMarket;
  final String? dateTime;

  CheckMarketOpenApiRes({
    this.isHoliday,
    this.isMarketOpen,
    this.extendedHoursType,
    this.extendedHoursTime,
    this.extendedHoursDate,
    this.checkPostMarket,
    this.checkPreMarket,
    this.dateTime,
  });

  factory CheckMarketOpenApiRes.fromJson(Map<String, dynamic> json) =>
      CheckMarketOpenApiRes(
        isHoliday: json["isHoliday"],
        isMarketOpen: json["isMarketOpen"],
        extendedHoursType: json["ExtendedHoursType"],
        extendedHoursTime: json["ExtendedHoursTime"],
        extendedHoursDate: json["ExtendedHoursDate"] == null
            ? null
            : DateTime.parse(json["ExtendedHoursDate"]),
        checkPostMarket: json["checkPostMarket"],
        checkPreMarket: json["checkPreMarket"],
        dateTime: json["dateTime"],
      );

  Map<String, dynamic> toJson() => {
        "isHoliday": isHoliday,
        "isMarketOpen": isMarketOpen,
        "ExtendedHoursType": extendedHoursType,
        "ExtendedHoursTime": extendedHoursTime,
        "ExtendedHoursDate":
            "${extendedHoursDate!.year.toString().padLeft(4, '0')}-${extendedHoursDate!.month.toString().padLeft(2, '0')}-${extendedHoursDate!.day.toString().padLeft(2, '0')}",
        "checkPostMarket": checkPostMarket,
        "checkPreMarket": checkPreMarket,
        "dateTime": dateTime,
      };
}

class GainerLoserPortRes {
  final int? gainer;
  final int? loser;

  GainerLoserPortRes({
    this.gainer,
    this.loser,
  });

  factory GainerLoserPortRes.fromJson(Map<String, dynamic> json) =>
      GainerLoserPortRes(
        gainer: json["gainer"],
        loser: json["loser"],
      );

  Map<String, dynamic> toJson() => {
        "gainer": gainer,
        "loser": loser,
      };
}

class ScannerPortRes {
  final int? start;
  final int? end;

  ScannerPortRes({
    this.start,
    this.end,
  });

  factory ScannerPortRes.fromJson(Map<String, dynamic> json) => ScannerPortRes(
        start: json["start"],
        end: json["end"],
      );

  Map<String, dynamic> toJson() => {
        "start": start,
        "end": end,
      };
}

class OtherPortRes {
  final int? simulator;
  final int? offline;

  OtherPortRes({
    this.simulator,
    this.offline,
  });

  factory OtherPortRes.fromJson(Map<String, dynamic> json) => OtherPortRes(
        simulator: json["simulator"],
        offline: json["offline"],
      );

  Map<String, dynamic> toJson() => {
        "simulator": simulator,
        "offline": offline,
      };
}

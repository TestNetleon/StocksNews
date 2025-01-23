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

  PortRes({
    this.scannerPort,
    this.gainerLoserPort,
    this.otherPortRes,
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
      );

  Map<String, dynamic> toJson() => {
        "scannerPort": scannerPort?.toJson(),
        "gainerLoserPort": gainerLoserPort?.toJson(),
        "other": otherPortRes?.toJson(),
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

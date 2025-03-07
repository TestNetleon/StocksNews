import 'dart:convert';

import 'package:stocks_news_new/models/lock.dart';

ScannerPortRes scannerPortResFromJson(String str) =>
    ScannerPortRes.fromJson(json.decode(str));

String scannerPortResToJson(ScannerPortRes data) => json.encode(data.toJson());

class ScannerPortRes {
  final BaseLockInfoRes? lockInfo;

  final PortRes? port;

  ScannerPortRes({
    this.lockInfo,
    this.port,
  });

  factory ScannerPortRes.fromJson(Map<String, dynamic> json) => ScannerPortRes(
        lockInfo: json["lock_info"] == null
            ? null
            : BaseLockInfoRes.fromJson(json["lock_info"]),
        port: json["port"] == null ? null : PortRes.fromJson(json["port"]),
      );

  Map<String, dynamic> toJson() => {
        "lock_info": lockInfo?.toJson(),
        "port": port?.toJson(),
      };
}

class PortRes {
  final ScannerPortDataRes? scanner;
  final GainerLoserPortRes? gainerLoser;
  final OtherPortRes? other;
  final CheckMarketOpenRes? checkMarketOpenApi;

  PortRes({
    this.scanner,
    this.gainerLoser,
    this.other,
    this.checkMarketOpenApi,
  });

  factory PortRes.fromJson(Map<String, dynamic> json) => PortRes(
        scanner: json["scanner"] == null
            ? null
            : ScannerPortDataRes.fromJson(json["scanner"]),
        gainerLoser: json["gainerLoser"] == null
            ? null
            : GainerLoserPortRes.fromJson(json["gainerLoser"]),
        other:
            json["other"] == null ? null : OtherPortRes.fromJson(json["other"]),
        checkMarketOpenApi: json["checkMarketOpenApi"] == null
            ? null
            : CheckMarketOpenRes.fromJson(json["checkMarketOpenApi"]),
      );

  Map<String, dynamic> toJson() => {
        "scanner": scanner?.toJson(),
        "gainerLoser": gainerLoser?.toJson(),
        "other": other?.toJson(),
        "checkMarketOpenApi": checkMarketOpenApi?.toJson(),
      };
}

class CheckMarketOpenRes {
  final bool? isHoliday;
  final bool? isMarketOpen;
  final String? extendedHoursType;
  final String? extendedHoursTime;
  final String? extendedHoursDate;
  final String? postMarketLiveTime;
  final bool? checkPostMarket;
  final bool? checkPreMarket;
  final bool? postMarketStream;
  final String? dateTime;
  final bool? startStreaming;

  CheckMarketOpenRes({
    this.isHoliday,
    this.startStreaming,
    this.isMarketOpen,
    this.extendedHoursType,
    this.extendedHoursTime,
    this.extendedHoursDate,
    this.postMarketLiveTime,
    this.postMarketStream,
    this.checkPostMarket,
    this.checkPreMarket,
    this.dateTime,
  });

  factory CheckMarketOpenRes.fromJson(Map<String, dynamic> json) =>
      CheckMarketOpenRes(
        isHoliday: json["isHoliday"],
        startStreaming: json['startStreaming'],
        isMarketOpen: json["isMarketOpen"],
        extendedHoursType: json["ExtendedHoursType"],
        extendedHoursTime: json["ExtendedHoursTime"],
        extendedHoursDate: json["ExtendedHoursDate"],
        postMarketLiveTime: json["postMarketLiveTime"],
        postMarketStream: json['postMarketStream'],
        checkPostMarket: json["checkPostMarket"],
        checkPreMarket: json["checkPreMarket"],
        dateTime: json["dateTime"],
      );

  Map<String, dynamic> toJson() => {
        "isHoliday": isHoliday,
        'startStreaming': startStreaming,
        "isMarketOpen": isMarketOpen,
        "ExtendedHoursType": extendedHoursType,
        "ExtendedHoursTime": extendedHoursTime,
        "ExtendedHoursDate": extendedHoursDate,
        "postMarketLiveTime": postMarketLiveTime,
        'postMarketStream': postMarketStream,
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

class ScannerPortDataRes {
  final int? start;
  final int? end;

  ScannerPortDataRes({
    this.start,
    this.end,
  });

  factory ScannerPortDataRes.fromJson(Map<String, dynamic> json) =>
      ScannerPortDataRes(
        start: json["start"],
        end: json["end"],
      );

  Map<String, dynamic> toJson() => {
        "start": start,
        "end": end,
      };
}

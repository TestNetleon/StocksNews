import 'dart:convert';

ScannerPortsRes scannerPortsResFromJson(String str) =>
    ScannerPortsRes.fromJson(json.decode(str));

String scannerPortsResToJson(ScannerPortsRes data) =>
    json.encode(data.toJson());

class ScannerPortsRes {
  final PortRes? port;

  ScannerPortsRes({this.port});

  factory ScannerPortsRes.fromJson(Map<String, dynamic> json) =>
      ScannerPortsRes(
        port: json["port"] == null ? null : PortRes.fromJson(json["port"]),
      );

  Map<String, dynamic> toJson() => {
        "port": port?.toJson(),
      };
}

class PortRes {
  final int? scannerLockStatus;
  final ScannerPortRes? scannerPort;
  final GainerLoserPortRes? gainerLoserPort;
  final OtherPortRes? otherPortRes;
  final CheckMarketOpenApiRes? checkMarketOpenApi;
  final bool? showOnHome;
  final LockInfo? lockInfo;

  PortRes({
    this.scannerPort,
    this.gainerLoserPort,
    this.otherPortRes,
    this.checkMarketOpenApi,
    this.showOnHome,
    this.lockInfo,
    this.scannerLockStatus,
  });

  factory PortRes.fromJson(Map<String, dynamic> json) => PortRes(
        scannerLockStatus: json['scannerLockStatus'],
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
        showOnHome: json["show_on_home"],
        lockInfo: json["lock_info"] == null
            ? null
            : LockInfo.fromJson(json["lock_info"]),
      );

  Map<String, dynamic> toJson() => {
        'scannerLockStatus': scannerLockStatus,
        "scannerPort": scannerPort?.toJson(),
        "gainerLoserPort": gainerLoserPort?.toJson(),
        "other": otherPortRes?.toJson(),
        "checkMarketOpenApi": checkMarketOpenApi?.toJson(),
        "show_on_home": showOnHome,
        "lock_info": lockInfo?.toJson(),
      };
}

class CheckMarketOpenApiRes {
  final bool? isHoliday;
  final bool? isMarketOpen;
  final String? extendedHoursType;
  final String? extendedHoursTime;
  final String? extendedHoursDate;
  final bool? checkPostMarket;
  final bool? checkPreMarket;
  final String? dateTime;
  final bool? postMarketStream;
  // String? postMarketBannerMessage;
  String? bannerImage;
  int? screenStatus;
  int? topGainerStatus;
  int? topLoserStatus;

  CheckMarketOpenApiRes({
    this.isHoliday,
    this.isMarketOpen,
    this.extendedHoursType,
    this.extendedHoursTime,
    this.extendedHoursDate,
    this.checkPostMarket,
    this.checkPreMarket,
    this.dateTime,
    this.postMarketStream,
    // this.postMarketBannerMessage,
    this.bannerImage,
    this.screenStatus,
    this.topGainerStatus,
    this.topLoserStatus,
  });

  factory CheckMarketOpenApiRes.fromJson(Map<String, dynamic> json) =>
      CheckMarketOpenApiRes(
        isHoliday: json["isHoliday"],
        isMarketOpen: json["isMarketOpen"],
        extendedHoursType: json["ExtendedHoursType"],
        extendedHoursTime: json["ExtendedHoursTime"],
        extendedHoursDate: json["ExtendedHoursDate"],
        checkPostMarket: json["checkPostMarket"],
        checkPreMarket: json["checkPreMarket"],
        dateTime: json["dateTime"],
        screenStatus: json['screenerStatus'],
        topGainerStatus: json['topGainer'],
        topLoserStatus: json['topLoser'],
        postMarketStream: json['postMarketStream'],
        // postMarketBannerMessage: json['postMarketBannerMessage'],
        bannerImage: json['banner_image'],
      );

  Map<String, dynamic> toJson() => {
        "isHoliday": isHoliday,
        "isMarketOpen": isMarketOpen,
        "ExtendedHoursType": extendedHoursType,
        "ExtendedHoursTime": extendedHoursTime,
        "ExtendedHoursDate": extendedHoursDate,
        "checkPostMarket": checkPostMarket,
        "checkPreMarket": checkPreMarket,
        "dateTime": dateTime,
        "postMarketStream": postMarketStream,
        // 'postMarketBannerMessage': postMarketBannerMessage,
        'banner_image': bannerImage,
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

class LockInfo {
  final String? title;
  final String? subtitle;
  final String? btnText;

  LockInfo({
    this.title,
    this.subtitle,
    this.btnText,
  });

  factory LockInfo.fromJson(Map<String, dynamic> json) => LockInfo(
        title: json["title"],
        subtitle: json["subtitle"],
        btnText: json["btn_text"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "btn_text": btnText,
      };
}

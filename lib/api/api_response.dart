import 'dart:convert';

import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/modals/in_app_msg_res.dart';

ApiResponse apiResponseFromJson(String str) =>
    ApiResponse.fromJson(json.decode(str));

// String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse {
  ApiResponse({
    required this.status,
    this.message,
    this.data,
    this.session = true,
    this.totalAmount,
    this.totalCount,
    this.pagecount,
    this.extra,
  });

  final bool status;
  final bool session;
  final dynamic extra;

  final String? message;
  final dynamic data;
  final dynamic totalAmount;
  final dynamic totalCount;
  final dynamic pagecount;

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] is List
            ? List<dynamic>.from(json["data"])
            // ? List<dynamic>.from(json["data"].map((x) => dynamic.fromJson(x)))
            : json["data"],
        totalAmount: json['total_amount'],
        totalCount: json['total_count'],
        pagecount: json["page_count"],
        extra: json["extra"] is List
            ? List<dynamic>.from(json["extra"])
            // ? List<dynamic>.from(json["data"].map((x) => dynamic.fromJson(x)))
            : json["extra"] == null
                ? null
                : Extra.fromJson(json["extra"]),
      );
}

class Extra {
  final String? search;
  final int? notificationCount;
  final List<KeyValueElement>? exchangeShortName;
  final List<KeyValueElement>? priceRange;
  final List<KeyValueElement>? transactionType;
  final List<KeyValueElement>? cap;
  final List<KeyValueElement>? sector;
  final List<KeyValueElement>? txnSize;
  final TextRes? text;
  final int? userAlert;
  final InAppNotification? inAppMsg;
  final String? androidBuildVersion;
  final int? androidBuildCode;
  final String? iOSBuildVersion;
  final int? iOSBuildCode;
  final String? appUpdateTitle;
  final String? appUpdateMsg;

  Extra({
    this.search,
    this.exchangeShortName,
    this.priceRange,
    this.transactionType,
    this.cap,
    this.sector,
    this.notificationCount,
    this.text,
    this.txnSize,
    this.userAlert,
    this.inAppMsg,
    this.androidBuildVersion,
    this.androidBuildCode,
    this.iOSBuildVersion,
    this.iOSBuildCode,
    this.appUpdateTitle,
    this.appUpdateMsg,
  });

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
        search: json["search"],
        userAlert: json["user_alerts"],
        text: json["text"] == null ? null : TextRes.fromJson(json["text"]),
        exchangeShortName: json["exchange_short_name"] == null
            ? []
            : List<KeyValueElement>.from(json["exchange_short_name"]!
                .map((x) => KeyValueElement.fromJson(x))),
        priceRange: json["price_range"] == null
            ? []
            : List<KeyValueElement>.from(
                json["price_range"]!.map((x) => KeyValueElement.fromJson(x))),
        transactionType: json["txn_type"] == null
            ? []
            : List<KeyValueElement>.from(
                json["txn_type"]!.map((x) => KeyValueElement.fromJson(x))),
        cap: json["market_cap"] == null
            ? []
            : List<KeyValueElement>.from(
                json["market_cap"]!.map((x) => KeyValueElement.fromJson(x))),
        sector: json["sector"] == null
            ? []
            : List<KeyValueElement>.from(
                json["sector"]!.map((x) => KeyValueElement.fromJson(x))),
        txnSize: json["txn_size"] == null
            ? []
            : List<KeyValueElement>.from(
                json["txn_size"]!.map((x) => KeyValueElement.fromJson(x))),
        notificationCount: json["notification_count"],
        inAppMsg: json["in_app_notification"] == null
            ? null
            : InAppNotification.fromJson(json["in_app_notification"]),
        androidBuildVersion: json["android_build_version"],
        androidBuildCode: json["android_build_code"],
        iOSBuildVersion: json["ios_build_version"],
        iOSBuildCode: json["ios_build_code"],
        appUpdateTitle: json["app_update_title"],
        appUpdateMsg: json["app_update_msg"],
      );

  Map<String, dynamic> toJson() => {
        "search": search,
        "user_alerts": userAlert,
        "exchange_short_name": exchangeShortName == null
            ? []
            : List<dynamic>.from(exchangeShortName!.map((x) => x.toJson())),
        "price_range": priceRange == null
            ? []
            : List<dynamic>.from(priceRange!.map((x) => x.toJson())),
        "txn_type": transactionType == null
            ? []
            : List<dynamic>.from(transactionType!.map((x) => x.toJson())),
        "market_cap":
            cap == null ? [] : List<dynamic>.from(cap!.map((x) => x.toJson())),
        "sector": sector == null
            ? []
            : List<dynamic>.from(sector!.map((x) => x.toJson())),
        "txn_size": txnSize == null
            ? []
            : List<dynamic>.from(txnSize!.map((x) => x.toJson())),
        "notification_count": notificationCount,
        "text": text?.toJson(),
        "in_app_notification": inAppMsg?.toJson(),
        "android_build_version": androidBuildVersion,
        "android_build_code": androidBuildCode,
        "ios_build_version": iOSBuildVersion,
        "ios_build_code": iOSBuildCode,
        "app_update_title": appUpdateTitle,
        "app_update_msg": appUpdateMsg,
      };
}

class KeyValueElement {
  final String? key;
  final String? value;

  KeyValueElement({
    this.key,
    this.value,
  });

  factory KeyValueElement.fromJson(Map<String, dynamic> json) =>
      KeyValueElement(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}

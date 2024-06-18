import 'dart:convert';

import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/modals/in_app_msg_res.dart';
import 'package:stocks_news_new/modals/referral_res.dart';
import 'package:stocks_news_new/modals/user_res.dart';

import '../modals/stockDetailRes/earnings.dart';

ApiResponse apiResponseFromJson(String str) =>
    ApiResponse.fromJson(json.decode(str));

// String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse {
  ApiResponse({
    required this.status,
    this.message,
    this.data,
    this.session = true,
    this.extra,
  });

  final bool status;
  final bool session;
  final dynamic extra;

  final String? message;
  final dynamic data;

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] is List
            ? List<dynamic>.from(json["data"])
            : json["data"],
        extra: json["extra"] is List
            ? List<dynamic>.from(json["extra"])
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
  final List<SdTopRes>? period;
  final List<SdTopRes>? type;
  final TextRes? text;
  final int? userAlert;
  final InAppNotification? inAppMsg;
  final MaintenanceDialog? maintenance;
  final String? androidBuildVersion;
  final int? androidBuildCode;
  final String? iOSBuildVersion;
  final int? iOSBuildCode;
  final String? appUpdateTitle;
  final String? appUpdateMsg;
  final String? title;
  final String? subTitle;
  final int? totalPages;
  final String? apiKeyFMP;
  String? loginText, signUpText;
  final String? disclaimer;
  final String? currentBalance;
  final MessageRes? messageObject;
  final UserRes? user;
  final bool? showPortfolio;
  final ReferralRes? referral;
  final num? received;
  final num? pending;
  final String? affiliateReferText;

  Extra({
    this.search,
    this.exchangeShortName,
    this.priceRange,
    this.transactionType,
    this.period,
    this.affiliateReferText,
    this.type,
    this.received,
    this.pending,
    this.cap,
    this.sector,
    this.currentBalance,
    this.notificationCount,
    this.text,
    this.title,
    this.loginText,
    this.signUpText,
    this.showPortfolio,
    this.txnSize,
    this.totalPages,
    this.userAlert,
    this.subTitle,
    this.inAppMsg,
    this.maintenance,
    this.androidBuildVersion,
    this.androidBuildCode,
    this.iOSBuildVersion,
    this.iOSBuildCode,
    this.appUpdateTitle,
    this.appUpdateMsg,
    this.apiKeyFMP,
    this.disclaimer,
    this.messageObject,
    this.user,
    this.referral,
  });

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
        search: json["search"],
        received: json['total_points_received'],
        pending: json['total_points_pending'],
        affiliateReferText: json['heading'],
        userAlert: json["user_alerts"],
        text: json["text"] == null ? null : TextRes.fromJson(json["text"]),
        title: json["title"],
        currentBalance: json['current_balance'],
        subTitle: json["sub_title"],
        loginText: json["login_text"],
        showPortfolio: json['show_portfolio'],
        signUpText: json["signup_text"],
        totalPages: json["total_pages"],
        period: json["period"] == null
            ? []
            : List<SdTopRes>.from(
                json["period"]!.map((x) => SdTopRes.fromJson(x))),
        type: json["type"] == null
            ? []
            : List<SdTopRes>.from(
                json["type"]!.map((x) => SdTopRes.fromJson(x))),
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
        maintenance: json["maintenance"] == null
            ? null
            : MaintenanceDialog.fromJson(json["maintenance"]),
        androidBuildVersion: json["android_build_version"],
        androidBuildCode: json["android_build_code"],
        iOSBuildVersion: json["ios_build_version"],
        iOSBuildCode: json["ios_build_code"],
        appUpdateTitle: json["app_update_title"],
        appUpdateMsg: json["app_update_msg"],
        apiKeyFMP: json["api_key"],
        disclaimer: json["footer_disclaimer"],
        messageObject: json["message"] == null
            ? null
            : MessageRes.fromJson(json["message"]),
        user: json["user"] == null ? null : UserRes.fromJson(json["user"]),
        referral: json["referral"] == null
            ? null
            : ReferralRes.fromJson(json["referral"]),
      );

  Map<String, dynamic> toJson() => {
        "search": search,
        "user_alerts": userAlert,
        'total_points_received': received,
        "total_points_pending": pending,
        "heading": affiliateReferText,
        "title": title,
        "sub_title": subTitle,
        "current_balance": currentBalance,
        "show_portfolio": showPortfolio,
        "total_pages": totalPages,
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
        "maintenance": maintenance?.toJson(),
        "android_build_version": androidBuildVersion,
        "period":
            period == null ? [] : List<dynamic>.from(period!.map((x) => x)),
        "type": type == null ? [] : List<dynamic>.from(type!.map((x) => x)),
        "android_build_code": androidBuildCode,
        "login_text": loginText,
        "signup_text": signUpText,
        "ios_build_version": iOSBuildVersion,
        "ios_build_code": iOSBuildCode,
        "app_update_title": appUpdateTitle,
        "app_update_msg": appUpdateMsg,
        "api_key": apiKeyFMP,
        "footer_disclaimer": disclaimer,
        "message": messageObject?.toJson(),
        "user": user?.toJson(),
        "referral": referral?.toJson(),
      };
}

class MessageRes {
  final String? error;
  final String? loading;

  MessageRes({
    this.error,
    this.loading,
  });

  factory MessageRes.fromJson(Map<String, dynamic> json) => MessageRes(
        error: json["error"],
        loading: json["loading"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "loading": loading,
      };
}

class MaintenanceDialog {
  final String? title;
  final String? description;
  final String? image;

  MaintenanceDialog({
    this.title,
    this.description,
    this.image,
  });

  factory MaintenanceDialog.fromJson(Map<String, dynamic> json) =>
      MaintenanceDialog(
        title: json["title"],
        description: json["description"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "image": image,
      };
}

class KeyValueElement {
  final String? key;
  final String? value;
  final String? image;

  KeyValueElement({
    this.key,
    this.value,
    this.image,
  });

  factory KeyValueElement.fromJson(Map<String, dynamic> json) =>
      KeyValueElement(
        key: json["key"],
        value: json["value"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
        "image": image,
      };
}

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
  final List<String>? feebackType;
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
  final num? balance;
  final num? spent;

  final num? pending;
  final String? affiliateReferText;
  final HowItWorkRes? howItWork;
  final ReferLoginRes? referLogin;
  final String? verifyIdentity;
  final String? nudgeText;
  final String? earnCondition;
  final String? suspendMsg;
  final ProfileText? profileText;
  final int? selfRank;

  Extra({
    this.feebackType,
    this.search,
    this.selfRank,
    this.profileText,
    this.verifyIdentity,
    this.howItWork,
    this.exchangeShortName,
    this.priceRange,
    this.transactionType,
    this.referLogin,
    this.nudgeText,
    this.suspendMsg,
    this.period,
    this.affiliateReferText,
    this.type,
    this.received,
    this.balance,
    this.spent,
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
    this.earnCondition,
  });

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
        search: json["search"],
        feebackType: json["feeback_type"] == null
            ? []
            : List<String>.from(json["feeback_type"]!.map((x) => x)),
        selfRank: json["self_rank"],
        profileText: json["profile_text"] == null
            ? null
            : ProfileText.fromJson(json["profile_text"]),
        verifyIdentity: json['verify_identity_text'],
        earnCondition: json['earn_condition'],
        received: json['total_points_received'],
        balance: json['total_balance'],
        spent: json['total_spent'],
        suspendMsg: json['referral_status_message'],
        nudgeText: json["nudge_text"],
        referLogin: json["refer_login"] == null
            ? null
            : ReferLoginRes.fromJson(json["refer_login"]),
        pending: json['total_points_pending'],
        affiliateReferText: json['heading'],
        userAlert: json["user_alerts"],
        text: json["text"] == null ? null : TextRes.fromJson(json["text"]),
        title: json["title"],
        currentBalance: json['current_balance'],
        subTitle: json["sub_title"],
        loginText: json["login_text"],
        howItWork: json["how_it_work"] == null
            ? null
            : HowItWorkRes.fromJson(json["how_it_work"]),
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
        "feeback_type": feebackType == null
            ? []
            : List<dynamic>.from(feebackType!.map((x) => x)),
        "search": search,
        "user_alerts": userAlert,
        "nudge_text": nudgeText,
        "verify_identity_text": verifyIdentity,
        "self_rank": selfRank,
        "earn_condition": earnCondition,
        'total_points_received': received,
        "total_balance": balance,
        "total_spent": spent,
        "total_points_pending": pending,
        'referral_status_message': suspendMsg,
        "profile_text": profileText?.toJson(),
        "heading": affiliateReferText,
        "refer_login": referLogin?.toJson(),
        "title": title,
        "how_it_work": howItWork?.toJson(),
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

class ProfileText {
  final String? verified;
  final String? unVerified;

  final String? points;
  final String? rank;

  ProfileText({
    this.verified,
    this.unVerified,
    this.points,
    this.rank,
  });

  factory ProfileText.fromJson(Map<String, dynamic> json) => ProfileText(
        verified: json["verified"],
        unVerified: json["unverified"],
        points: json["points"],
        rank: json["rank"],
      );

  Map<String, dynamic> toJson() => {
        "verified": verified,
        "unverified": unVerified,
        "points": points,
        "rank": rank,
      };
}

class ReferLoginRes {
  final String? title;
  final String? subTitle;
  final String? note;

  ReferLoginRes({
    this.title,
    this.subTitle,
    this.note,
  });

  factory ReferLoginRes.fromJson(Map<String, dynamic> json) => ReferLoginRes(
        title: json["title"],
        subTitle: json["sub_title"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "note": note,
      };
}

class HowItWorkRes {
  final String? title;
  final List<StepRes>? steps;

  HowItWorkRes({
    this.title,
    this.steps,
  });

  factory HowItWorkRes.fromJson(Map<String, dynamic> json) => HowItWorkRes(
        title: json["title"],
        steps: json["steps"] == null
            ? []
            : List<StepRes>.from(
                json["steps"]!.map((x) => StepRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "steps": steps == null
            ? []
            : List<dynamic>.from(steps!.map((x) => x.toJson())),
      };
}

class StepRes {
  final String? key;
  final String? title;
  final String? subTitle;

  StepRes({
    this.key,
    this.title,
    this.subTitle,
  });

  factory StepRes.fromJson(Map<String, dynamic> json) => StepRes(
        key: json["key"],
        title: json["title"],
        subTitle: json["sub_title"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "title": title,
        "sub_title": subTitle,
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

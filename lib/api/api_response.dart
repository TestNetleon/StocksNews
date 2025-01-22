import 'dart:convert';

import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/modals/in_app_msg_res.dart';
import 'package:stocks_news_new/modals/referral_res.dart';
import 'package:stocks_news_new/modals/user_res.dart';

import '../modals/membership.dart';
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
        status: json["status"] ?? json["success"],
        message: json["message"],
        data: json["data"] is List
            ? List<dynamic>.from(json["data"])
            : json["data"],
        extra: json["extra"] == null
            ? null
            : json["extra"] is List
                ? List<dynamic>.from(json["extra"])
                : json["extra"] == null
                    ? null
                    : Extra.fromJson(json["extra"]),
      );
}

class Extra {
  final DateTime? reponseTime;
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
  final UserRes? tempUser;

  final bool? showPortfolio;
  final bool? showAboutStockNews;
  final bool? showWhatWeDo;
  final bool? showFAQ;
  final ReferralRes? referral;
  final num? received;
  final num? totalActivityPoints;
  final num? balance;
  final num? spent;
  // final Subscription? subscription;
  final num? pending;
  final String? affiliateReferText;
  final HowItWorkRes? howItWork;
  final HowItWorkRes? membershipText;

  final String? tagLine;
  final ReferLoginRes? referLogin;
  final RevenueCatKeyRes? revenueCatKeys;

  final String? verifyIdentity;
  final String? verifySubscription;
  final String? nudgeText;
  final String? earnCondition;
  final String? suspendMsg;
  final ProfileText? profileText;
  final int? selfRank;
  final String? referText;
  final int? affiliateInput;
  final LoginDialogRes? loginDialogRes;
  final UserMembershipRes? membership;
  final String? aiTitle;
  final bool? showMembership;
  final bool? showMorningstar;
  final String? text1;
  final String? text2;
  final String? text3;
  final String? featuredTitle;
  final String? watchlistTitle;
  final bool? showFeatured;
  final bool? showWatchlist;
  final bool? showMostPurchased;
  final String? storeTitle;
  final String? storeSubTitle;
  final bool? isOldApp;
  final bool? notificationSetting;
  final List<PointsSummaryRes>? pointsSummary;
  final AdManagerRes? adManager;
  final AdManagersRes? adManagers;
  final String? notifyTextMsg;
  String? phoneCodeError;
  String? phoneError;
  final String? recommendation;
  final bool? showRewards;
  final bool? showAnalysis;
  final UpdateYourPhoneRes? updateYourPhone;
  final UpdateYourPhoneRes? updateYourEmail;
  final bool? executable;

  final bool? showArena;
  final bool? showTradingSimulator;
  final bool? showBlackFriday;
  final bool? christmasMembership;
  final bool? newYearMembership;
  final bool? showStockScanner;
  final bool? showStockScannerApp;

  final BlackFridayRes? blackFriday;
  final List<MembershipRes>? activeMembership;

  // final num? isRegistered;

  Extra({
    this.showStockScanner,
    this.showStockScannerApp,
    this.executable,
    this.reponseTime,
    this.activeMembership,
    this.blackFriday,
    this.showBlackFriday,
    this.christmasMembership,
    this.newYearMembership,
    this.showArena,
    this.showTradingSimulator,
    this.updateYourPhone,
    this.updateYourEmail,
    this.showRewards,
    this.adManagers,
    this.adManager,
    this.recommendation,
    this.storeTitle,
    this.storeSubTitle,
    this.showFeatured,
    this.tagLine,
    this.showWatchlist,
    this.notifyTextMsg,
    this.showMostPurchased,
    this.phoneCodeError,
    this.phoneError,
    this.showAnalysis,
    this.text1,
    this.text2,
    this.text3,
    this.pointsSummary,
    this.feebackType,
    this.showMorningstar,
    this.search,
    this.selfRank,
    this.profileText,
    this.verifyIdentity,
    this.verifySubscription,
    this.howItWork,
    this.membershipText,
    this.aiTitle,
    this.showMembership,
    // this.subscription,
    this.exchangeShortName,
    this.priceRange,
    this.transactionType,
    this.referLogin,
    this.revenueCatKeys,
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
    this.showAboutStockNews,
    this.showWhatWeDo,
    this.showFAQ,
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
    this.tempUser,
    this.referral,
    this.earnCondition,
    this.referText,
    this.affiliateInput,
    this.loginDialogRes,
    this.totalActivityPoints,
    this.membership,
    this.featuredTitle,
    this.watchlistTitle,
    this.isOldApp,
    this.notificationSetting,
    // this.isRegistered,
  });

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
        search: json["search"],
        showStockScanner: json['show_stock_scanner'],
        showStockScannerApp: json['show_stock_scanner_app'],
        executable: json['is_trade_executable'],

        activeMembership: json["active_membership"] == null
            ? []
            : List<MembershipRes>.from(json["active_membership"]!
                .map((x) => MembershipRes.fromJson(x))),

        showBlackFriday: json['black_friday_membership'],
        christmasMembership: json['christmas_membership'],
        newYearMembership: json['new_year_membership'],

        blackFriday: json["black_friday"] == null
            ? null
            : BlackFridayRes.fromJson(json["black_friday"]),
        showArena: json['show_arena'],
        showTradingSimulator: json['show_trading_simulator'],
        // isRegistered: json['is_registered'],
        updateYourPhone: json["update_your_phone_no"] == null
            ? null
            : UpdateYourPhoneRes.fromJson(json["update_your_phone_no"]),

        updateYourEmail: json["update_your_email_address"] == null
            ? null
            : UpdateYourPhoneRes.fromJson(json["update_your_email_address"]),

        recommendation: json["recommendation"],
        reponseTime: json["reponse_time"] == null
            ? null
            : DateTime.parse(json["reponse_time"]),
        showRewards: json['show_rewards'],
        showAnalysis: json['show_analysis'],
        storeTitle: json["store_title"],
        notifyTextMsg: json['notification_setting_txt'],
        storeSubTitle: json["store_subtitle"],
        phoneCodeError: json['phone_code_error'],
        phoneError: json['phone_error'],

        adManager: json["ad_manager"] == null
            ? null
            : AdManagerRes.fromJson(json["ad_manager"]),
        adManagers: json["ad_managers"] == null
            ? null
            : AdManagersRes.fromJson(json["ad_managers"]),
        tagLine: json['tag_line'],
        showFeatured: json['show_featured'],
        showWatchlist: json['show_watchlist'],
        showMostPurchased: json['show_most_purchased'],
        text1: json["text1"],
        pointsSummary: json["points_summary"] == null
            ? []
            : List<PointsSummaryRes>.from(json["points_summary"]!
                .map((x) => PointsSummaryRes.fromJson(x))),

        text2: json["text2"],
        text3: json["text3"],
        featuredTitle: json["featured_title"],
        watchlistTitle: json["watchlist_title"],

        showMembership: json["show_membership"],
        feebackType: json["feeback_type"] == null
            ? []
            : List<String>.from(json["feeback_type"]!.map((x) => x)),
        selfRank: json["self_rank"],
        profileText: json["profile_text"] == null
            ? null
            : ProfileText.fromJson(json["profile_text"]),
        verifyIdentity: json['verify_identity_text'],
        showMorningstar: json['show_morningstar'],
        verifySubscription: json['verify_membership_text'],

        aiTitle: json['ai-news-title'],
        // subscription: json["subscription"] == null
        //     ? null
        //     : Subscription.fromJson(json["subscription"]),
        earnCondition: json['earn_condition'],
        received: json['total_points_received'],
        balance: json['total_balance'],
        spent: json['total_spent'],
        suspendMsg: json['referral_status_message'],
        nudgeText: json["nudge_text"],
        referLogin: json["refer_login"] == null
            ? null
            : ReferLoginRes.fromJson(json["refer_login"]),

        revenueCatKeys: json["revenuecat_key"] == null
            ? null
            : RevenueCatKeyRes.fromJson(json["revenuecat_key"]),

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
        membershipText: json["membership_text"] == null
            ? null
            : HowItWorkRes.fromJson(json["membership_text"]),

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
        tempUser: json["temp_user"] == null
            ? null
            : UserRes.fromJson(json["temp_user"]),

        referral: json["referral"] == null
            ? null
            : ReferralRes.fromJson(json["referral"]),
        referText: json["refer_text"],
        affiliateInput: json["affiliate_input"],
        loginDialogRes: json["login_dialog"] == null
            ? null
            : LoginDialogRes.fromJson(json["login_dialog"]),
        totalActivityPoints: json["total_activity_points"],
        membership: json["membership"] == null
            ? null
            : UserMembershipRes.fromJson(json["membership"]),
        showAboutStockNews: json['show_about_stocks_news'],
        showWhatWeDo: json['show_what_we_do'],
        showFAQ: json['show_faq'],
        isOldApp: json['old_app'],
        notificationSetting: json['show_notification_setting'],
      );

  Map<String, dynamic> toJson() => {
        'showStockScanner': showStockScanner,
        'show_stock_scanner_app': showStockScannerApp,
        'is_trade_executable': executable,
        'black_friday_membership': showBlackFriday,
        'christmas_membership': christmasMembership,
        'new_year_membership': newYearMembership,
        "black_friday": blackFriday?.toJson(),
        "ad_managers": adManagers?.toJson(),
        "phone_code_error": phoneCodeError,
        'show_trading_simulator': showTradingSimulator,
        'show_arena': showArena,
        "reponse_time": reponseTime,
        "phone_error": phoneError,
        // "is_registered": isRegistered,
        'show_analysis': showAnalysis,
        "show_rewards": showRewards,
        "feeback_type": feebackType == null
            ? []
            : List<dynamic>.from(feebackType!.map((x) => x)),
        "search": search,
        "store_subtitle": storeSubTitle,
        "store_title": storeTitle,
        "show_featured": showFeatured,
        "show_watchlist": showWatchlist,
        "show_most_purchased": showMostPurchased,
        "user_alerts": userAlert,
        "nudge_text": nudgeText,
        "show_membership": showMembership,
        "verify_identity_text": verifyIdentity,
        "show_morningstar": showMorningstar,
        "recommendation": recommendation,
        "update_your_phone_no": updateYourPhone?.toJson(),
        "update_your_email_address": updateYourEmail?.toJson(),
        "verify_membership_text": verifySubscription,
        "self_rank": selfRank,
        "earn_condition": earnCondition,
        'total_points_received': received,
        "total_balance": balance,
        "notification_setting_txt": notifyTextMsg,
        "total_spent": spent,
        "ad_manager": adManager?.toJson(),
        "text1": text1,
        "tag_line": tagLine,
        "text2": text2,
        "text3": text3,
        // "subscription": subscription?.toJson(),
        "total_points_pending": pending,
        'referral_status_message': suspendMsg,
        "profile_text": profileText?.toJson(),
        "heading": affiliateReferText,
        "refer_login": referLogin?.toJson(),
        "revenuecat_key": revenueCatKeys?.toJson(),
        "title": title,
        "how_it_work": howItWork?.toJson(),
        "membership_text": membership?.toJson(),
        "sub_title": subTitle,
        "ai-news-title": aiTitle,
        "current_balance": currentBalance,
        "show_portfolio": showPortfolio,
        "total_pages": totalPages,
        "active_membership": activeMembership == null
            ? []
            : List<dynamic>.from(activeMembership!.map((x) => x.toJson())),
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
        "points_summary": pointsSummary == null
            ? []
            : List<dynamic>.from(pointsSummary!.map((x) => x.toJson())),

        "ios_build_code": iOSBuildCode,
        "app_update_title": appUpdateTitle,
        "app_update_msg": appUpdateMsg,
        "api_key": apiKeyFMP,
        "footer_disclaimer": disclaimer,
        "message": messageObject?.toJson(),
        "user": user?.toJson(),
        "temp_user": tempUser?.toJson(),

        "referral": referral?.toJson(),
        "refer_text": referText,
        "affiliate_input": affiliateInput,
        "login_dialog": loginDialogRes?.toJson(),
        "total_activity_points": totalActivityPoints,
        "membership": membership?.toJson(),
        "show_about_stocks_news": showAboutStockNews,
        "show_what_we_do": showWhatWeDo,
        "show_faq": showFAQ,
        "old_app": isOldApp,
        "show_notification_setting": notificationSetting,
      };
}

class UpdateYourPhoneRes {
  final String? title;
  final String? text;
  final String? verifyButton;
  final String? updateButton;
  final String? agreeText;

  UpdateYourPhoneRes({
    this.title,
    this.text,
    this.verifyButton,
    this.updateButton,
    this.agreeText,
  });

  factory UpdateYourPhoneRes.fromJson(Map<String, dynamic> json) =>
      UpdateYourPhoneRes(
        title: json["title"],
        text: json["text"],
        updateButton: json['update_btn_text'],
        verifyButton: json['verify_btn_text'],
        agreeText: json['agree_text'],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "text": text,
        'update_btn_text': updateButton,
        'verify_btn_text': verifyButton,
        'agree_text': agreeText,
      };
}

class AdManagersRes {
  final ManagersScreenRes? data;
  final PopupAdRes? popUp;

  AdManagersRes({
    this.data,
    this.popUp,
  });

  factory AdManagersRes.fromJson(Map<String, dynamic> json) => AdManagersRes(
        data: json["data"] == null
            ? null
            : ManagersScreenRes.fromJson(json["data"]),
        popUp:
            json["popup"] == null ? null : PopupAdRes.fromJson(json["popup"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "popup": popUp?.toJson(),
      };
}

class ManagersScreenRes {
  final PopupAdRes? place1;
  final PopupAdRes? place2;
  final PopupAdRes? place3;
  final PopupAdRes? newsPlace1;
  final PopupAdRes? newsPlace2;
  final PopupAdRes? newsPlace3;

  ManagersScreenRes({
    this.place1,
    this.place2,
    this.place3,
    this.newsPlace1,
    this.newsPlace2,
    this.newsPlace3,
  });

  factory ManagersScreenRes.fromJson(Map<String, dynamic> json) =>
      ManagersScreenRes(
        place1: json["home-place-1"] == null
            ? null
            : PopupAdRes.fromJson(json["home-place-1"]),
        place2: json["home-place-2"] == null
            ? null
            : PopupAdRes.fromJson(json["home-place-2"]),
        place3: json["home-place-3"] == null
            ? null
            : PopupAdRes.fromJson(json["home-place-3"]),
        newsPlace1: json["news-place-1"] == null
            ? null
            : PopupAdRes.fromJson(json["news-place-1"]),
        newsPlace2: json["news-place-2"] == null
            ? null
            : PopupAdRes.fromJson(json["news-place-2"]),
        newsPlace3: json["news-place-3"] == null
            ? null
            : PopupAdRes.fromJson(json["news-place-3"]),
      );

  Map<String, dynamic> toJson() => {
        "home-place-1": place1?.toJson(),
        "home-place-2": place2?.toJson(),
        "home-place-3": place3?.toJson(),
        "news-place-1": newsPlace1?.toJson(),
        "news-place-2": newsPlace2?.toJson(),
        "news-place-3": newsPlace3?.toJson(),
      };
}

class PopupAdRes {
  final String? id;
  final String? title;
  final String? image;
  final String? url;
  final String? adText;

  PopupAdRes({
    this.id,
    this.title,
    this.image,
    this.url,
    this.adText,
  });

  factory PopupAdRes.fromJson(Map<String, dynamic> json) => PopupAdRes(
        id: json["_id"],
        title: json["title"],
        image: json["image"],
        url: json["url"],
        adText: json["ad_text"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "image": image,
        "url": url,
        "ad_text": adText,
      };
}

class AdManagerRes {
  final String? adText;
  final String? bannerImage, popUpImage;
  final String? url;
  final String? adId;
  final dynamic showOnHome;

  AdManagerRes({
    this.adText,
    this.bannerImage,
    this.popUpImage,
    this.url,
    this.adId,
    this.showOnHome,
  });

  factory AdManagerRes.fromJson(Map<String, dynamic> json) => AdManagerRes(
        adText: json["ad_text"],
        bannerImage: json["banner_image"],
        popUpImage: json["popup_image"],
        url: json["url"],
        adId: json['_id'],
        showOnHome: json['show_on_home'],
      );

  Map<String, dynamic> toJson() => {
        "ad_text": adText,
        "banner_image": bannerImage,
        "popup_image": popUpImage,
        "url": url,
        "_id": adId,
        "show_on_home": showOnHome,
      };
}

class PointsSummaryRes {
  final String? key;
  final String? icon;
  final String? text;
  final String? txnType;

  final int? value;

  PointsSummaryRes({
    this.key,
    this.icon,
    this.text,
    this.txnType,
    this.value,
  });

  factory PointsSummaryRes.fromJson(Map<String, dynamic> json) =>
      PointsSummaryRes(
        key: json["key"],
        icon: json["icon"],
        text: json["text"],
        txnType: json["txn_type"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "icon": icon,
        "txn_type": txnType,
        "text": text,
        "value": value,
      };
}

class MembershipCardRes {
  final String? text1;
  final String? text2;
  final String? text3;
  final String? button;

  MembershipCardRes({
    this.text1,
    this.text2,
    this.text3,
    this.button,
  });

  factory MembershipCardRes.fromJson(Map<String, dynamic> json) =>
      MembershipCardRes(
        text1: json["text1"],
        text2: json["text2"],
        text3: json["text3"],
        button: json["button"],
      );

  Map<String, dynamic> toJson() => {
        "text1": text1,
        "text2": text2,
        "text3": text3,
        "button": button,
      };
}

// class Subscription {
//   final int? purchased;
//   final List<String>? permissions;

//   Subscription({
//     this.purchased,
//     this.permissions,
//   });

//   factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
//         purchased: json["purchased"],
//         permissions: json["permissions"] == null
//             ? []
//             : List<String>.from(json["permissions"]!.map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "purchased": purchased,
//         "permissions": permissions == null
//             ? []
//             : List<dynamic>.from(permissions!.map((x) => x)),
//       };
// }

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

class RevenueCatKeyRes {
  final String? appStore;
  final String? playStore;

  RevenueCatKeyRes({
    this.appStore,
    this.playStore,
  });

  factory RevenueCatKeyRes.fromJson(Map<String, dynamic> json) =>
      RevenueCatKeyRes(
        appStore: json["app_store"],
        playStore: json["play_store"],
      );

  Map<String, dynamic> toJson() => {
        "app_store": appStore,
        "play_store": playStore,
      };
}

class HowItWorkRes {
  final String? title;
  final String? subTitle;
  final MembershipCardRes? card;
  final MembershipCardRes? storeCard;
  final List<StepRes>? steps;

  HowItWorkRes({
    this.title,
    this.subTitle,
    this.steps,
    this.card,
    this.storeCard,
  });

  factory HowItWorkRes.fromJson(Map<String, dynamic> json) => HowItWorkRes(
        title: json["title"],
        subTitle: json["sub_title"],
        card: json["card"] == null
            ? null
            : MembershipCardRes.fromJson(json["card"]),
        storeCard: json["store_card"] == null
            ? null
            : MembershipCardRes.fromJson(json["store_card"]),
        steps: json["steps"] == null
            ? []
            : List<StepRes>.from(
                json["steps"]!.map((x) => StepRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "card": card?.toJson(),
        "store_card": storeCard?.toJson(),
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

class LoginDialogRes {
  final int count;
  final int status;

  LoginDialogRes({
    required this.count,
    required this.status,
  });

  factory LoginDialogRes.fromJson(Map<String, dynamic> json) => LoginDialogRes(
        count: json["count"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "status": status,
      };
}

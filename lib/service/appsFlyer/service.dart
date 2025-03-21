import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:validators/validators.dart';
import '../../api/apis.dart';
import '../../utils/constants.dart';

class AppsFlyerService {
  AppsFlyerService._internal();

  static final AppsFlyerService _instance = AppsFlyerService._internal();

  static AppsFlyerService get instance => _instance;

  AppsflyerSdk? _appsFlyerSdk;

  // Future<void> getDeviceID() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isAndroid) {
  //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //     String deviceId = androidInfo.id;
  //     print("Android Device ID: $deviceId");
  //   } else if (Platform.isIOS) {
  //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //     String? deviceId = iosInfo.identifierForVendor;
  //     print("iOS Device ID: $deviceId");
  //   }
  // }

  Future<void> initializeSdk() async {
    try {
      final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: ApiKeys.appsFlyerKey,
        appId: Platform.isIOS ? ApiKeys.iosAppID : '',
        showDebug: true,
        timeToWaitForATTUserAuthorization: 30,
        disableCollectASA: false,
        disableAdvertisingIdentifier: false,
      );

      _appsFlyerSdk = AppsflyerSdk(options);
      _appsFlyerSdk?.enableTCFDataCollection(true);

      await _appsFlyerSdk?.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true,
      );

      final appsFlyerId = await _appsFlyerSdk?.getAppsFlyerUID();

      Utils().showLog("UID => $appsFlyerId");

      appsFlyerUID = appsFlyerId;

      try {
        _appsFlyerSdk?.setOneLinkCustomDomain(['pagelink.stocks.news']);
      } catch (e) {
        //
      }

      if (appsFlyerId != null) {
        try {
          _appsFlyerSdk?.setCustomerUserId(appsFlyerId);
        } catch (e) {
          //
        }

        // await Purchases.setAppsflyerID(appsFlyerId);
        appsFlyerUID = appsFlyerId;
      }

      handleDeepLinking();
      Utils().showLog("AppsFlyer ID: $appsFlyerId");

      Timer(const Duration(seconds: 5), () {
        // createUserInvitationLink();
      });
    } catch (e) {
      Utils().showLog("failed: $e");
      handleDeepLinking();
    }
  }

  appsFlyerLogEvent(
    String eventName, {
    Map<String, dynamic>? eventProperties,
    String? userId,
  }) {
    try {
      if (userId != null && userId != '') {
        _appsFlyerSdk?.setCustomerUserId(userId);
      }
      _appsFlyerSdk?.logEvent(
        eventName,
        eventProperties,
      );
      Utils().showLog('Logging event:Apps Flyer $eventName');
    } catch (e) {
      Utils().showLog('Error while logEvent $e');
    }
  }

  handleDeepLinking() {
    _appsFlyerSdk?.onDeepLinking(
      (result) {
        String? deepLinkUrl;
        if (result.deepLink?.clickEvent != null) {
          final clickEventMap = result.deepLink?.clickEvent;
          deepLinkUrl = clickEventMap?['link'];
        }

        Utils().showLog('Deep Link URL: ${deepLinkUrl ?? "No link found"}');

        Map data = {
          'afSub1': result.deepLink?.afSub1 ?? 'N/A',
          'afSub2': result.deepLink?.afSub2 ?? 'N/A',
          'afSub3': result.deepLink?.afSub3 ?? 'N/A',
          'afSub4': result.deepLink?.afSub4 ?? 'N/A',
          'afSub5': result.deepLink?.afSub5 ?? 'N/A',
          'campaign': result.deepLink?.campaign ?? 'N/A',
          'campaignId': result.deepLink?.campaignId ?? 'N/A',
          'clickEvent': '${result.deepLink?.clickEvent.entries}',
          'clickHttpReferrer': '${result.deepLink?.clickHttpReferrer}',
          'deepLinkValue': '${result.deepLink?.deepLinkValue}',
          'isDeferred': '${result.deepLink?.isDeferred}',
          'matchType': '${result.deepLink?.matchType}',
          'mediaSource': '${result.deepLink?.mediaSource}',
        };
        Utils().showLog('AppsFlyer Deep Link Data ${jsonEncode(data)}');

        debugPrint(
          "C = ${result.deepLink?.campaign}\nMT = ${result.deepLink?.matchType}\nCode = ${result.deepLink?.deepLinkValue}\nLink = $deepLinkUrl",
        );

        if (result.deepLink?.campaign == "Referral" ||
            result.deepLink?.matchType == "referrer") {
          getReferralCodeIfAny(result.deepLink?.deepLinkValue);
        } else if (deepLinkUrl != null && deepLinkUrl != '') {
          if (result.deepLink?.campaign == "Referral" ||
              result.deepLink?.matchType == "referrer") {
            getReferralCodeIfAny(result.deepLink?.deepLinkValue);
            return;
          }
          getDistributorCodeIfAny(deepLinkUrl);
          handleDeepLinkNavigation(uri: Uri.tryParse(deepLinkUrl));
        }
      },
    );
  }

  getDistributorCodeIfAny(url) {
    Uri? uri = Uri.tryParse(url);
    if (uri != null && uri.queryParameters.containsKey('distributor_code')) {
      String fullQuery = uri.query;
      int index = fullQuery.indexOf('distributor_code=');
      if (index != -1) {
        String result = fullQuery.substring(index + 'distributor_code='.length);
        memCODE = result;
        Utils().showLog(memCODE);
      }
    }
  }

  getReferralCodeIfAny(referralCode) async {
    bool isFirstOpen = await Preference.isFirstOpen();
    String? code = await Preference.getReferral();
    if (referralCode != null &&
        referralCode != "" &&
        code == null &&
        isFirstOpen) {
      Preference.saveReferral(referralCode);
      Timer(const Duration(seconds: 4), () {
        UserManager manager = navigatorKey.currentContext!.read<UserManager>();
        if (manager.user == null && !signUpVisible) {
          manager.askLoginScreen();
        }
      });
      FirebaseAnalytics.instance.logEvent(
        name: 'referrals',
        parameters: {'referral_code': referralCode},
      );
    }
    onDeepLinking = false;
  }

  Future createUserInvitationLink() async {
    UserManager manager = navigatorKey.currentContext!.read<UserManager>();

    if (manager.user == null) {
      return;
    }

    AppsFlyerInviteLinkParams params = AppsFlyerInviteLinkParams(
      brandDomain: 'pagelink.stocks.news',
      referrerName: 'User Invitation',
      campaign: 'Referral',
      customerID: manager.user?.userId ?? '',
      channel: "referral",
      customParams: {
        "deep_link_value": manager.user?.referralCode,
        "type": 'referral',
      },
    );

    await _appsFlyerSdk?.setAppInviteOneLinkID("Zsdh", (dynamic) {
      if (kDebugMode) {
        print('generateInviteLink SUCCESS $dynamic');
      }
    });

    _appsFlyerSdk?.generateInviteLink(params, (data) {
      if (kDebugMode) {
        print('generateInviteLink SUCCESS $data');
        try {
          final inviteLink = data["payload"]["userInviteURL"];
          if (isURL(inviteLink)) {
            print(' *** THIS IS A VALID URL *** ');
            manager.updatePersonalDetails(
              referralUrl: inviteLink,
              showProgress: false,
              showSuccess: false,
            );
          }
        } catch (e) {
          Utils().showLog(data);
        }
      }
    }, (data) {
      if (kDebugMode) {
        print('generateInviteLink ERROR $data');
      }
    });
  }
}

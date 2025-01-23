import 'dart:io';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/utils.dart';
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
      Utils().showLog("AppsFlyer ID: $appsFlyerId");
    } catch (e) {
      Utils().showLog("failed: $e");
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

        Utils().showLog('AppsFlyer Deep Link Data $data');
        if (deepLinkUrl != null && deepLinkUrl != '') {
          handleDeepLinkNavigation(uri: Uri.tryParse(deepLinkUrl));
        }
      },
    );
  }

  Future createUserInvitationLink() async {
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    AppsFlyerInviteLinkParams params = AppsFlyerInviteLinkParams(
      brandDomain: 'app.stocks.news',
      referrerName: 'User Invitation',
      baseDeepLink: 'gk0r',
      campaign: 'TestOne',
      customerID: provider.user?.userId ?? 'UserA',
    );

    _appsFlyerSdk?.generateInviteLink(params, (data) {
      if (kDebugMode) {
        print('generateInviteLink SUCCESS $data');
      }
    }, (data) {
      if (kDebugMode) {
        print('generateInviteLink ERROR $data');
      }
    });
  }
}

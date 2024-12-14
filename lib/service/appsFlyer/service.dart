import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class AppsFlyerService {
  final AppsflyerSdk _appsFlyerSdk;

  AppsFlyerService(String devKey, String appId)
      : _appsFlyerSdk = AppsflyerSdk(
          AppsFlyerOptions(
            afDevKey: devKey,
            appId: Platform.isIOS ? appId : '',
          ),
        ) {
    initializeSdk();
  }

  Future<void> initializeSdk() async {
    try {
      await _appsFlyerSdk.initSdk();
      final appsFlyerId = await _appsFlyerSdk.getAppsFlyerUID();
      if (appsFlyerId != null) {
        await Purchases.setAppsflyerID(appsFlyerId);
        setupAppsFlyerListener();
      } else {
        Utils().showLog("Failed to retrieve AppsFlyer ID.");
      }

      Utils().showLog(
          "AppsFlyer SDK initialized successfully. AppsFlyer ID: $appsFlyerId");
    } catch (e) {
      Utils().showLog("AppsFlyer SDK initialization failed: $e");
    }
  }

  void setupAppsFlyerListener() {
    try {
      _appsFlyerSdk.onInstallConversionData((data) {
        if (data != null) {
          String mediaSource = data['media_source'] ?? 'unknown_source';
          String campaignName = data['campaign'] ?? 'default_campaign';
          String adGroupName = data['adgroup'] ?? 'default_group';

          Utils().showLog(
              "Received Install Conversion Data: Media Source: $mediaSource, Campaign: $campaignName, Ad Group: $adGroupName");

          sendAttributionToRevenueCat(mediaSource, campaignName, adGroupName);
        } else {
          Utils().showLog('No conversion data found.');
        }
      });
    } catch (e) {
      Utils().showLog('Failed to set up AppsFlyer listener: $e');
    }
  }

  void sendAttributionToRevenueCat(
      String mediaSource, String campaignName, String adGroupName) {
    try {
      // Set additional data for AppsFlyer
      _appsFlyerSdk.setAdditionalData({
        "media_source": mediaSource,
        "campaign": campaignName,
        "adgroup": adGroupName,
      });

      // Set attributes for RevenueCat

      Purchases.setAttributes({
        "media_source": mediaSource,
        "campaign": campaignName,
        "adgroup": adGroupName,
      });

      Utils().showLog("Attribution data sent to RevenueCat successfully.");
    } catch (e) {
      Utils().showLog('Failed to send attribution data to RevenueCat: $e');
    }
  }

  void appsFlyerLogEvent(
    String eventName, {
    Map<String, dynamic>? eventProperties,
    String? userId,
  }) {
    try {
      if (eventProperties != null) {
        // Utils().showLog('Event properties:Apps Flyer  $eventProperties');
      }

      if (userId != null && userId != '') {
        _appsFlyerSdk.setCustomerUserId(userId);
      }
      _appsFlyerSdk.logEvent(
        eventName,
        eventProperties,
      );
      Utils().showLog('Logging event:Apps Flyer $eventName');
    } catch (e) {
      Utils().showLog('Error while logEvent $e');
    }
  }

  void appsflyerDeepLink() {
    try {
      Utils().showLog('Trying to listen appsflyer deeplink...');
      _appsFlyerSdk.onDeepLinking(
        (result) {
          Utils().showLog('deepLink ->> ${result.deepLink}');
          Utils().showLog('status ->> ${result.status}');
          Utils().showLog('error ->> ${result.error}');
        },
      );
    } catch (e) {
      Utils().showLog('deep link error ->> $e');
    }
  }
}

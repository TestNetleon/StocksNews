import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class AppsFlyerService {
  final AppsflyerSdk _appsFlyerSdk;

  AppsFlyerService(String devKey, String appId)
      : _appsFlyerSdk = AppsflyerSdk(
          AppsFlyerOptions(
            afDevKey: devKey,
            appId: appId,
          ),
        ) {
    initializeSdk();
  }

  Future<void> initializeSdk() async {
    await _appsFlyerSdk.initSdk();
    final appsFlyerId = await _appsFlyerSdk.getAppsFlyerUID();
    if (appsFlyerId != null) {
      Purchases.setAppsflyerID(appsFlyerId);
      await Purchases.setAppsflyerID(appsFlyerId);
    }

    Utils().showLog(
        "AppsFlyer SDK initialized successfully. with AppsFlyer ID $appsFlyerId");
  }

  Future<void> logInitialPurchase(
      double revenue, CustomerInfo customerInfo) async {
    final eventParams = {
      "af_revenue": revenue.toString(),
      "af_currency": "USD",
      "af_content_id": "premium_subscription",
      // "af_user_id": customerInfo.userId,
      // "af_email": customerInfo.email,
    };
    Utils().showLog("Logging Initial Purchase: $eventParams");
    await _appsFlyerSdk.logEvent("af_initial_purchase", eventParams);
  }

  Future<void> logRenewal(double revenue, CustomerInfo customerInfo) async {
    Utils().showLog('~~~~${customerInfo.activeSubscriptions.length}');
    Utils().showLog('~~~~${customerInfo.entitlements.active}');
    final eventParams = {
      "af_revenue": revenue.toString(),
      "af_currency": "USD",
      "af_content_id": "premium_subscription",
      // "af_user_id": customerInfo.userId,
      // "af_email": customerInfo.email,
    };
    Utils().showLog("Logging Renewal: $eventParams");
    await _appsFlyerSdk.logEvent("af_renewal", eventParams);
  }

  Future<void> logCancellation(CustomerInfo customerInfo) async {
    final eventParams = {
      "af_currency": "USD",
      "af_content_id": "premium_subscription",
      // "af_user_id": customerInfo.userId,
      // "af_email": customerInfo.email,
    };
    Utils().showLog("Logging Cancellation: $eventParams");
    await _appsFlyerSdk.logEvent("af_cancellation", eventParams);
  }

  Future<void> logTrialStarted(CustomerInfo customerInfo) async {
    final eventParams = {
      "af_content_id": "premium_subscription",
      // "af_user_id": customerInfo.userId,
      // "af_email": customerInfo.email,
    };
    Utils().showLog("Logging Trial Started: $eventParams");
    await _appsFlyerSdk.logEvent("af_trial_started", eventParams);
  }

  Future<void> logTrialConverted(
      double revenue, CustomerInfo customerInfo) async {
    // if (!_isInitialized) {
    //   Utils().showLog("AppsFlyer SDK is not initialized. Event not logged.");
    //   return;
    // }

    final eventParams = {
      "af_revenue": '$revenue',
      "af_currency": "USD",
      "af_content_id": "premium_subscription",
      // "af_user_id": customerInfo.userId,
      // "af_email": customerInfo.email,
    };
    Utils().showLog("Logging Trial Converted: $eventParams");
    await _appsFlyerSdk.logEvent("af_trial_converted", eventParams);
  }

  Future<void> logTrialCancelled(CustomerInfo customerInfo) async {
    final eventParams = {
      "af_currency": "USD",
      "af_content_id": "premium_subscription",
      // "af_user_id": customerInfo.userId,
      // "af_email": customerInfo.email,
    };
    Utils().showLog("Logging Trial Cancelled: $eventParams");
    await _appsFlyerSdk.logEvent("af_trial_cancelled", eventParams);
  }
}

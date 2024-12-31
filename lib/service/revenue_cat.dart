import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/membership.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import '../api/apis.dart';
import '../utils/utils.dart';
import 'appsFlyer/service.dart';
import 'success.dart';

class RevenueCatService {
  static bool _adServicesAttributionEnabled = false;

  static Future initializeSubscription({
    String? type,
    bool fromMembership = true,
  }) async {
    Utils().showLog("---TYPE $type");

    Purchases.setLogLevel(LogLevel.debug);
    RevenueCatKeyRes? keys =
        navigatorKey.currentContext!.read<HomeProvider>().extra?.revenueCatKeys;
    UserRes? userRes = navigatorKey.currentContext?.read<UserProvider>().user;
    Utils().showLog("${userRes?.userId}");

    PurchasesConfiguration? configuration;
    if (Platform.isAndroid) {
      configuration =
          PurchasesConfiguration(keys?.playStore ?? ApiKeys.androidKey)
            ..appUserID = userRes?.userId ?? "";
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(keys?.appStore ?? ApiKeys.iosKey)
        ..appUserID = userRes?.userId ?? "";
    }

    try {
      navigatorKey.currentContext!
          .read<MembershipProvider>()
          .getMembershipSuccess(isMembership: fromMembership);
      showGlobalProgressDialog();
      if (configuration != null) {
        await Purchases.configure(configuration);
        FirebaseAnalytics analytics = FirebaseAnalytics.instance;
        String? firebaseAppInstanceId = await analytics.appInstanceId;
        if (firebaseAppInstanceId != null && firebaseAppInstanceId != '') {
          Purchases.setFirebaseAppInstanceId(firebaseAppInstanceId);
          Utils().showLog('Set app instance ID => $firebaseAppInstanceId');
        }

        await configureAppsFlyer();
        if (Platform.isIOS && !_adServicesAttributionEnabled) {
          await Purchases.enableAdServicesAttributionTokenCollection();

          _adServicesAttributionEnabled = true;
          Utils().showLog("Ad Services Attribution Enabled");
        }

        Offerings? offerings;
        offerings = await Purchases.getOfferings();
        closeGlobalProgressDialog();
        PaywallResult result = await RevenueCatUI.presentPaywall(
          offering: offerings.getOffering(type ?? 'monthly-premium'),
        );

        await _handlePaywallResult(result, isMembership: fromMembership);
      } else {
        closeGlobalProgressDialog();
      }
    } catch (e) {
      closeGlobalProgressDialog();

      Utils().showLog("Error $e");
    }
  }

  // static Future<void> grantPromotionalEntitlement() async {
  //   UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;
  //   final url = Uri.parse(
  //       'https://api.revenuecat.com/v1/subscribers/${user?.userId}/entitlements/AnnualFreeTrial/promotional');
  //   final headers = {
  //     'Authorization': 'Bearer sk_ALAAqntYwixSbHIiCiPXrMXDFSzty',
  //     'Content-Type': 'application/json',
  //   };
  //   final int expirationTimeMs =
  //       DateTime.now().add(Duration(minutes: 120)).millisecondsSinceEpoch;
  //   Utils().showLog('Expiration time (ms): $expirationTimeMs');
  //   final body = jsonEncode({
  //     "end_time_ms": expirationTimeMs,
  //   });
  //   try {
  //     final response = await http.post(url, headers: headers, body: body);
  //     Utils().showLog('Status code: ${response.statusCode}');
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       Utils().showLog('Promotional entitlement granted successfully!');
  //       Utils().showLog('grant entitlement: ${response.body}');
  //     } else {
  //       Utils().showLog('not grant entitlement');
  //     }
  //   } catch (e) {
  //     Utils().showLog('Error granting promotional entitlement: $e');
  //   }
  // }

  static configureAppsFlyer() async {
    try {
      // AppsFlyerService(
      //   ApiKeys.appsFlyerKey,
      //   ApiKeys.iosAppID,
      // );
      AppsFlyerService().initializeSdk();
    } catch (e) {
      Utils().showLog('Error in configure Apps Flyer => $e');
    }
  }

  static Future _handlePaywallResult(PaywallResult result,
      {bool isMembership = false}) async {
    switch (result) {
      case PaywallResult.cancelled:
        break;
      case PaywallResult.error:
        break;
      case PaywallResult.notPresented:
        break;
      case PaywallResult.purchased:
        await Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) =>
                SubscriptionPurchased(isMembership: isMembership),
          ),
        );
        break;
      case PaywallResult.restored:
        break;
    }
  }
}

import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stocks_news_new/providers/membership.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import '../../api/api_response.dart';
import '../../api/apis.dart';
import '../../modals/user_res.dart';
import '../../providers/user_provider.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart' as superwall;

import '../success.dart';
import '../superwall/controller.dart';

class RevenueCatManager {
  static final RevenueCatManager instance = RevenueCatManager._internal();

  RevenueCatManager._internal();

  RCPurchaseController purchaseController = RCPurchaseController();

  static superwall.PurchaseResult cancelled =
      superwall.PurchaseResultCancelled();

  static superwall.PurchaseResult purchased =
      superwall.PurchaseResultPurchased();

  static superwall.PurchaseResult restored = superwall.PurchaseResultRestored();

  static superwall.PurchaseResult pending = superwall.PurchaseResultPending();

  Future<void> initialize({UserRes? user, RevenueCatKeyRes? keys}) async {
    try {
      Purchases.setLogLevel(LogLevel.debug);

      String? appUserId = user?.userId;
      String apiKey = Platform.isAndroid
          ? keys?.playStore ?? ApiKeys.androidKey
          : keys?.appStore ?? ApiKeys.iosKey;

      PurchasesConfiguration configuration = PurchasesConfiguration(apiKey);
      if (appUserId != null) {
        configuration.appUserID = appUserId;
      }

      await Purchases.configure(configuration);

      if (appUserId != null && appUserId.isNotEmpty) {
        Purchases.logIn(appUserId);
        _setUserAttributes(user);
      }

      await _setFirebaseAnalyticsId();
      await _setAppsFlyerId();

      if (Platform.isIOS) {
        await Purchases.enableAdServicesAttributionTokenCollection();
      }
    } catch (e) {
      //
    }
  }

  Future<void> _setFirebaseAnalyticsId() async {
    try {
      FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      String? firebaseAppInstanceId = await analytics.appInstanceId;
      if (firebaseAppInstanceId != null && firebaseAppInstanceId.isNotEmpty) {
        Purchases.setFirebaseAppInstanceId(firebaseAppInstanceId);
        Utils().showLog('Set app instance ID => $firebaseAppInstanceId');
      }
    } catch (e) {
      //
    }
  }

  Future<void> _setAppsFlyerId() async {
    try {
      if (appsFlyerUID != null && appsFlyerUID?.isNotEmpty == true) {
        await Purchases.setAppsflyerID(appsFlyerUID ?? '');
        Utils().showLog('Successfully set purchase AppsFlyer ID $appsFlyerUID');
      }
    } catch (e) {
      //
    }
  }

  void _setUserAttributes(UserRes? userRes) {
    try {
      Map<String, String> attributes = {};

      if (userRes?.name != null && userRes?.name != '') {
        attributes['\$displayName'] = userRes?.name ?? '';
      }

      if (userRes?.email != null && userRes?.email != '') {
        attributes['\$email'] = userRes?.email ?? '';
      }

      if (userRes?.phone != null && userRes?.phone != '') {
        attributes['\$phoneNumber'] =
            userRes?.phoneCode != null && userRes?.phoneCode != ''
                ? '${userRes?.phoneCode}${userRes?.phone}'
                : userRes?.phone ?? '';
      }

      Purchases.setAttributes(attributes);
      Utils().showLog('User attributes set: $attributes');
    } catch (e) {
      Utils().showLog('Error while setting attributes: $e');
    }
  }

  Future<Offerings?> getOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      return offerings;
    } catch (e) {
      Utils().showLog('Error retrieving offerings: $e');
      return null;
    }
  }

  // MARK: SUPERWALL
  initializeSuperWall() async {
    try {
      String apiKey = ApiKeys.superWall;
      superwall.Superwall.configure(
        apiKey,
        purchaseController: purchaseController,
      );

      // SET USER ID TO Superwall
      UserRes? userRes = navigatorKey.currentContext?.read<UserProvider>().user;
      if (userRes?.userId != null && userRes?.userId != '') {
        superwall.Superwall.shared.identify(userRes?.userId ?? "");
      }

      // SET USER ATTRIBUTES TO Superwall
      Map<String, String> attributes = {};
      if (userRes?.name != null && userRes?.name != '') {
        attributes['displayName'] = userRes?.name ?? '';
      }
      if (userRes?.email != null && userRes?.email != '') {
        attributes['email'] = userRes?.email ?? '';
      }
      if (userRes?.phone != null && userRes?.phone != '') {
        attributes['phoneNumber'] =
            userRes?.phoneCode != null && userRes?.phoneCode != ''
                ? '${userRes?.phoneCode}${userRes?.phone}'
                : userRes?.phone ?? '';
      }
      superwall.Superwall.shared.setUserAttributes(attributes);
      //------------------------

      purchaseController.syncSubscriptionStatus();
      Utils().showLog('SuperWall initialized successfully');

      superwall.Superwall.shared.registerEvent(
        Platform.isAndroid ? 'stocks_news_plans_android' : 'stocks_news_plans',
        params: {"ignore_subscription_status": true},
        handler: superwall.PaywallPresentationHandler(),
      );

      superwall.Superwall.shared.setDelegate(SWDelegate());
    } catch (e) {
      if (kDebugMode) {
        print('Superwall Error $e');
      }
    }
  }
}

class SWDelegate extends superwall.SuperwallDelegate {
  @override
  void handleSuperwallEvent(superwall.SuperwallEventInfo eventInfo) async {
    // Handle events here
    switch (eventInfo.event.type) {
      case superwall.EventType.transactionComplete:
        superwall.Superwall.shared
            .setSubscriptionStatus(superwall.SubscriptionStatus.active);
        await navigatorKey.currentContext!
            .read<MembershipProvider>()
            .getMembershipSuccess(isMembership: true);
        await Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => SubscriptionPurchased(isMembership: true),
            ));
        break;
      case superwall.EventType.transactionFail:
        print("Transaction failed: ${eventInfo.event.error}");

        break;
      // Handle other events as needed
      case superwall.EventType.firstSeen:
      case superwall.EventType.appOpen:
      case superwall.EventType.appLaunch:
      case superwall.EventType.identityAlias:
      case superwall.EventType.appInstall:
      case superwall.EventType.restoreStart:
      case superwall.EventType.restoreComplete:
      case superwall.EventType.restoreFail:
      case superwall.EventType.sessionStart:
      case superwall.EventType.deviceAttributes:
      case superwall.EventType.subscriptionStatusDidChange:
      case superwall.EventType.appClose:
      case superwall.EventType.deepLink:
      case superwall.EventType.triggerFire:
      case superwall.EventType.paywallOpen:
      // print('paywallOpen');
      case superwall.EventType.paywallClose:
      // print('paywallClose');

      case superwall.EventType.paywallDecline:
      // print('paywallDecline');

      case superwall.EventType.transactionStart:
      case superwall.EventType.transactionAbandon:
      case superwall.EventType.subscriptionStart:
      case superwall.EventType.freeTrialStart:
      case superwall.EventType.transactionRestore:
      case superwall.EventType.transactionTimeout:
      case superwall.EventType.userAttributes:
      case superwall.EventType.nonRecurringProductPurchase:
      case superwall.EventType.paywallResponseLoadStart:
      case superwall.EventType.paywallResponseLoadNotFound:
      case superwall.EventType.paywallResponseLoadFail:
      case superwall.EventType.paywallResponseLoadComplete:
      case superwall.EventType.paywallWebviewLoadStart:
      case superwall.EventType.paywallWebviewLoadFail:
      case superwall.EventType.paywallWebviewLoadComplete:
      case superwall.EventType.paywallWebviewLoadTimeout:
      case superwall.EventType.paywallWebviewLoadFallback:
      case superwall.EventType.paywallProductsLoadRetry:
      case superwall.EventType.paywallProductsLoadStart:
      case superwall.EventType.paywallProductsLoadFail:
      case superwall.EventType.paywallProductsLoadComplete:
      case superwall.EventType.surveyResponse:
      case superwall.EventType.paywallPresentationRequest:
      case superwall.EventType.touchesBegan:
      case superwall.EventType.surveyClose:
      case superwall.EventType.reset:
      case superwall.EventType.configRefresh:
      case superwall.EventType.customPlacement:
      case superwall.EventType.configAttributes:
      case superwall.EventType.confirmAllAssignments:
      case superwall.EventType.configFail:
      case superwall.EventType.adServicesTokenRequestStart:
      case superwall.EventType.adServicesTokenRequestFail:
      case superwall.EventType.adServicesTokenRequestComplete:
      case superwall.EventType.shimmerViewStart:
      case superwall.EventType.shimmerViewComplete:
    }
  }

  @override
  void didDismissPaywall(superwall.PaywallInfo paywallInfo) {}

  @override
  void didPresentPaywall(superwall.PaywallInfo paywallInfo) {}

  @override
  void handleCustomPaywallAction(String name) {}

  @override
  void handleLog(
      String level, String scope, String? message, Map? info, String? error) {}

  @override
  void paywallWillOpenDeepLink(Uri url) {}

  @override
  void paywallWillOpenURL(Uri url) {}

  @override
  void subscriptionStatusDidChange(superwall.SubscriptionStatus newValue) {}

  @override
  void willDismissPaywall(superwall.PaywallInfo paywallInfo) {}

  @override
  void willPresentPaywall(superwall.PaywallInfo paywallInfo) {}
}

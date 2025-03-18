import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart' as superwall;

import 'screens/rc_controller.dart';

class SuperwallService {
  SuperwallService._internal();
  static final SuperwallService _instance = SuperwallService._internal();
  static SuperwallService get instance => _instance;

  RCPurchaseController purchaseController = RCPurchaseController();

  initializeSuperWall({required String value}) async {
    try {
      RCPurchaseController purchaseController = RCPurchaseController();

      String apiKey =
          Platform.isAndroid ? ApiKeys.superWallAndroid : ApiKeys.superWallIOS;
      superwall.Superwall.configure(
        apiKey,
        purchaseController: purchaseController,
      );

      UserRes? userRes = navigatorKey.currentContext?.read<UserManager>().user;
      if (userRes?.userId != null && userRes?.userId != '') {
        superwall.Superwall.shared.identify(userRes?.userId ?? "");
      }

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
        value,
        // value != null && value != ''
        //     ? value
        //     : Platform.isAndroid
        //         ? 'stocks_news_plans_same_group_android'
        //         : 'stocks_news_plans_same_group_ios',
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
    Utils().showLog('Event Type => ${eventInfo.event.type}');
    switch (eventInfo.event.type) {
      case superwall.EventType.transactionComplete:
        superwall.Superwall.shared
            .setSubscriptionStatus(superwall.SubscriptionStatus.active);
        break;

      case superwall.EventType.transactionRestore:
        if (kDebugMode) {
          print('Restore => transactionRestore');
        }
        superwall.Superwall.shared
            .setSubscriptionStatus(superwall.SubscriptionStatus.active);
        break;

      case superwall.EventType.transactionFail:
        if (kDebugMode) {
          print("Transaction failed: ${eventInfo.event.error}");
        }
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

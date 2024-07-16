import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/membership.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/dialogs.dart';

import '../utils/colors.dart';
import '../utils/utils.dart';
import 'success.dart';

class RevenueCatService {
  static Future initializeSubscription({int? index = 0}) async {
    Purchases.setLogLevel(LogLevel.debug);
    RevenueCatKeyRes? keys =
        navigatorKey.currentContext!.read<HomeProvider>().extra?.revenueCatKeys;
    UserRes? userRes = navigatorKey.currentContext?.read<UserProvider>().user;
    Utils().showLog("${userRes?.userId}");

    PurchasesConfiguration? configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(
          keys?.playStore ?? "goog_KXHVJRLChlyjoOamWsqCWQSJZfI")
        ..appUserID = userRes?.userId ?? "";
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(
          keys?.appStore ?? "appl_kHwXNrngqMNktkEZJqYhEgLjbcC")
        ..appUserID = userRes?.userId ?? "";
    }

    // if (configuration != null) {
    //   await Purchases.configure(configuration);
    //   Offerings? offerings;

    //   offerings = await Purchases.getOfferings();
    //   PaywallResult result = await RevenueCatUI.presentPaywall(
    //       offering: offerings.getOffering('in-app'));

    //   Utils().showLog("Result -> $result");

    //   CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    //   Utils().showLog("Customer-->${customerInfo.managementURL}");

    //   await _handlePaywallResult(result);
    // }

    try {
      showGlobalProgressDialog();
      if (configuration != null) {
        await Purchases.configure(configuration);
        Offerings? offerings;

        offerings = await Purchases.getOfferings();
        closeGlobalProgressDialog();

        PaywallResult result = await RevenueCatUI.presentPaywall(
          offering: offerings.getOffering(
            index == 0
                ? 'access'
                : index == 1
                    ? '100 Points Bundle'
                    : index == 2
                        ? '200 Points Bundle'
                        : '300 Points Bundle',
          ),
        );

        await _handlePaywallResult(result);
      } else {
        closeGlobalProgressDialog();
      }
    } catch (e) {
      closeGlobalProgressDialog();

      Utils().showLog("Error $e");
    }
  }

  static Future _handlePaywallResult(PaywallResult result) async {
    switch (result) {
      case PaywallResult.cancelled:
        break;
      case PaywallResult.error:
        // Handle error
        break;
      case PaywallResult.notPresented:
        // Handle not presented
        break;
      case PaywallResult.purchased:
        navigatorKey.currentContext!
            .read<MembershipProvider>()
            .getMembershipSuccess();
        await _handlePurchaseSuccess();
        break;
      case PaywallResult.restored:
        // Handle restore
        break;
      default:
    }
  }

  static Future _handlePurchaseSuccess() async {
    await showModalBottomSheet(
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      backgroundColor: ThemeColors.transparent,
      isScrollControlled: true,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return const SubscriptionPurchased();
      },
    );
  }
}

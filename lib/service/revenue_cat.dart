// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
// import 'package:stocks_news_new/api/api_response.dart';
// import 'package:stocks_news_new/modals/user_res.dart';
// import 'package:stocks_news_new/providers/home_provider.dart';
// import 'package:stocks_news_new/providers/membership.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/route/my_app.dart';
// import 'package:stocks_news_new/utils/dialogs.dart';
// import '../utils/utils.dart';
// import 'success.dart';

// class RevenueCatService {
//   static Future initializeSubscription({
//     String? type,
//     bool fromMembership = true,
//   }) async {
//     Utils().showLog("---TYPE $type");
//     Purchases.setLogLevel(LogLevel.debug);
//     RevenueCatKeyRes? keys =
//         navigatorKey.currentContext!.read<HomeProvider>().extra?.revenueCatKeys;
//     UserRes? userRes = navigatorKey.currentContext?.read<UserProvider>().user;
//     Utils().showLog("${userRes?.userId}");

//     PurchasesConfiguration? configuration;
//     if (Platform.isAndroid) {
//       configuration = PurchasesConfiguration(
//           keys?.playStore ?? "goog_KXHVJRLChlyjoOamWsqCWQSJZfI")
//         ..appUserID = userRes?.userId ?? "";
//     } else if (Platform.isIOS) {
//       configuration = PurchasesConfiguration(
//           keys?.appStore ?? "appl_kHwXNrngqMNktkEZJqYhEgLjbcC")
//         ..appUserID = userRes?.userId ?? "";
//     }

//     try {
//       navigatorKey.currentContext!
//           .read<MembershipProvider>()
//           .getMembershipSuccess(isMembership: fromMembership);
//       showGlobalProgressDialog();
//       if (configuration != null) {
//         await Purchases.configure(configuration);
//         if (Platform.isIOS) {
//           await Purchases.enableAdServicesAttributionTokenCollection();
//         }
//         Utils().showLog("asking for AD SERVICE");
//         Offerings? offerings;

//         offerings = await Purchases.getOfferings();

//         closeGlobalProgressDialog();

//         PaywallResult result = await RevenueCatUI.presentPaywall(
//           offering: offerings.getOffering(type ?? 'access'),
//         );

//         await _handlePaywallResult(result, isMembership: fromMembership);
//       } else {
//         closeGlobalProgressDialog();
//       }
//     } catch (e) {
//       closeGlobalProgressDialog();

//       Utils().showLog("Error $e");
//     }
//   }

//   static Future _handlePaywallResult(PaywallResult result,
//       {bool isMembership = false}) async {
//     switch (result) {
//       case PaywallResult.cancelled:
//         break;
//       case PaywallResult.error:
//         break;
//       case PaywallResult.notPresented:
//         break;
//       case PaywallResult.purchased:
//         await Navigator.push(
//           navigatorKey.currentContext!,
//           MaterialPageRoute(
//             builder: (context) =>
//                 SubscriptionPurchased(isMembership: isMembership),
//           ),
//         );
//         break;
//       case PaywallResult.restored:
//         break;
//       default:
//     }
//   }
// }

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
import '../utils/utils.dart';
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
      configuration = PurchasesConfiguration(
          keys?.playStore ?? "goog_KXHVJRLChlyjoOamWsqCWQSJZfI")
        ..appUserID = userRes?.userId ?? "";
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(
          keys?.appStore ?? "appl_kHwXNrngqMNktkEZJqYhEgLjbcC")
        ..appUserID = userRes?.userId ?? "";
    }

    try {
      navigatorKey.currentContext!
          .read<MembershipProvider>()
          .getMembershipSuccess(isMembership: fromMembership);
      showGlobalProgressDialog();
      if (configuration != null) {
        await Purchases.configure(configuration);
        if (Platform.isIOS && !_adServicesAttributionEnabled) {
          await Purchases.enableAdServicesAttributionTokenCollection();
          _adServicesAttributionEnabled = true;
          Utils().showLog("Ad Services Attribution Enabled");
        }
        Offerings? offerings;

        offerings = await Purchases.getOfferings();

        closeGlobalProgressDialog();

        PaywallResult result = await RevenueCatUI.presentPaywall(
          offering: offerings.getOffering(type ?? 'access'),
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
      default:
    }
  }
}

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
import 'package:stocks_news_new/screens/auth/base/base_auth.dart';
import 'package:stocks_news_new/screens/auth/membershipAsk/ask.dart';
import 'package:stocks_news_new/service/revenueCat/service.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import '../utils/utils.dart';
import 'success.dart';

class RevenueCatService {
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

    showGlobalProgressDialog();
    RevenueCatManager.instance.initialize(user: userRes, keys: keys);
    closeGlobalProgressDialog();
    try {
      RevenueCatManager.instance.initializeSuperWall();
      // navigatorKey.currentContext!
      //     .read<MembershipProvider>()
      //     .getMembershipSuccess(isMembership: fromMembership);
      // showGlobalProgressDialog();
      // Offerings? offerings;
      // offerings = await Purchases.getOfferings();
      // closeGlobalProgressDialog();
      // Offering? singleOffering =
      //     offerings.getOffering(type ?? 'monthly-premium');
      // PaywallResult result =
      //     await RevenueCatUI.presentPaywall(offering: singleOffering);
      // await _handlePaywallResult(result, isMembership: fromMembership);
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
    }
  }
}

// All Cases Testing Here
Future subscribe({type}) async {
  UserProvider? provider = navigatorKey.currentContext!.read<UserProvider>();
  MembershipProvider? membershipProvider =
      navigatorKey.currentContext!.read<MembershipProvider>();
  withLoginMembership = false;
  if (provider.user == null) {
    Utils().showLog("Ask login-----");
    // isPhone ? await loginSheet() : await loginSheetTablet();
    await loginFirstSheet();

    if (provider.user?.membership?.purchased == 1) {
      Utils().showLog("---user already purchased membership----");
      await membershipProvider.getMembershipInfo();
      // membershipProvider.selectedIndex(index);
    }
  }
  withLoginMembership = true;

  if (provider.user == null) {
    Utils().showLog("---still user not found----");
    return;
  }
  if (provider.user?.phone == null || provider.user?.phone == '') {
    Utils().showLog("Ask phone for membership-----");
    await membershipLogin();
  }
  if (provider.user?.phone != null && provider.user?.phone != '') {
    Utils().showLog("Open Paywall-----");
    await RevenueCatService.initializeSubscription(type: type);
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

// import 'package:superwallkit_flutter/superwallkit_flutter.dart' as sw;

// import 'superwall/controller.dart';

// RCPurchaseController purchaseController = RCPurchaseController();

// class RevenueCatService {
//   static bool _adServicesAttributionEnabled = false;

//   static Future initializeSubscription({
//     String? type,
//     bool fromMembership = true,
//   }) async {
//     RevenueCatKeyRes? keys =
//         navigatorKey.currentContext!.read<HomeProvider>().extra?.revenueCatKeys;
//     UserRes? userRes = navigatorKey.currentContext?.read<UserProvider>().user;
//     Utils().showLog("${userRes?.userId}");

//     Utils().showLog("---TYPE $type");
//     sw.Superwall.shared.setLogLevel(sw.LogLevel.debug);
//     if (userRes != null) {
//       sw.Superwall.shared.identify(userRes.userId ?? "");
//     }

//     try {
//       sw.Superwall.configure(
//         ApiKeys.superWall,
//         purchaseController: purchaseController,
//       );
//       await purchaseController.syncSubscriptionStatus();
//       Utils().showLog('superwall configured');
//     } catch (e) {
//       Utils().showLog('superwall error $e');
//     }

//     try {
//       sw.Superwall.shared.registerEvent(
//         'campaign_trigger',
//       );
//     } catch (e) {
//       Utils().showLog('HIII error $e');
//     }

//     return;
//     Purchases.setLogLevel(LogLevel.debug);

//     PurchasesConfiguration? configuration;
//     if (Platform.isAndroid) {
//       configuration =
//           PurchasesConfiguration(keys?.playStore ?? ApiKeys.androidKey)
//             ..appUserID = userRes?.userId ?? "";
//     } else if (Platform.isIOS) {
//       configuration = PurchasesConfiguration(keys?.appStore ?? ApiKeys.iosKey)
//         ..appUserID = userRes?.userId ?? "";
//     }

//     try {
//       navigatorKey.currentContext!
//           .read<MembershipProvider>()
//           .getMembershipSuccess(isMembership: fromMembership);
//       showGlobalProgressDialog();
//       if (configuration != null) {
//         await Purchases.configure(configuration);
//         FirebaseAnalytics analytics = FirebaseAnalytics.instance;
//         String? firebaseAppInstanceId = await analytics.appInstanceId;
//         if (firebaseAppInstanceId != null && firebaseAppInstanceId != '') {
//           Purchases.setFirebaseAppInstanceId(firebaseAppInstanceId);
//           Utils().showLog('Set app instance ID => $firebaseAppInstanceId');
//         }

//         await configureAppsFlyer();
//         if (Platform.isIOS && !_adServicesAttributionEnabled) {
//           await Purchases.enableAdServicesAttributionTokenCollection();

//           _adServicesAttributionEnabled = true;
//           Utils().showLog("Ad Services Attribution Enabled");
//         }

//         Offerings? offerings;
//         offerings = await Purchases.getOfferings();
//         closeGlobalProgressDialog();
//         Offering? singleOffering =
//             offerings.getOffering(type ?? 'monthly-premium');

//         // Utils().showLog('Single offering: $singleOffering');

//         PaywallResult result =
//             await RevenueCatUI.presentPaywall(offering: singleOffering);

//         await _handlePaywallResult(result, isMembership: fromMembership);
//       } else {
//         closeGlobalProgressDialog();
//       }
//     } catch (e) {
//       closeGlobalProgressDialog();

//       Utils().showLog("Error $e");
//     }
//   }

//   static configureAppsFlyer() async {
//     try {
//       // AppsFlyerService(
//       //   ApiKeys.appsFlyerKey,
//       //   ApiKeys.iosAppID,
//       // );
//       AppsFlyerService.instance.initializeSdk();
//     } catch (e) {
//       Utils().showLog('Error in configure Apps Flyer => $e');
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
//     }
//   }
// }

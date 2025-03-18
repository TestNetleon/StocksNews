import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../api/apis.dart';
import '../../modals/user_res.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import 'screens/rc_controller.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart' as superwall;

class SubscriptionService {
  SubscriptionService._internal();

  static final SubscriptionService _instance = SubscriptionService._internal();

  static SubscriptionService get instance => _instance;

//MARK: Initialization
  Future<bool> initialize({UserRes? user}) async {
    try {
      Purchases.setLogLevel(LogLevel.debug);

      String? appUserId = user?.userId;
      String apiKey = Platform.isAndroid ? ApiKeys.androidKey : ApiKeys.iosKey;

      PurchasesConfiguration configuration = PurchasesConfiguration(apiKey);
      if (appUserId != null) {
        configuration.appUserID = appUserId;
      }

      await Purchases.configure(configuration);

      try {
        RCPurchaseController purchaseController = RCPurchaseController();

        String apiKey = Platform.isAndroid
            ? ApiKeys.superWallAndroid
            : ApiKeys.superWallIOS;
        superwall.Superwall.configure(
          apiKey,
          purchaseController: purchaseController,
        );
      } catch (e) {
        //
      }

      try {
        // Purchases.syncPurchases();
        Utils().showLog('SYNC');
      } catch (e) {
        Utils().showLog('error in sync purchase $e');
      }

      if (appUserId != null && appUserId.isNotEmpty) {
        try {
          Purchases.logIn(appUserId);
        } catch (e) {
          Utils().showLog('Error on login $e');
        }
        _setUserAttributes(user);
      }

      await _setIDS();

      if (Platform.isIOS) {
        await Purchases.enableAdServicesAttributionTokenCollection();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

//MARK: set Attributes
  void _setUserAttributes(UserRes? userRes) {
    try {
      if (userRes?.name != null && userRes?.name != '') {
        Purchases.setDisplayName(userRes?.name ?? '');
      }

      if (userRes?.email != null && userRes?.email != '') {
        Purchases.setEmail(userRes?.email ?? '');
      }

      if (userRes?.phone != null && userRes?.phone != '') {
        String number = userRes?.phoneCode != null && userRes?.phoneCode != ''
            ? '${userRes?.phoneCode}${userRes?.phone}'
            : userRes?.phone ?? '';

        Purchases.setPhoneNumber(number);
      }
    } catch (e) {
      Utils().showLog('Error while setting attributes: $e');
    }
  }

//MARK: set IDs
  Future<void> _setIDS() async {
    try {
      FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      String? firebaseAppInstanceId = await analytics.appInstanceId;
      if (firebaseAppInstanceId != null && firebaseAppInstanceId.isNotEmpty) {
        Purchases.setFirebaseAppInstanceId(firebaseAppInstanceId);
        Utils().showLog('Set firebaseAppInstanceId => $firebaseAppInstanceId');
      }
    } catch (e) {
      //
    }

    try {
      if (appsFlyerUID != null && appsFlyerUID?.isNotEmpty == true) {
        await Purchases.setAppsflyerID(appsFlyerUID ?? '');
        Utils().showLog('Successfully set purchase AppsFlyer ID $appsFlyerUID');
      }
    } catch (e) {
      //
    }
  }

  Future<List<String>> getActiveMembership({bool normalActive = true}) async {
    try {
      if (normalActive) {
        CustomerInfo info = await Purchases.getCustomerInfo();
        return info.activeSubscriptions;
      } else {
        List<String>? subscriptions;
        // Purchases.syncPurchases();
        Purchases.addCustomerInfoUpdateListener((CustomerInfo info) {
          Map<String, EntitlementInfo> entitlements = info.entitlements.all;
          // Utils().showLog('Entitlements $entitlements');
          subscriptions = entitlements.entries
              .where((entry) => entry.value.isActive && entry.value.willRenew)
              .map((entry) => entry.value.productIdentifier)
              .toList();
        });

        return subscriptions ?? [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, List<Package>>> fetchPlans() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      Offering? offeringData = offerings.getOffering('app.stocks.news Plans');

      if (offeringData == null) {
        return {
          'monthly_plans': [],
          'annual_plans': [],
        };
      }

      // Fetch monthly and annual plans
      List<Package> monthlyPlans = [];
      List<Package> annualPlans = [];

      for (var package in offeringData.availablePackages) {
        var value = package.identifier.toLowerCase();
        if (value.contains('monthly')) {
          monthlyPlans.add(package);
        } else if (value.contains('annual')) {
          annualPlans.add(package);
        }
      }

      return {
        'monthly_plans': monthlyPlans,
        'annual_plans': annualPlans,
      };
    } catch (e) {
      return {
        'monthly_plans': [],
        'annual_plans': [],
      };
    }
  }
}

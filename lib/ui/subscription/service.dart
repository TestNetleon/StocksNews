import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../api/apis.dart';
import '../../modals/user_res.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';

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

      if (appUserId != null && appUserId.isNotEmpty) {
        Purchases.logIn(appUserId);
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

        Purchases.addCustomerInfoUpdateListener((CustomerInfo info) {
          Map<String, EntitlementInfo> entitlements = info.entitlements.all;

          subscriptions = entitlements.entries
              .where((entry) => entry.value.isActive && entry.value.willRenew)
              .map((entry) => entry.key)
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

      Offering? monthlyPlans = offerings.getOffering('Stocks.News Offerings');

      Offering? annualPlans =
          offerings.getOffering('Stocks.News Offerings Annual');

      return {
        'monthly_plans': monthlyPlans?.availablePackages ?? [],
        'annual_plans': annualPlans?.availablePackages ?? [],
      };
    } catch (e) {
      //
      return {
        'monthly_plans': [],
        'annual_plans': [],
      };
    }
  }
}

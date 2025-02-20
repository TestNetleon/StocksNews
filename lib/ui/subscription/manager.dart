import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/ui/subscription/service.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../../managers/user.dart';
import '../../routes/my_app.dart';
import '../../utils/constants.dart';
import 'model/my_subscription.dart';

class SubscriptionManager extends ChangeNotifier {
  //MARK: SubscriptionManager
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading;

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future startProcess() async {
    SubscriptionService instance = SubscriptionService.instance;
    try {
      setStatus(Status.loading);

      bool initialized = await instance.initialize();
      Utils().showLog('Revenue Cat initialized $initialized');
      if (initialized) {
        List<String> actives = await instance.getActiveMembership();

        if (actives.isEmpty) {
          await getSubscriptionData();
        }
      }
    } catch (e) {
      Utils().showLog('Error in initialization $e');
    } finally {
      setStatus(Status.loaded);
    }
  }

  MySubscriptionRes? _subscriptionData;
  MySubscriptionRes? get subscriptionData => _subscriptionData;

  Future getSubscriptionData() async {
    try {
      setStatus(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        "platform": Platform.operatingSystem,
      };

      ApiResponse response = await apiRequest(
        url: Apis.mySubscription,
        request: request,
      );

      if (response.status) {
        _subscriptionData =
            mySubscriptionResFromJson(jsonEncode(response.data));

        if (_subscriptionData != null) {
          // Fetch RevenueCat store products
          SubscriptionService instance = SubscriptionService.instance;
          Map<String, List<Package>> getPlans = await instance.fetchPlans();

          List<Package>? monthlyPackages = getPlans['monthly_plans'];
          List<Package>? yearlyPackages = getPlans['annual_plans'];

          // Update store product for monthly plans
          if (_subscriptionData!.monthlyPlan != null &&
              _subscriptionData!.monthlyPlan!.isNotEmpty) {
            for (var plan in _subscriptionData!.monthlyPlan!) {
              var matchedProduct = monthlyPackages?.firstWhere(
                (p) => p.storeProduct.identifier == plan.identifier,
              );
              plan.storeProduct = matchedProduct?.storeProduct;
              Utils().showLog('Monthly Product -> ${plan.storeProduct}');
            }
          }

          // Update store product for yearly plans
          if (_subscriptionData?.annualPlan != null &&
              _subscriptionData?.annualPlan?.isNotEmpty == true) {
            for (var plan in _subscriptionData!.annualPlan!) {
              var matchedProduct = yearlyPackages?.firstWhere(
                (p) => p.storeProduct.identifier == plan.identifier,
              );
              plan.storeProduct = matchedProduct?.storeProduct;
              Utils().showLog('Annual Product -> ${plan.storeProduct}');
            }
          }
        }
      } else {
        _subscriptionData = null;
      }
    } catch (e) {
      _subscriptionData = null;
      Utils().showLog("Error fetching subscription data: $e");
    } finally {
      setStatus(Status.loaded);
      notifyListeners(); // Notify UI about the changes
    }
  }
}

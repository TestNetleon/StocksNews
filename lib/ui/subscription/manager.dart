import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/ui/subscription/screens/purchased/purchased.dart';
import 'package:stocks_news_new/ui/subscription/screens/start/subscription.dart';
import 'package:stocks_news_new/ui/subscription/service.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../../managers/user.dart';
import '../../routes/my_app.dart';
import '../../utils/constants.dart';
import 'model/subscription.dart';
import 'screens/view/plans.dart';

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

//MARK: Start Process
  Future startProcess({viewPlans = false}) async {
    SubscriptionService instance = SubscriptionService.instance;
    try {
      setStatus(Status.loading);
      UserManager manager = navigatorKey.currentContext!.read<UserManager>();
      bool initialized = await instance.initialize(user: manager.user);
      Utils().showLog('Revenue Cat initialized $initialized');
      if (initialized) {
        if (viewPlans) {
          //navigate to all plans
          Navigator.pushNamed(
            navigatorKey.currentContext!,
            SubscriptionPlansIndex.path,
          );
        } else {
          List<String> actives =
              await instance.getActiveMembership(normalActive: false);

          if (actives.isEmpty) {
            //navigate first time purchase

            Navigator.pushNamed(
              navigatorKey.currentContext!,
              SubscriptionIndex.path,
            );
          } else {
            //navigate first already purchased

            Navigator.pushNamed(
              navigatorKey.currentContext!,
              PurchasedIndex.path,
            );
          }

          if (kDebugMode) {
            print('Actives $actives');
          }
        }
      }
    } catch (e) {
      Utils().showLog('Error in initialization $e');
      TopSnackbar.show(message: Const.errSomethingWrong);
    } finally {
      setStatus(Status.loaded);
    }
  }

  SubscriptionRes? _subscriptionData;
  SubscriptionRes? get subscriptionData => _subscriptionData;

  ProductPlanRes? _selectedPlan;
  ProductPlanRes? get selectedPlan => _selectedPlan;

  onChangePlan(ProductPlanRes? plan) {
    _selectedPlan = plan;
    Utils().showLog('Selected Identifier ${plan?.storeProduct?.identifier}');
    notifyListeners();
  }

//MARK: Subscription Plans
  Future getSubscriptionData() async {
    _selectedPlan = null;
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
          print('Length ${monthlyPackages?.length}');
          print('Length ${yearlyPackages?.length}');

          try {
            // Update store product for monthly plans
            if (_subscriptionData!.monthlyPlan != null &&
                _subscriptionData!.monthlyPlan!.isNotEmpty) {
              for (var plan in _subscriptionData!.monthlyPlan!) {
                var matchedProduct = monthlyPackages?.firstWhere(
                  (p) => p.storeProduct.identifier == plan.identifier,
                );
                plan.storeProduct = matchedProduct?.storeProduct;

                // Utils().showLog('Monthly Product -> ${plan.storeProduct}');
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
                // Utils().showLog('Annual Product -> ${plan.storeProduct}');
              }
            }
          } catch (e) {
            Utils().showLog('Error while saving plans $e');
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

//MARK: My Purchased Subscription
  Future getMyPurchasedData() async {
    SubscriptionService instance = SubscriptionService.instance;
    UserManager manager = navigatorKey.currentContext!.read<UserManager>();
    bool initialized = await instance.initialize(user: manager.user);
    if (initialized) {}
  }
}

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
import 'model/my_subscription.dart';
import 'model/subscription.dart';
import 'screens/view/plans.dart';

enum SubscriptionDefault {
  monthlyBasic,
  monthlyPro,
  monthlyElite,
  annualBasic,
  annualPro,
  annualElite
}

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
  Future startProcess({
    viewPlans = false,
    SubscriptionDefault? defaultSelected,
  }) async {
    SubscriptionService instance = SubscriptionService.instance;
    try {
      setStatus(Status.loading);
      UserManager manager = navigatorKey.currentContext!.read<UserManager>();
      bool initialized = await instance.initialize(user: manager.user);
      Utils().showLog('Revenue Cat initialized $initialized');
      if (initialized) {
        if (viewPlans) {
          if (kDebugMode) {
            print('Goto - View Plans');
          }
          Navigator.pushNamed(
            navigatorKey.currentContext!,
            SubscriptionPlansIndex.path,
          );
        } else {
          List<String> actives =
              await instance.getActiveMembership(normalActive: false);

          if (actives.isEmpty) {
            if (kDebugMode) {
              Utils().showLog('Goto - First Time Purchase');
            }

            Navigator.pushNamed(
              navigatorKey.currentContext!,
              SubscriptionIndex.path,
            );
          } else {
            if (kDebugMode) {
              Utils().showLog('Goto - Already Purchased');
            }

            Navigator.pushNamed(
              navigatorKey.currentContext!,
              PurchasedIndex.path,
            );
          }

          if (kDebugMode) {
            Utils().showLog('Actives $actives');
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
        url: Apis.subscription,
        request: request,
      );

      if (response.status) {
        _subscriptionData = subscriptionResFromJson(jsonEncode(response.data));
        SubscriptionService instance = SubscriptionService.instance;
        UserManager manager = navigatorKey.currentContext!.read<UserManager>();

        bool initialized = await instance.initialize(user: manager.user);

        if (_subscriptionData != null && initialized) {
          // Fetch RevenueCat store products
          SubscriptionService instance = SubscriptionService.instance;
          Map<String, List<Package>> getPlans = await instance.fetchPlans();

          List<Package>? monthlyPackages = getPlans['monthly_plans'];
          List<Package>? yearlyPackages = getPlans['annual_plans'];

          try {
            // Update store product for monthly plans
            if (_subscriptionData!.monthlyPlan != null &&
                _subscriptionData!.monthlyPlan!.isNotEmpty) {
              for (var plan in _subscriptionData!.monthlyPlan!) {
                var matchedProduct = monthlyPackages?.firstWhere(
                  (p) => p.storeProduct.identifier == plan.productID,
                );
                plan.storeProduct = matchedProduct?.storeProduct;
                plan.price = plan.storeProduct?.priceString;
              }
            }

            // Update store product for yearly plans
            if (_subscriptionData?.annualPlan != null &&
                _subscriptionData?.annualPlan?.isNotEmpty == true) {
              for (var plan in _subscriptionData!.annualPlan!) {
                var matchedProduct = yearlyPackages?.firstWhere(
                  (p) => p.storeProduct.identifier == plan.productID,
                );
                plan.storeProduct = matchedProduct?.storeProduct;
                plan.price = plan.storeProduct?.priceString;
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
      Utils().showLog("Error in ${Apis.subscription}: $e");
    } finally {
      setStatus(Status.loaded);
    }
  }

//MARK: My Purchased Subscription
  MySubscriptionRes? _mySubscriptionData;
  MySubscriptionRes? get mySubscriptionData => _mySubscriptionData;

  int _page = 1;
  bool get canLoadMoreHistory =>
      _page <= (_mySubscriptionData?.paymentHistory?.totalPages ?? 1);

  Future getMyPurchasedData({loadMore = false}) async {
    try {
      if (loadMore) {
        _page++;
        setStatus(Status.loadingMore);
      } else {
        _page = 1;
        setStatus(Status.loading);
      }

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'page': '$_page',
      };

      ApiResponse response = await apiRequest(
        url: Apis.mySubscription,
        request: request,
      );

      if (response.status) {
        if (_page == 1) {
          _mySubscriptionData =
              mySubscriptionResFromJson(jsonEncode(response.data));
          _error = null;
        } else {
          _mySubscriptionData?.paymentHistory?.data?.addAll(
              mySubscriptionResFromJson(jsonEncode(response.data))
                      .paymentHistory
                      ?.data ??
                  []);
        }
      } else {
        if (_page == 1) {
          _mySubscriptionData = null;
          _error = response.message;
        }
      }
    } catch (e) {
      if (_page == 1) {
        _mySubscriptionData = null;
        _error = Const.errSomethingWrong;
      }
      Utils().showLog("Error in ${Apis.mySubscription}: $e");
    } finally {
      setStatus(Status.loaded);
      notifyListeners();
    }
  }
}

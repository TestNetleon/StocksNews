import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/ui/subscription/model/layout.dart';
import 'package:stocks_news_new/ui/subscription/screens/purchased/purchased.dart';
import 'package:stocks_news_new/ui/subscription/screens/start/subscription.dart';
import 'package:stocks_news_new/ui/subscription/service.dart';
import 'package:stocks_news_new/ui/subscription/superwall_service.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../../managers/user.dart';
import '../../routes/my_app.dart';
import '../../utils/constants.dart';
import 'model/layout_one.dart';
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
    viewPlans = true,
    SubscriptionDefault? defaultSelected,
  }) async {
    SubscriptionService instance = SubscriptionService.instance;
    try {
      setStatus(Status.loading);
      UserManager manager = navigatorKey.currentContext!.read<UserManager>();
      bool initialized = await instance.initialize(user: manager.user);
      Utils().showLog('Revenue Cat initialized $initialized');
      if (initialized) {
        ApiResponse res = await getMembershipLayout();
        if (res.status) {
          if (_layoutData?.superWallLayout != null &&
              _layoutData?.superWallLayout != '') {
            SuperwallService.instance
                .initializeSuperWall(value: _layoutData?.superWallLayout ?? '');
            return;
          }
        }

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

        if (_layoutData?.membershipLayout == 1) {
          await _layout1Paywall();
        } else {
          await _baseLayoutPaywall();
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

//MARK: Subscription Layout
  SubscriptionLayoutsRes? _layoutData;
  SubscriptionLayoutsRes? get layoutData => _layoutData;

  Future getMembershipLayout() async {
    try {
      Map request = {
        'platform': Platform.operatingSystem,
      };
      ApiResponse response = await apiRequest(
        url: Apis.subscriptionLayout,
        showProgress: true,
        request: request,
      );
      if (response.status) {
        _layoutData = subscriptionLayoutsResFromJson(jsonEncode(response.data));
      } else {
        _layoutData = null;
      }
      notifyListeners();
      return ApiResponse(status: response.status);
    } catch (e) {
      _layoutData = null;
      notifyListeners();
      return ApiResponse(status: false);
    }
  }

//MARK: Base Layout
  Future _baseLayoutPaywall() async {
    if (_subscriptionData != null) {
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
            Package? matchedProduct = monthlyPackages?.firstWhereOrNull(
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
            var matchedProduct = yearlyPackages?.firstWhereOrNull(
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
  }

//MARK: Layout 1
  Future _layout1Paywall() async {
    Utils().showLog("****L1Fetching subscription data...");

    if (_subscriptionData != null) {
      // Fetch RevenueCat store products
      Utils().showLog("****L1Fetching store products from RevenueCat...");

      SubscriptionService instance = SubscriptionService.instance;
      Map<String, List<Package>> getPlans = await instance.fetchPlans();

      List<Package>? monthlyPackages = getPlans['monthly_plans'];
      List<Package>? yearlyPackages = getPlans['annual_plans'];

      Utils().showLog(
          "****L1Fetched ${monthlyPackages?.length ?? 0} monthly packages and ${yearlyPackages?.length ?? 0} yearly packages.");

      Layout1Res? layout1 = _subscriptionData?.layout1;

      if (layout1 != null) {
        try {
          Utils().showLog("****L1Processing layout1 data...");
          List<List<ProductPlanRes>?> allPlans = [
            layout1.basic?.data,
            layout1.pro?.data,
            layout1.elite?.data,
          ];

          for (var plans in allPlans) {
            if (plans == null) {
              if (kDebugMode) {
                Utils().showLog("****L1Skipping null plan category...");
              }
              continue;
            }

            for (int i = 0; i < plans.length; i++) {
              var plan = plans[i];
              if (kDebugMode) {
                Utils().showLog("****L1Processing plan: ${plan.productID}");
              }

              try {
                var matchedLProduct = yearlyPackages?.firstWhereOrNull(
                  (p) => p.storeProduct.identifier == plan.productID,
                );
                if (matchedLProduct != null) {
                  plan.storeProduct = matchedLProduct.storeProduct;
                  plan.price = matchedLProduct.storeProduct.priceString;
                  if (kDebugMode) {
                    Utils().showLog(
                        "****L1Matched yearly product for ${plan.productID}: ${plan.price}");
                  }
                } else {
                  if (kDebugMode) {
                    Utils().showLog(
                        "****L1No matching yearly product found for ${plan.productID}");
                  }
                }
              } catch (e) {
                if (kDebugMode) {
                  Utils().showLog('****L1 ERROR $e');
                }
              }

              try {
                var matchedMProduct = monthlyPackages?.firstWhereOrNull(
                  (p) => p.storeProduct.identifier == plan.productID,
                );
                if (matchedMProduct != null) {
                  plan.storeProduct = matchedMProduct.storeProduct;
                  plan.price = matchedMProduct.storeProduct.priceString;
                  if (kDebugMode) {
                    Utils().showLog(
                        "****L1Matched monthly product for ${plan.productID}: ${plan.price}");
                  }
                } else {
                  if (kDebugMode) {
                    Utils().showLog(
                        "****L1No matching monthly product found for ${plan.productID}");
                  }
                }
              } catch (e) {
                if (kDebugMode) {
                  Utils().showLog('****L1 ERROR $e');
                }
              }
            }
          }

          if (kDebugMode) {
            Utils().showLog("****L1Finished processing layout1 plans.");
          }
        } catch (e) {
          if (kDebugMode) {
            Utils().showLog("****L1Error while saving plans: $e");
          }
        }
      } else {
        if (kDebugMode) {
          Utils().showLog("****L1No layout1 data found.");
        }
      }
    } else {
      if (kDebugMode) {
        Utils().showLog("****L1No subscription data available.");
      }
    }
  }

//MARK: Purchase
  bool isClickable = true;
  _purchaseClickable(value) {
    isClickable = value;
    notifyListeners();

    if (value) {
      closeGlobalProgressDialog();
    } else {
      showGlobalProgressDialog();
    }
  }

  Future onPurchase() async {
    if (selectedPlan == null) return;
    if (selectedPlan?.storeProduct == null) return;

    UserManager manager = navigatorKey.currentContext!.read<UserManager>();
    if (manager.user == null) {
      await manager.askLoginScreen();
    }
    if (manager.user == null) return;

    try {
      _purchaseClickable(false);

      CustomerInfo customerInfo = await Purchases.purchaseStoreProduct(
        selectedPlan!.storeProduct!,
      );
      if (kDebugMode) {
        print("Successful: ${customerInfo.entitlements.active}");
      }
      TopSnackbar.show(
        message: 'You’re All Set! Start enjoying',
        type: ToasterEnum.success,
      );
      // _purchaseClickable(true);

      Future.delayed(Duration(milliseconds: 200), () {
        // Navigator.pushAndRemoveUntil(
        //   navigatorKey.currentContext!,
        //   MaterialPageRoute(builder: (context) => Tabs()),
        //   (route) => false,
        // );

        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: BaseAppBar(
                showBack: true,
              ),
            ),
          ),
        );
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('finally exception $e');
      }

      TopSnackbar.show(message: e.message ?? '', type: ToasterEnum.error);
    } catch (e) {
      if (kDebugMode) {
        print('finally catch $e');
      }
    } finally {
      _purchaseClickable(true);
      if (kDebugMode) {
        print('finally..');
      }
    }
  }

//MARK: Restore Purchase
  Future onRestorePurchase() async {
    UserManager manager = navigatorKey.currentContext!.read<UserManager>();
    if (manager.user == null) {
      await manager.askLoginScreen();
    }
    if (manager.user == null) return;

    try {
      _purchaseClickable(false);

      CustomerInfo customerInfo = await Purchases.restorePurchases();
      if (kDebugMode) {
        print("Successful: ${customerInfo.entitlements.active}");
      }
      TopSnackbar.show(
        message: 'You’re All Set! Start enjoying',
        type: ToasterEnum.success,
      );
      // _purchaseClickable(true);

      Future.delayed(Duration(milliseconds: 200), () {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: BaseAppBar(
                showBack: true,
              ),
            ),
          ),
        );
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('finally exception $e');
      }

      TopSnackbar.show(message: e.message ?? '', type: ToasterEnum.error);
    } catch (e) {
      if (kDebugMode) {
        print('finally catch $e');
      }
    } finally {
      _purchaseClickable(true);
      if (kDebugMode) {
        print('finally..');
      }
    }
  }
}

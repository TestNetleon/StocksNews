import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/subscription/screens/purchased/purchased.dart';
import 'package:stocks_news_new/ui/subscription/screens/view/annual.dart';
import 'package:stocks_news_new/ui/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../utils/colors.dart';
import 'monthly.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';
import '../../../../managers/user.dart';
import '../../../../routes/my_app.dart';

class ViewAllPlans extends StatefulWidget {
  const ViewAllPlans({super.key});

  @override
  State<ViewAllPlans> createState() => _ViewAllPlansState();
}

class _ViewAllPlansState extends State<ViewAllPlans> {
  bool _isClickable = true;
  bool _showIntroductory = false;

  _purchaseClickable(value) {
    _isClickable = value;
    if (value) {
      closeGlobalProgressDialog();
    } else {
      showGlobalProgressDialog();
    }
    if (mounted) {
      setState(() {});
    }
  }

  final List<MarketResData> _tabs = [
    MarketResData(title: 'Monthly', slug: 'monthly_plans'),
    MarketResData(title: 'Annual', slug: 'annual_plans'),
  ];

  int _selectedTab = 0;
  void _onChange(index) {
    if (_selectedTab != index) {
      _selectedTab = index;
      if (kDebugMode) {
        print('Selected $index');
      }
      setState(() {});
    }
  }

  void _checkIntroOfferUsage() async {
    try {
      if (context.read<SubscriptionManager>().selectedPlan?.storeProduct ==
          null) {
        return;
      }
      Utils().showLog('---1');

      String productId = context
          .read<SubscriptionManager>()
          .selectedPlan!
          .storeProduct!
          .identifier;
      Utils().showLog('---2');

      Map<String, IntroEligibility> eligibility =
          await Purchases.checkTrialOrIntroductoryPriceEligibility([productId]);
      Utils().showLog('---3');

      // Correct eligibility check
      IntroEligibilityStatus? status = eligibility[productId]?.status;

      if (status == IntroEligibilityStatus.introEligibilityStatusEligible) {
        _showIntroductory = true;
      } else {
        _showIntroductory = false;
      }
      if (mounted) {
        setState(() {});
      }

      Utils()
          .showLog('---User Intro Offer Eligibility for $productId: $status');
      Utils().showLog('---User is eligible for offer: $_showIntroductory');
    } catch (e) {
      Utils().showLog('---Error checking intro offer usage: $e');
    }
  }

  _onPurchase() async {
    SubscriptionManager subscriptionManager =
        context.read<SubscriptionManager>();
    if (subscriptionManager.selectedPlan == null) return;

    if (subscriptionManager.selectedPlan?.storeProduct == null) return;

    UserManager manager = navigatorKey.currentContext!.read<UserManager>();
    manager.askLoginScreen();
    if (manager.user == null) {
      return;
    }

    try {
      _purchaseClickable(false);

      CustomerInfo customerInfo = await Purchases.purchaseStoreProduct(
        subscriptionManager.selectedPlan!.storeProduct!,
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
        Navigator.pushAndRemoveUntil(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => Tabs()),
          (route) => false,
        );

        Future.microtask(() {
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => PurchasedIndex()),
          );
        });
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

  _onRestorePurchase() async {
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
        //
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

  @override
  Widget build(BuildContext context) {
    SubscriptionManager manager = context.watch<SubscriptionManager>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Pad.pad16),
          child: BaseTabs(
            isScrollable: false,
            data: _tabs,
            onTap: _onChange,
          ),
        ),
        if (_selectedTab == 0) ViewMonthlyPlan(),
        if (_selectedTab == 1) ViewAnnualPlan(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              BaseButton(
                text: (manager.selectedPlan?.storeProduct?.introductoryPrice !=
                            null &&
                        _showIntroductory)
                    ? 'Try 7 days for free'
                    : 'Purchase',
                onPressed: manager.selectedPlan == null || !_isClickable
                    ? null
                    : _onPurchase,
              ),
              SpacerVertical(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        openUrl(
                            'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/');
                      },
                      child: Text(
                        'Terms of Service',
                        style:
                            styleGeorgiaRegular(color: ThemeColors.neutral40),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: manager.subscriptionData?.showRestore == true,
                    child: Flexible(
                      child: GestureDetector(
                        onTap: _onRestorePurchase,
                        child: Text(
                          'Restore Purchase',
                          style:
                              styleGeorgiaRegular(color: ThemeColors.neutral40),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Privacy Policy',
                        style: styleBaseRegular(color: ThemeColors.neutral40),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

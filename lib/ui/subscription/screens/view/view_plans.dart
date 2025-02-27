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
      _purchaseClickable(true);
      Future.delayed(Duration(seconds: 1), () {
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

  @override
  Widget build(BuildContext context) {
    SubscriptionManager manager = context.watch<SubscriptionManager>();
    print('$_isClickable');
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
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: Pad.pad16, vertical: 10),
          child: BaseButton(
            text: 'Purchase',
            onPressed: manager.selectedPlan == null || !_isClickable
                ? null
                : _onPurchase,
          ),
        ),
      ],
    );
  }
}

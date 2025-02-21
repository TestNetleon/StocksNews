import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/service/superwall/controller.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/subscription/screens/view/annual.dart';
import 'package:stocks_news_new/utils/constants.dart';
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
    setState(() {});
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

    // showGlobalProgressDialog();
    // closeGlobalProgressDialog();

    try {
      _purchaseClickable(false);
      // Offerings? off = await Purchases.getOfferings();
      // Offering? of = off.getOffering('app.stocks.news Plans');
      // print('======> ${of?.availablePackages.first.storeProduct}');
      // return;
      CustomerInfo customerInfo = await Purchases.purchaseStoreProduct(
        subscriptionManager.selectedPlan!.storeProduct!,
        // of!.availablePackages.first.storeProduct,
      );
      // await Purchases.syncPurchases();
      if (kDebugMode) {
        print("Successful: ${customerInfo.entitlements.active}");
        print("Successful: ${customerInfo.getLatestTransactionPurchaseDate()}");
      }
      TopSnackbar.show(
        message: 'You’re All Set! Start enjoying',
        type: ToasterEnum.success,
      );
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

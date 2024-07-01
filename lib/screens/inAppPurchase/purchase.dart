import 'dart:io';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class InAppPurchaseUI extends StatefulWidget {
  const InAppPurchaseUI({super.key});

  @override
  State<InAppPurchaseUI> createState() => _InAppPurchaseUIState();
}

class _InAppPurchaseUIState extends State<InAppPurchaseUI> {
  PurchasesConfiguration? configuration;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ThemeButton(
          text: "Configure",
          onPressed: () {
            initPlatformState();
          },
        ),
        ThemeButton(
          text: "Click",
          onPressed: () {},
        ),
      ],
    );
  }

  Future<void> initPlatformState() async {
    // ignore: deprecated_member_use
    Purchases.setDebugLogsEnabled(true);

    if (Platform.isAndroid) {
      //
    } else if (Platform.isIOS) {
      configuration =
          PurchasesConfiguration("appl_kHwXNrngqMNktkEZJqYhEgLjbcC");
    }

    if (configuration != null) {
      await Purchases.configure(configuration!);
      final result = await RevenueCatUI.presentPaywallIfNeeded("Pro");
      Utils().showLog("$result");

      // final products = await Purchases.getProducts(
      //   productCategory: ProductCategory.subscription,
      //   ['month_only', 'annual_only'],
      // );

      // final offerings = await Purchases.getOfferings();
    }
  }
}

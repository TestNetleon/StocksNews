import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
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
          onPressed: () {
            _products();
          },
        ),
      ],
    );
  }

  Future<void> initPlatformState() async {
    try {
      await Purchases.setLogLevel(LogLevel.debug);

      if (Platform.isAndroid) {
//
      } else if (Platform.isIOS) {
        configuration =
            PurchasesConfiguration("appl_kHwXNrngqMNktkEZJqYhEgLjbcC");
      }

      if (configuration != null) {
        await Purchases.configure(configuration!);
        // final result = await RevenueCatUI.presentPaywallIfNeeded("Pro");
        // Utils().showLog("$result");
      }
    } catch (e) {
      Utils().showLog(e);
    }
  }

  _products() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {}
    } on PlatformException catch (e) {
      Utils().showLog(e);
    }
  }
}

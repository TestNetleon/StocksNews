import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/service/revenue_cat.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class RevenueCatPoints extends StatelessWidget {
  const RevenueCatPoints({super.key});

  void _accessRevenueCat({int? index = 0}) {
    RevenueCatService.initializeSubscription(index: index);
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(isPopback: true),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ThemeButton(
                text: "Subscription",
                onPressed: () {
                  _accessRevenueCat();
                },
              ),
              ThemeButton(
                text: "100 Points",
                onPressed: () {
                  _accessRevenueCat(index: 1);
                },
              ),
              ThemeButton(
                text: "200 Points",
                onPressed: () {
                  _accessRevenueCat(index: 2);
                },
              ),
              ThemeButton(
                text: "300 Points",
                onPressed: () {
                  _accessRevenueCat(index: 3);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

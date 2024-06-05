import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/stockDetail/index.dart';
import 'package:stocks_news_new/screens/tabs/home/home_container.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Home extends StatelessWidget {
  static const String path = "Home";
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.logEvent(
      name: 'ScreensVisit',
      parameters: {'screen_name': "Home Screen"},
    );
    return const BaseContainer(
      body: HomeContainer(),
      // TODO: Remove after Testing
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: ThemeColors.accent,
      //   onPressed: () {
      //     Navigator.pushNamed(
      //       context,
      //       StockDetail.path,
      //       arguments: {"slug": 'aapl'},
      //     );
      //   },
      //   child: const Icon(Icons.bar_chart),
      // ),
    );
  }
}

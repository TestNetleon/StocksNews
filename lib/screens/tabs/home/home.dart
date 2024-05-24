import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/home_container.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Home extends StatelessWidget {
  static const String path = "Home";
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // HomeProvider provider = context.watch<HomeProvider>();

    FirebaseAnalytics.instance.logEvent(
      name: 'ScreensVisit',
      parameters: {'screen_name': "Home Screen"},
    );

    return const BaseContainer(
      body: HomeContainer(),
      // AnimatedSwitcher(
      //   duration: const Duration(milliseconds: 500),
      //   child:
      // provider.isLoadingSlider ? const Loading() : const HomeContainer(),
      // ),
    );
  }
}

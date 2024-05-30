import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/drawerScreens/drawerMarketDataScSimmer/tab_bar_sc_simmer.dart';

class HomeScreenSimmer extends StatelessWidget {
  const HomeScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [TabViewScreenSimmer()],
    );
  }
}

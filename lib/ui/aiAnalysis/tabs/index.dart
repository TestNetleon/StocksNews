import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';

import '../../../models/market/market_res.dart';
import 'overview/overview.dart';

class AITabs extends StatefulWidget {
  const AITabs({super.key});

  @override
  State<AITabs> createState() => _AITabsState();
}

class _AITabsState extends State<AITabs> {
  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;

    void onTabChange(index) {
      selectedIndex = index;
      setState(() {});
    }

    List<MarketResData> tabs = [
      MarketResData(title: 'Overview', slug: 'overview'),
      MarketResData(title: 'News', slug: 'news'),
      MarketResData(title: 'Events', slug: 'events'),
    ];
    return Column(
      children: [
        BaseTabs(
          data: tabs,
          isScrollable: false,
          onTap: onTabChange,
        ),
        if (selectedIndex == 0) AIOverview(),
        if (selectedIndex == 1) Container(),
        if (selectedIndex == 2) Container(),
      ],
    );
  }
}

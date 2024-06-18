import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/marketData/gainersLosers/today_breakout_stocks.dart';
import 'package:stocks_news_new/screens/marketData/gainersLosers/today_top_gainer.dart';
import 'package:stocks_news_new/screens/marketData/gainersLosers/today_top_losers.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

import '../../../utils/constants.dart';

class GainersLosersIndex extends StatefulWidget {
  static const path = "GainersLosersIndex";
  final StocksType type;

  const GainersLosersIndex({super.key, required this.type});

  @override
  State<GainersLosersIndex> createState() => _GainersLosersIndexState();
}

class _GainersLosersIndexState extends State<GainersLosersIndex> {
  @override
  Widget build(BuildContext context) {
    return const BaseContainer(
      appBar: AppBarHome(
        isPopback: true,
        canSearch: true,
      ),
      body: CustomTabContainerNEW(
        scrollable: true,
        tabsPadding: EdgeInsets.zero,
        tabs: ["Today's Gainers", "Today's Losers", "Today's Breakout Stocks"],
        // onChange: (index) => onChange(index),
        widgets: [
          TodaysTopGainer(),
          TodaysTopLoser(),
          TodaysBreakoutStocks(),
        ],
      ),
    );
  }
}

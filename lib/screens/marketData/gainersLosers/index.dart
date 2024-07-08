import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/marketData/gainersLosers/today_breakout_stocks.dart';
import 'package:stocks_news_new/screens/marketData/gainersLosers/today_top_gainer.dart';
import 'package:stocks_news_new/screens/marketData/gainersLosers/today_top_losers.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

import '../../../providers/home_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../utils/constants.dart';
import '../lock/common_lock.dart';

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
    UserProvider provider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();

    bool purchased = provider.user?.membership?.purchased == 1;

    bool isLocked = false;

    if (purchased) {
      bool havePermissions = provider.user?.membership?.permissions?.any(
              (element) =>
                  element == "gainer_loser" || element == "breakout-stocks") ??
          false;
      isLocked = !havePermissions;
    } else {
      if (!isLocked) {
        isLocked = homeProvider.extra?.membership?.permissions?.any((element) =>
                element == "gainer_loser" || element == "breakout-stocks") ??
            false;
      }
    }
    return BaseContainer(
      bottomSafeAreaColor: ThemeColors.background,
      appBar: const AppBarHome(
        isPopback: true,
        canSearch: true,
      ),
      body: Stack(
        children: [
          const CommonTabContainer(
            scrollable: true,
            tabs: [
              "Today's Gainers",
              "Today's Losers",
              "Today's Breakout Stocks"
            ],
            widgets: [
              TodaysTopGainer(),
              TodaysTopLoser(),
              TodaysBreakoutStocks(),
            ],
          ),
          if (isLocked)
            CommonLock(
              isLocked: isLocked,
              showLogin: true,
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/drawer_res.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/drawerScreens/congressionalData/index.dart';
import 'package:stocks_news_new/screens/drawerScreens/fiftyTwoWeeks/index.dart';
import 'package:stocks_news_new/screens/drawerScreens/gainersLosers/index.dart';
import 'package:stocks_news_new/screens/drawerScreens/gapUpDown/index.dart';
import 'package:stocks_news_new/screens/drawerScreens/highLowPE/index.dart';
import 'package:stocks_news_new/screens/drawerScreens/highsLowsBetaStocks/index.dart';
import 'package:stocks_news_new/screens/drawerScreens/indices/index.dart';
import 'package:stocks_news_new/screens/drawerScreens/lowPriceStocks/index.dart';
import 'package:stocks_news_new/screens/drawerScreens/pennyStocks/index.dart';
import 'package:stocks_news_new/screens/myAccount/my_account.dart';
import 'package:stocks_news_new/screens/stocks/index.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';

import '../../blogs/index.dart';
import '../../contactUs/contact_us.dart';
import '../../faq/index.dart';
import '../../t&cAndPolicy/tc_policy.dart';
import '../../whatWeDo/index.dart';

List<DrawerRes> marketData = [
  DrawerRes(
    iconData: Icons.calendar_month_outlined,
    text: "Calendar",
  ),
  // DrawerRes(
  //   iconData: Icons.data_exploration_outlined,
  //   text: "Commodities",
  // ),
  // DrawerRes(
  //   iconData: Icons.currency_bitcoin,
  //   text: "Crypto",
  // ),
  // DrawerRes(
  //   iconData: Icons.currency_yen_outlined,
  //   text: "Currencies",
  // ),
  DrawerRes(
    iconData: Icons.precision_manufacturing_outlined,
    text: "Gainers & Losers",
    onTap: () {
      Navigator.pushNamed(
        navigatorKey.currentContext!,
        GainersLosersIndex.path,
        arguments: {"type": StocksType.gainers},
      );
    },
  ),
  DrawerRes(
    iconData: Icons.precision_manufacturing_outlined,
    text: "Gap Up/Down Stocks",
    onTap: () =>
        Navigator.pushNamed(navigatorKey.currentContext!, GapUpDownStocks.path),
  ),
  DrawerRes(
    iconData: Icons.pending_actions_rounded,
    text: "Insider Trades",
    onTap: () {
      Navigator.pushNamed(
        navigatorKey.currentContext!,
        Tabs.path,
        arguments: 2,
      );
    },
  ),
  DrawerRes(
    iconData: Icons.pending_actions_rounded,
    text: "Market Sentiment",
    onTap: () {
      Navigator.pushNamed(
        navigatorKey.currentContext!,
        Tabs.path,
        arguments: 3,
      );
    },
  ),
  DrawerRes(
    iconData: Icons.pending_actions_rounded,
    text: "High & Low PE",
    onTap: () {
      Navigator.pushNamed(navigatorKey.currentContext!, HighLowPEIndex.path);
    },
  ),
  DrawerRes(
    iconData: Icons.pending_actions_rounded,
    text: "52 Weeks",
    onTap: () {
      Navigator.pushNamed(
          navigatorKey.currentContext!, FiftyTwoWeeksIndex.path);
    },
  ),
  DrawerRes(
    iconData: Icons.pending_actions_rounded,
    text: "Highs & Lows Beta stocks",
    onTap: () {
      Navigator.pushNamed(
          navigatorKey.currentContext!, HighLowsBetaStocksIndex.path);
    },
  ),
  DrawerRes(
    iconData: Icons.graphic_eq_outlined,
    text: "Indices",
    onTap: () {
      Navigator.pushNamed(
        navigatorKey.currentContext!,
        IndicesIndex.path,
      );
    },
  ),
  DrawerRes(
    iconData: Icons.price_change_outlined,
    text: "Low prices stocks",
    onTap: () {
      Navigator.pushNamed(
        navigatorKey.currentContext!,
        LowPriceStocksIndex.path,
      );
    },
  ),
  DrawerRes(
    iconData: Icons.mode_standby_sharp,
    text: "Most Active",
  ),
  // DrawerRes(
  //   iconData: Icons.bar_chart_sharp,
  //   text: "Options",
  // ),
  DrawerRes(
    iconData: Icons.stacked_line_chart_outlined,
    text: "Penny Stocks",
    onTap: () => Navigator.pushNamed(
      navigatorKey.currentContext!,
      PennyStocks.path,
    ),
  ),
  // DrawerRes(
  //   iconData: Icons.settings_input_composite_rounded,
  //   text: "Sector Performance",
  // ),
  // DrawerRes(
  //   iconData: Icons.interests_outlined,
  //   text: "Short Interest",
  // ),
  DrawerRes(
    iconData: Icons.content_paste_go_rounded,
    text: "Congressional Data",
    onTap: () {
      Navigator.pushNamed(
          navigatorKey.currentContext!, CongressionalIndex.path);
    },
  ),
  DrawerRes(
    iconData: Icons.safety_divider_rounded,
    text: "Dividends",
  ),
  DrawerRes(
    iconData: Icons.money,
    text: "Earnings",
  ),
  DrawerRes(
    iconData: Icons.newspaper_rounded,
    text: "Blogs",
    onTap: () {
      Navigator.pushNamed(
        navigatorKey.currentContext!,
        IndexBlog.path,
      );
    },
  ),
  DrawerRes(
    iconData: Icons.stacked_line_chart_outlined,
    text: "Stocks",
    onTap: () {
      Navigator.pushNamed(navigatorKey.currentContext!, StocksIndex.path);
    },
  ),
  DrawerRes(
    iconData: Icons.screen_search_desktop_outlined,
    text: "Stock Screener",
  ),
];

List<DrawerRes> researchTools = [
  DrawerRes(
    iconData: Icons.calendar_month_outlined,
    text: "All Access Tools",
  ),
  DrawerRes(
    iconData: Icons.data_exploration_outlined,
    text: "My Market Beat",
  ),
  DrawerRes(
    iconData: Icons.currency_bitcoin,
    text: "Calculators",
  ),
  DrawerRes(
    iconData: Icons.currency_yen_outlined,
    text: "Research Tools",
  ),
  DrawerRes(
    iconData: Icons.precision_manufacturing_outlined,
    text: "Stocks Screeners",
  ),
  DrawerRes(
    iconData: Icons.pending_actions_rounded,
    text: "Top-Rated Analysts",
  ),
  DrawerRes(
    iconData: Icons.pending_actions_rounded,
    text: "Trending Stocks",
  ),
  DrawerRes(
    iconData: Icons.pending_actions_rounded,
    text: "Premium Reports",
  ),
];

List<DrawerRes> financialCalendar = [
  DrawerRes(
    iconData: Icons.calendar_month_outlined,
    text: "Calendars",
  ),
  DrawerRes(
    iconData: Icons.data_exploration_outlined,
    text: "Analyst Ratings",
  ),
  DrawerRes(
    iconData: Icons.currency_bitcoin,
    text: "Corporate Events",
  ),
  DrawerRes(
    iconData: Icons.currency_yen_outlined,
    text: "Insider Trades",
  ),
  DrawerRes(
    iconData: Icons.precision_manufacturing_outlined,
    text: "Market Holidays",
  ),
];

List<DrawerRes> stockList = [
  DrawerRes(
    iconData: Icons.calendar_month_outlined,
    text: "All Stock List",
  ),
  DrawerRes(
    iconData: Icons.data_exploration_outlined,
    text: "Stock by Interest",
  ),
  DrawerRes(
    iconData: Icons.currency_bitcoin,
    text: "Technical Indicators",
  ),
  DrawerRes(
    iconData: Icons.currency_yen_outlined,
    text: "Stock by Sectors",
  ),
  DrawerRes(
    iconData: Icons.precision_manufacturing_outlined,
    text: "Stock Comparisons",
  ),
  DrawerRes(
    iconData: Icons.precision_manufacturing_outlined,
    text: "Premium Stock Lists",
  ),
];

List<DrawerRes> headlines = [
  DrawerRes(
    iconData: Icons.calendar_month_outlined,
    text: "Stock TV",
  ),
  DrawerRes(
    iconData: Icons.data_exploration_outlined,
    text: "Featured Articles",
  ),
  DrawerRes(
    iconData: Icons.currency_bitcoin,
    text: "News",
  ),
];

List<DrawerRes> learn = [
  DrawerRes(
    iconData: Icons.calendar_month_outlined,
    text: "Learn",
  ),
  DrawerRes(
    iconData: Icons.data_exploration_outlined,
    text: "Stock Ideas",
  ),
  DrawerRes(
    iconData: Icons.currency_bitcoin,
    text: "Financial Terms",
  ),
  DrawerRes(
    iconData: Icons.currency_bitcoin,
    text: "Help",
  ),
];

// 0: StocksIndex.path,

// 1:,
// 2: IndexBlog.path,
// 3: TCandPolicy.path,
// 4: WhatWeDoIndex.path,
// 5: ContactUs.path,
// 6: FAQ.path,

List<DrawerRes> aboutTiles = [
  DrawerRes(
    iconData: Icons.person_2_outlined,
    text: "My Profile",
    onTap: () {
      Navigator.pushNamed(navigatorKey.currentContext!, MyAccount.path);
    },
  ),
  DrawerRes(
    iconData: Icons.list_alt_rounded,
    text: "About Stocks.news",
    onTap: () {
      Navigator.pushNamed(navigatorKey.currentContext!, TCandPolicy.path,
          arguments: PolicyType.aboutUs);
    },
  ),
  DrawerRes(
    iconData: Icons.featured_play_list_outlined,
    text: "What we do",
    onTap: () {
      Navigator.pushNamed(navigatorKey.currentContext!, WhatWeDoIndex.path);
    },
  ),
  DrawerRes(
    iconData: Icons.mail_outline_sharp,
    text: "Contact Us",
    onTap: () {
      Navigator.pushNamed(navigatorKey.currentContext!, ContactUs.path);
    },
  ),
  DrawerRes(
    iconData: Icons.help_outline_rounded,
    text: "FAQ",
    onTap: () {
      Navigator.pushNamed(navigatorKey.currentContext!, FAQ.path);
    },
  ),
];

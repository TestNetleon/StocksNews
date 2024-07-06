import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/drawer_res.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/help/help_desk.dart';
import 'package:stocks_news_new/screens/marketData/congressionalData/index.dart';
import 'package:stocks_news_new/screens/marketData/dividends/dividends.dart';
import 'package:stocks_news_new/screens/marketData/earnings/earnings.dart';
import 'package:stocks_news_new/screens/marketData/fiftyTwoWeeks/index.dart';
import 'package:stocks_news_new/screens/marketData/gainersLosers/index.dart';
import 'package:stocks_news_new/screens/marketData/gapUpDown/index.dart';
import 'package:stocks_news_new/screens/marketData/highLowPE/index.dart';
import 'package:stocks_news_new/screens/marketData/highsLowsBetaStocks/index.dart';
import 'package:stocks_news_new/screens/marketData/indices/index.dart';
import 'package:stocks_news_new/screens/marketData/lowPriceStocks/index.dart';
import 'package:stocks_news_new/screens/marketData/mostActive/index.dart';
import 'package:stocks_news_new/screens/marketData/pennyStocks/index.dart';
import 'package:stocks_news_new/screens/membership/index.dart';
import 'package:stocks_news_new/screens/morningstarTranscations/morningstar_txn.dart';
import 'package:stocks_news_new/screens/myAccount/my_account.dart';
import 'package:stocks_news_new/screens/stocks/index.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/plaid/portfolio/index.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';

import '../../blogNew/blogsNew/index.dart';
import '../../faq/index.dart';
import '../../t&cAndPolicy/tc_policy.dart';
import '../../whatWeDo/index.dart';

List<DrawerRes> marketData = [
  // DrawerRes(
  //   iconData: Icons.calendar_month_outlined,
  //   text: "Calendar",
  // ),
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
    icon: Images.gainerLoser,
    text: "Gainers & Losers",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => const GainersLosersIndex(type: StocksType.gainers),
        ),
      );
    },
  ),
  DrawerRes(
    iconData: Icons.precision_manufacturing_outlined,
    icon: Images.feedback,
    text: "Gap Up/Down Stocks",
    onTap: () => Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const GapUpDownStocks()),
    ),
  ),
  DrawerRes(
    iconData: Icons.pending_actions_rounded,
    icon: Images.insider,
    text: "Insider Trades",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => const Tabs(index: 2),
        ),
      );
    },
  ),
  DrawerRes(
    iconData: Icons.pending_actions_rounded,
    icon: Images.performance,
    text: "Market Sentiment",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => const Tabs(index: 3),
        ),
      );
    },
  ),
  DrawerRes(
    iconData: Icons.pending_actions_rounded,
    text: "High & Low PE",
    icon: Images.highPE,
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const HighLowPEIndex()),
      );
    },
  ),
  DrawerRes(
    iconData: Icons.pending_actions_rounded,
    icon: Images.week,
    text: "52 Weeks",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const FiftyTwoWeeksIndex()),
      );
    },
  ),
  DrawerRes(
    iconData: Icons.pending_actions_rounded,
    icon: Images.exchange,
    text: "Highs & Lows Beta Stocks",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const HighLowsBetaStocksIndex()),
      );
    },
  ),
  DrawerRes(
    iconData: Icons.graphic_eq_outlined,
    icon: Images.indices,
    text: "Indices",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const IndicesIndex()),
      );
    },
  ),
  DrawerRes(
    iconData: Icons.price_change_outlined,
    icon: Images.discount,
    text: "Low Prices Stocks",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const LowPriceStocksIndex()),
      );
    },
  ),
  DrawerRes(
    iconData: Icons.mode_standby_sharp,
    icon: Images.activities,
    text: "Most Active",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const MostActiveIndex()),
      );
    },
  ),
  // DrawerRes(
  //   iconData: Icons.bar_chart_sharp,
  //   text: "Options",
  // ),
  DrawerRes(
    iconData: Icons.stacked_line_chart_outlined,
    icon: Images.penny,
    text: "Penny Stocks",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const PennyStocks()),
      );
    },
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
    icon: Images.advisor,
    text: "Congressional Data",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const CongressionalIndex()),
      );
    },
  ),
  DrawerRes(
    iconData: Icons.safety_divider_rounded,
    icon: Images.dividends,
    text: "Dividends",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const DividendsScreen()),
      );
    },
  ),
  DrawerRes(
    iconData: Icons.money,
    icon: Images.earnings,
    text: "Earnings",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const EarningsScreen()),
      );
    },
  ),
  DrawerRes(
    iconData: Icons.newspaper_rounded,
    icon: Images.blogging,
    text: "Blogs",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const BlogIndexNew()),
      );
    },
  ),
  DrawerRes(
    iconData: Icons.stacked_line_chart_outlined,
    icon: Images.technical,
    text: "Stocks",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const StocksIndex()),
      );
    },
  ),
  // DrawerRes(
  //   iconData: Icons.screen_search_desktop_outlined,
  //   text: "Stock Screener",
  //   onTap: () {
  //     Navigator.push(
  //         navigatorKey.currentContext!, StockScreenerScreen.path);
  //   },
  // ),
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
    text: "My Account",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const MyAccount()),
      );
    },
  ),
  DrawerRes(
    iconData: Icons.wallet_membership,
    text: "My Membership",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const MembershipIndex()),
      );
    },
  ),
  DrawerRes(
    iconData: Icons.person_pin_outlined,
    text: "Portfolio",
    onTap: () {
      // Navigator.push(navigatorKey.currentContext!, HomePlaidAdded.path);
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const HomePlaidAdded()),
      );
    },
  ),
  DrawerRes(
    iconData: Icons.leaderboard_outlined,
    text: "Refer and Earn",
    onTap: () {
      // Navigator.push(navigatorKey.currentContext!, ReferAFriend.path);
    },
  ),
  DrawerRes(
    iconData: Icons.list_alt_rounded,
    text: "About Stocks.News",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) {
          return const TCandPolicy(
            slug: "about-us",
            policyType: PolicyType.aboutUs,
          );
        }),
      );
    },
  ),
  // DrawerRes(
  //   iconData: Icons.list_alt_rounded,
  //   text: "ReferAFriendNew",
  //   onTap: () {
  //     Navigator.push(
  //       navigatorKey.currentContext!,
  //       MaterialPageRoute(builder: (_) => const ReferFriendNew()),
  //     );
  //   },
  // ),
  DrawerRes(
    iconData: Icons.library_books_sharp,
    text: "Morningstar Reports",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const MorningStarTransaction()),
      );
    },
  ),
  // DrawerRes(
  //   iconData: Icons.list_alt_rounded,
  //   text: "Mission",
  //   onTap: () {
  //     Navigator.push(
  //       navigatorKey.currentContext!,
  //       MaterialPageRoute(builder: (_) => const MissionsScreen()),
  //     );
  //   },
  // ),
  DrawerRes(
    iconData: Icons.featured_play_list_outlined,
    text: "What We Do",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const WhatWeDoIndex()),
      );
    },
  ),
  // DrawerRes(
  //   iconData: Icons.mail_outline_sharp,
  //   text: "Contact Us",
  //   onTap: () {
  //     Navigator.push(
  //       navigatorKey.currentContext!,
  //       MaterialPageRoute(builder: (_) => const ContactUs()),
  //     );
  //   },
  // ),
  DrawerRes(
    iconData: Icons.support_agent,
    text: "Helpdesk",
    onTap: () {
      // UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;
      // log("1");
      // if (user == null) {
      //   isPhone ? await loginSheet() : await loginSheetTablet();
      // }

      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const HelpDesk()),
      );
      // log("3");
    },
  ),
  // DrawerRes(
  //   iconData: Icons.support_agent,
  //   text: "Deep Links",
  //   onTap: () {
  //     Navigator.push(
  //       navigatorKey.currentContext!,
  //       MaterialPageRoute(builder: (_) => const Deeplinks()),
  //     );
  //   },
  // ),
  DrawerRes(
    iconData: Icons.help_outline_rounded,
    text: "FAQ",
    onTap: () {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const FAQ()),
      );
    },
  ),
];

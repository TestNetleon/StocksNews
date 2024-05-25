// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/insider_trading_provider.dart';
import 'package:stocks_news_new/providers/news_provider.dart';
import 'package:stocks_news_new/providers/reddit_twitter_provider.dart';
import 'package:stocks_news_new/providers/search_provider.dart';
import 'package:stocks_news_new/providers/trending_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer_copy.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/compare_stocks.dart';
import 'package:stocks_news_new/screens/tabs/home/home.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/insider/insider.dart';
import 'package:stocks_news_new/screens/tabs/news/news.dart';
import 'package:stocks_news_new/screens/tabs/reddit_twitter/reddit_twitter.dart';
import 'package:stocks_news_new/screens/tabs/trending/trending.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import 'package:vibration/vibration.dart';

import '../drawer/base_drawer.dart';
import '../drawer/base_drawer_copy.dart';

class Tabs extends StatefulWidget {
  static const String path = "Tabs";
  final int index;
  final String? inAppMsgId;
  const Tabs({super.key, this.index = 0, this.inAppMsgId});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _selectedIndex = 0;
  bool userPresent = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _selectedIndex = widget.index;
        activeContainerApiCalls(currentIndex: _selectedIndex);
      });
    });
  }

  BottomNavigationBarItem bottomTab({icon, lable}) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 3.sp),
        child: Icon(
          icon,
          size: 23,
        ),
      ),
      label: lable,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvoked: (isPop) {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
        }
      },
      child: BaseContainer(
        appBar: const AppBarHome(
          canSearch: true,
          showTrailing: true,
        ),
        drawer: const BaseDrawer(),
        body: Screens.screens.elementAt(_selectedIndex),

        //  _selectedIndex == 0
        //     ? const Home()
        //     : _selectedIndex == 1
        //         ? const Trending()
        //         : _selectedIndex == 2
        //             ? const Insider()
        //             : _selectedIndex == 3
        //                 ? const RedditTwitter()
        //                 : _selectedIndex == 4
        //                     ? const WatchList()
        //                     : const News(),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: ThemeColors.white,
          selectedItemColor: ThemeColors.accent,
          // backgroundColor: ThemeColors.tabBack,
          backgroundColor: ThemeColors.transparent,

          showUnselectedLabels: true,
          showSelectedLabels: true,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          unselectedLabelStyle:
              stylePTSansBold(color: ThemeColors.white, fontSize: 11),
          selectedLabelStyle:
              stylePTSansBold(color: ThemeColors.accent, fontSize: 11),
          onTap: (index) {
            context.read<SearchProvider>().clearSearch();
            if (_selectedIndex != index) {
              setState(() {
                _selectedIndex = index;
                activeContainerApiCalls(currentIndex: index);
              });
            }
          },
          items: [
            bottomTab(icon: Icons.home, lable: "Home"),
            bottomTab(icon: Icons.fireplace_outlined, lable: "Trending"),
            bottomTab(icon: Icons.trending_up_sharp, lable: "Insider"),
            bottomTab(
                icon: Icons.alternate_email_outlined, lable: "Sentiments"),
            // bottomTab(icon: Icons.trending_up_sharp, lable: "Watchlist"),
            bottomTab(icon: Icons.newspaper_rounded, lable: "News"),
            bottomTab(icon: Icons.compare_arrows, lable: "Compare"),
          ],
        ),
      ),
    );
  }

  void activeContainerApiCalls({required int currentIndex}) async {
    final trendingProvider = context.read<TrendingProvider>();
    final insiderProvider = context.read<InsiderTradingProvider>();
    final redditTwitterProvider = context.read<RedditTwitterProvider>();
    final newsCatProvider = context.read<NewsCategoryProvider>();
    // final newsProvider = context.read<FeaturedNewsProvider>();
    // final latestNewsProvider = context.read<NewsProvider>();

    if (Platform.isAndroid) {
      bool isVibe = await Vibration.hasVibrator() ?? false;
      if (isVibe) {
        Vibration.vibrate(pattern: [50, 50, 79, 55], intensities: [1, 10]);
      }
    } else {
      // Vibration.vibrate(pattern: [0, 500], intensities: [1, 10]);
      HapticFeedback.lightImpact();
    }

    // switch (currentIndex) {
    //   case 0:
    //     homeProvider.getHomeData();
    //     break;
    //   case 1:
    //     trendingProvider.getData();
    //     break;
    //   case 2:
    //     insiderProvider.getData(showProgress: true);
    //     break;
    //   case 3:
    //     redditTwitterProvider.getRedditTwitterData(reset: true);
    //     break;
    //   case 4:
    //     _watchList(context);
    //     break;
    //   case 5:
    //     newsProvider.getNews(showProgress: true);
    //     break;
    //   case 6:
    //     _compareStocks(context);
    //     break;
    // }

    switch (currentIndex) {
      case 0:
        _home(context, widget.inAppMsgId);
        break;
      case 1:
        if (trendingProvider.mostBullish == null) {
          trendingProvider.getMostBullish();
        }
        break;
      case 2:
        if (insiderProvider.data == null) {
          insiderProvider.getData(showProgress: false);
        }
        break;
      case 3:
        if (redditTwitterProvider.socialSentimentRes == null) {
          redditTwitterProvider.getRedditTwitterData(reset: true);
        }
        break;
      case 4:
        if (newsCatProvider.tabs == null) {
          newsCatProvider.getTabsData(showProgress: true);
        } else {
          newsCatProvider.tabChange(0, newsCatProvider.tabs![0].id);
        }
        break;
      case 5:
        _compareStocks(context);
        break;
    }
  }
}

void _home(BuildContext context, String? inAppMsgId) async {
  final HomeProvider homeProvider = context.read<HomeProvider>();
  if (homeProvider.homeSliderRes == null &&
      homeProvider.homeAlertData == null &&
      homeProvider.homeTrendingRes == null) {
    homeProvider.refreshData(inAppMsgId);
  }
  // homeProvider.getHomeData();
  // homeProvider.getHomeNewData();
}

void _compareStocks(BuildContext context) {
  UserProvider provider = context.read<UserProvider>();
  final compareProvider = context.read<CompareStocksProvider>();

  if (provider.user != null && compareProvider.company.isEmpty) {
    compareProvider.getCompareStock();
  }
}

class Screens {
  static List<Widget> screens = <Widget>[
    const Home(),
    const Trending(),
    const Insider(),
    const RedditTwitter(),
    // const WatchList(),
    const News(),
    const CompareStocks(),
  ];
}

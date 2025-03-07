// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
// import 'package:stocks_news_new/providers/home_provider.dart';
// import 'package:stocks_news_new/providers/insider_trading_provider.dart';
// import 'package:stocks_news_new/providers/news_provider.dart';
// import 'package:stocks_news_new/providers/reddit_twitter_provider.dart';
// import 'package:stocks_news_new/providers/search_provider.dart';
// import 'package:stocks_news_new/providers/trending_provider.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/routes/my_app.dart';
// import 'package:stocks_news_new/screens/auth/refer/refer_code.dart';
// import 'package:stocks_news_new/screens/tabs/compareStocks/compare_stocks.dart';
// import 'package:stocks_news_new/screens/tabs/home/home.dart';
// import 'package:stocks_news_new/screens/tabs/insider/insider.dart';
// import 'package:stocks_news_new/screens/tabs/news/news.dart';
// import 'package:stocks_news_new/screens/tabs/reddit_twitter/reddit_twitter.dart';
// import 'package:stocks_news_new/screens/tabs/trending/trending.dart';
// import 'package:stocks_news_new/service/amplitude/service.dart';
// import 'package:stocks_news_new/service/revenue_cat.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:vibration/vibration.dart';
// import '../../api/api_response.dart';
// import '../../utils/utils.dart';
// import '../offerMembership/blackFriday/scanner.dart';
// import '../offerMembership/christmas/scanner.dart';

// class Tabs extends StatefulWidget {
//   static const String path = "Tabs";
//   final int index;
//   final String? inAppMsgId;
//   final bool showRef;
//   final bool showMembership;
//   final int trendingIndex;

//   const Tabs({
//     super.key,
//     this.index = 0,
//     this.inAppMsgId,
//     this.showRef = false,
//     this.showMembership = false,
//     this.trendingIndex = 0,
//   });

//   @override
//   State<Tabs> createState() => _TabsState();
// }

// class _TabsState extends State<Tabs> {
//   int _selectedIndex = 0;
//   bool userPresent = false;

//   @override
//   void initState() {
//     super.initState();
//     splashLoaded = true;
//     // _request();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       setState(() {
//         _selectedIndex = widget.index;
//         activeContainerApiCalls(currentIndex: _selectedIndex);
//       });
//       //Because we are asking membership thats why hiding refer
//       if (widget.showRef) referLogin();
//       if (widget.showMembership) _showMembership();
//       // appTrack();
//       AmplitudeService.logFirstOpenEvent();
//     });
//   }

//   // Future _request() async {
//   //   await Future.delayed(Duration(seconds: 8));
//   //   await requestATT();
//   // }

//   _showMembership() {
//     // Navigator.push(
//     //   context,
//     //   createRoute(
//     //     NewMembership(cancel: true),
//     //   ),
//     // );

//     // UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;
//     Extra? extra = navigatorKey.currentContext!.read<HomeProvider>().extra;

//     closeKeyboard();
//     if (extra?.showBlackFriday == true) {
//       Navigator.push(
//         navigatorKey.currentContext!,
//         createRoute(
//           const BlackFridayMembershipIndex(cancel: true),
//         ),
//       );
//     } else if (extra?.christmasMembership == true ||
//         extra?.newYearMembership == true) {
//       Navigator.push(
//         navigatorKey.currentContext!,
//         createRoute(
//           const ChristmasMembershipIndex(),
//         ),
//       );
//     } else {
//       subscribe();
//       // Navigator.push(
//       //   navigatorKey.currentContext!,
//       //   createRoute(
//       //     const NewMembership(cancel: true),
//       //   ),
//       // );
//     }
//   }

//   BottomNavigationBarItem bottomTab({icon, lable}) {
//     return BottomNavigationBarItem(
//       icon: Padding(
//         padding: EdgeInsets.only(bottom: 3.sp),
//         child: Icon(
//           icon,
//           size: 23,
//         ),
//       ),
//       label: lable,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBarHome(
//       //   canSearch: true,
//       //   showTrailing: true,
//       //   isHome: _selectedIndex == 0,
//       // ),
//       // drawer: const BaseDrawer(),
//       body: Screens.screens(widget.trendingIndex).elementAt(_selectedIndex),
//       bottomNavigationBar: BottomNavigationBar(
//         unselectedItemColor: ThemeColors.white,
//         selectedItemColor: ThemeColors.accent,
//         // backgroundColor: ThemeColors.tabBack,
//         backgroundColor: ThemeColors.transparent,
//         showUnselectedLabels: true,
//         showSelectedLabels: true,
//         currentIndex: _selectedIndex,
//         type: BottomNavigationBarType.fixed,
//         unselectedLabelStyle:
//             stylePTSansBold(color: ThemeColors.white, fontSize: 11),
//         selectedLabelStyle:
//             stylePTSansBold(color: ThemeColors.accent, fontSize: 11),
//         onTap: (index) {
//           context.read<SearchProvider>().clearSearch();
//           if (_selectedIndex != index) {
//             setState(() {
//               _selectedIndex = index;
//               activeContainerApiCalls(currentIndex: index);
//             });
//           }
//         },
//         items: [
//           bottomTab(icon: Icons.home, lable: "Home"),
//           bottomTab(icon: Icons.fireplace_outlined, lable: "Trending"),
//           bottomTab(icon: Icons.trending_up_sharp, lable: "Insider"),
//           bottomTab(icon: Icons.alternate_email_outlined, lable: "Sentiments"),
//           bottomTab(icon: Icons.newspaper_rounded, lable: "News"),
//           bottomTab(icon: Icons.compare_arrows, lable: "Compare"),
//         ],
//       ),
//     );
//   }

//   void activeContainerApiCalls({required int currentIndex}) async {
//     final trendingProvider = context.read<TrendingProvider>();
//     final insiderProvider = context.read<InsiderTradingProvider>();
//     final redditTwitterProvider = context.read<RedditTwitterProvider>();
//     final newsCatProvider = context.read<NewsCategoryProvider>();
//     // final homeProvider = context.read<HomeProvider>();
//     // homeProvider.callMaintenance();

//     try {
//       if (Platform.isAndroid) {
//         bool isVibe = await Vibration.hasVibrator();
//         if (isVibe) {
//           Vibration.vibrate(pattern: [50, 50, 79, 55], intensities: [1, 10]);
//         }
//       } else {
//         HapticFeedback.lightImpact();
//       }
//     } catch (e) {
//       log('$e');
//     }

//     switch (currentIndex) {
//       case 0:
//         final HomeProvider homeProvider = context.read<HomeProvider>();
//         if (homeProvider.homeSliderRes == null &&
//             homeProvider.homeAlertData == null &&
//             homeProvider.homeTrendingRes == null) {
//           homeProvider.refreshData(widget.inAppMsgId);
//         }
//         // AmplitudeService.logUserInteractionEvent(type: "Stocks.News Home Page");

//         break;
//       case 1:
//         if (trendingProvider.mostBullish == null) {
//           trendingProvider.getMostBullish();
//         }
//         // AmplitudeService.logUserInteractionEvent(type: "Trending");

//         break;
//       case 2:
//         if (insiderProvider.data == null) {
//           insiderProvider.getData(showProgress: false);
//         }
//         // AmplitudeService.logUserInteractionEvent(type: "Insider Trades");

//         break;
//       case 3:
//         if (redditTwitterProvider.socialSentimentRes == null) {
//           redditTwitterProvider.getRedditTwitterData(reset: true);
//         }
//         // AmplitudeService.logUserInteractionEvent(type: "Market Sentiment");

//         break;
//       case 4:
//         if (newsCatProvider.tabs == null) {
//           newsCatProvider.getTabsData(showProgress: true);
//         } else {
//           newsCatProvider.tabChange(0, newsCatProvider.tabs![0].id);
//         }
//         // AmplitudeService.logUserInteractionEvent(type: "News");

//         break;
//       case 5:
//         log("---Compare");
//         _compareStocks(context);
//         break;
//     }
//   }
// }

// void _compareStocks(BuildContext context) {
//   UserProvider provider = context.read<UserProvider>();
//   final compareProvider = context.read<CompareStocksProvider>();
//   if (provider.user != null && compareProvider.company.isEmpty) {
//     compareProvider.getCompareStock();
//   }
//   // AmplitudeService.logUserInteractionEvent(type: 'Compare Stocks');
// }

// class Screens {
//   static List<Widget> screens(int? trendingIndex) {
//     return <Widget>[
//       const Home(),
//       Trending(index: trendingIndex ?? 0),
//       const Insider(),
//       const RedditTwitter(),
//       const News(),
//       const CompareStocks(),
//     ];
//   }
// }

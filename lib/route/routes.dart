import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stocks_news_new/modals/news_datail_res.dart';
import 'package:stocks_news_new/providers/alert_provider.dart';
import 'package:stocks_news_new/providers/all_stocks_provider.dart';
import 'package:stocks_news_new/providers/blog_provider.dart';
import 'package:stocks_news_new/providers/blog_provider_new.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/providers/congressional_detail_provider.dart';
import 'package:stocks_news_new/providers/congressional_provider.dart';
import 'package:stocks_news_new/providers/contact_us_provider.dart';
import 'package:stocks_news_new/providers/dividends_provider.dart';
import 'package:stocks_news_new/providers/dow_30_provider.dart';
import 'package:stocks_news_new/providers/earnings_provider.dart';
import 'package:stocks_news_new/providers/faq_provider.dart';
import 'package:stocks_news_new/providers/fifty_two_weeks_provider.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/gap_down_provider.dart';
import 'package:stocks_news_new/providers/gap_up_provider.dart';
import 'package:stocks_news_new/providers/high_beta_stocks_providers.dart';
import 'package:stocks_news_new/providers/high_pe_growth_provider.dart';
import 'package:stocks_news_new/providers/high_pe_provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/insider_trading_company_provider.dart';
import 'package:stocks_news_new/providers/insider_trading_provider.dart';
import 'package:stocks_news_new/providers/indices_provider.dart';
import 'package:stocks_news_new/providers/low_pe_growth_provider.dart';
import 'package:stocks_news_new/providers/low_pe_provider.dart';
import 'package:stocks_news_new/providers/low_beta_stocks_providers.dart';
import 'package:stocks_news_new/providers/more_stocks_provider.dart';
import 'package:stocks_news_new/providers/most_active_provider.dart';
import 'package:stocks_news_new/providers/most_popular_penny_provider.dart';
import 'package:stocks_news_new/providers/snp_500_provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/providers/today_breackout_stocks_provider.dart';
import 'package:stocks_news_new/providers/today_top_loser_provider.dart';
import 'package:stocks_news_new/providers/unusual_trading_volume_provider.dart';
import 'package:stocks_news_new/providers/most_volatile_stocks.dart';
import 'package:stocks_news_new/providers/negative_beta_stocks_providers.dart';
import 'package:stocks_news_new/providers/news_detail.provider.dart';
import 'package:stocks_news_new/providers/news_provider.dart';
import 'package:stocks_news_new/providers/notification_provider.dart';
import 'package:stocks_news_new/providers/most_active_penny_stocks_provider.dart';
import 'package:stocks_news_new/providers/plaid.dart';
import 'package:stocks_news_new/providers/reddit_twitter_provider.dart';
import 'package:stocks_news_new/providers/search_provider.dart';
import 'package:stocks_news_new/providers/sector_industry_provider.dart';
import 'package:stocks_news_new/providers/stock_screener_provider.dart';
import 'package:stocks_news_new/providers/terms_policy_provider.dart';
import 'package:stocks_news_new/providers/today_top_gainer_provider.dart';
import 'package:stocks_news_new/providers/top_today_penny_stocks_provider.dart';
import 'package:stocks_news_new/providers/top_trending_provider.dart';
import 'package:stocks_news_new/providers/trending_provider.dart';
//
import 'package:stocks_news_new/providers/user_provider.dart';

import 'package:provider/provider.dart';

import 'package:provider/single_child_widget.dart';
import 'package:stocks_news_new/providers/watchlist_provider.dart';
import 'package:stocks_news_new/providers/what_we_do_provider.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/auth/qrScan/index.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_success.dart';
import 'package:stocks_news_new/screens/blogDetail/index.dart';
import 'package:stocks_news_new/screens/blogNew/blogsNew/index.dart';
import 'package:stocks_news_new/screens/blogs/index.dart';
import 'package:stocks_news_new/screens/contactUs/contact_us.dart';
import 'package:stocks_news_new/screens/drawerScreens/congressionDetail/index.dart';
import 'package:stocks_news_new/screens/drawerScreens/dividends/dividends.dart';
import 'package:stocks_news_new/screens/drawerScreens/earnings/earnings.dart';
import 'package:stocks_news_new/screens/drawerScreens/fiftyTwoWeeks/index.dart';
import 'package:stocks_news_new/screens/drawerScreens/gainersLosers/index.dart';
import 'package:stocks_news_new/screens/drawerScreens/gapUpDown/index.dart';
import 'package:stocks_news_new/screens/drawerScreens/highLowPE/index.dart';
import 'package:stocks_news_new/screens/drawerScreens/highsLowsBetaStocks/index.dart';
import 'package:stocks_news_new/screens/drawerScreens/indices/index.dart';
import 'package:stocks_news_new/screens/drawerScreens/mostActive/index.dart';
import 'package:stocks_news_new/screens/drawerScreens/pennyStocks/index.dart';
import 'package:stocks_news_new/screens/drawerScreens/stockScreener/stock_screener.dart';
import 'package:stocks_news_new/screens/faq/index.dart';
import 'package:stocks_news_new/screens/homeSpash/index.dart';
import 'package:stocks_news_new/screens/myAccount/my_account.dart';
import 'package:stocks_news_new/screens/notifications/index.dart';
import 'package:stocks_news_new/screens/search/search.dart';
import 'package:stocks_news_new/screens/splash/splash.dart';
import 'package:stocks_news_new/screens/start/index.dart';
import 'package:stocks_news_new/screens/stockDetail/index.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/sectorIndustry/sector_industry.dart';
import 'package:stocks_news_new/screens/stocks/index.dart';
import 'package:stocks_news_new/screens/t&cAndPolicy/tc_policy.dart';
import 'package:stocks_news_new/screens/tabs/compareNew/index.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/compare_stocks.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/plaid/portfolio/index.dart';
import 'package:stocks_news_new/screens/tabs/insider/insiderDetails/insider_details.dart';
import 'package:stocks_news_new/screens/tabs/news/newsAuthor/index.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/new_detail.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/screens/trendingIndustries/index.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import '../providers/featured_ticker.dart';
import '../providers/high_low_pe.dart';
import '../providers/low_prices_stocks.dart';
import '../providers/trending_industries.dart';
import '../screens/drawerScreens/congressionalData/index.dart';
import '../screens/drawerScreens/lowPriceStocks/index.dart';
import '../screens/whatWeDo/index.dart';

class Routes {
  static var routes = {
    Splash.path: (_) => const Splash(),
    // Login.path: (_) => const Login(),
    // SignUp.path: (_) => const SignUp(),
    // CreateAccount.path: (_) => const CreateAccount(),
    SignUpSuccess.path: (_) => const SignUpSuccess(),
    // Tabs.path: (_) => const Tabs(),
    // OTPSignup.path: (_) => const OTPSignup(),
    // OTPLogin.path: (_) => const OTPLogin(),
    Search.path: (_) => const Search(),
    FAQ.path: (_) => const FAQ(),
    Notifications.path: (_) => const Notifications(),
    Alerts.path: (_) => const Alerts(),
    WatchList.path: (_) => const WatchList(),
    LowPriceStocksIndex.path: (_) => const LowPriceStocksIndex(),
    CongressionalIndex.path: (_) => const CongressionalIndex(),
    StartIndex.path: (_) => const StartIndex(),
    MyAccount.path: (_) => const MyAccount(),
    ContactUs.path: (_) => const ContactUs(),
    CompareStocks.path: (_) => const CompareStocks(),
    QrScan.path: (_) => const QrScan(),
    // StocksIndex.path: (_) => const StocksIndex(),
    // IndexBlog.path: (_) => const IndexBlog(),
    TrendingIndustries.path: (_) => const TrendingIndustries(),
    HighLowPEIndex.path: (_) => const HighLowPEIndex(),
    FiftyTwoWeeksIndex.path: (_) => const FiftyTwoWeeksIndex(),
    HighLowsBetaStocksIndex.path: (_) => const HighLowsBetaStocksIndex(),
    IndicesIndex.path: (_) => const IndicesIndex(),
    MostActiveIndex.path: (_) => const MostActiveIndex(),
    WhatWeDoIndex.path: (_) => const WhatWeDoIndex(),
    HomeSplash.path: (_) => const HomeSplash(),

    // ServerErrorWidget.path: (_) => const ServerErrorWidget(),
    // InternetErrorWidget.path: (_) => const InternetErrorWidget(),
    DividendsScreen.path: (_) => const DividendsScreen(),
    CompareNew.path: (_) => const CompareNew(),
    EarningsScreen.path: (_) => const EarningsScreen(),
    StockScreenerScreen.path: (_) => const StockScreenerScreen(),
    HomePlaidAdded.path: (_) => const HomePlaidAdded(),
  };

  static Route bottomToTopScreenRoute(widget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionDuration: const Duration(seconds: 1),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  static Route getRouteGenerate(RouteSettings settings) {
    var routingData = settings.name;
    log("GENERATED ROUT ***=> $settings");
    log("GENERATED ROUT ***=> ${isValidUrl(routingData)}}");

    if (routingData != null && isValidUrl(routingData)) {
      Uri? uri = Uri.tryParse(routingData);
      if (uri != null) {
        return handleDeepLink(uri);
      }
    }
    bool isReferral = routingData?.contains("page.link") ??
        routingData?.contains("/install") ??
        false;

    if (isReferral) {
      return MaterialWithModalsPageRoute(
        builder: (context) {
          return const Splash();
        },
      );
    }

    Utils().showLog(
      "=> ${settings.arguments}, \n${jsonEncode(settings.arguments.toString())}",
    );

    switch (routingData) {
      case TCandPolicy.path:
        return MaterialWithModalsPageRoute(
          builder: (context) {
            return TCandPolicy(policyType: settings.arguments as PolicyType);
          },
        );
      case StocksIndex.path:
        return MaterialWithModalsPageRoute(
          builder: (context) {
            return StocksIndex(inAppMsgId: settings.arguments as String?);
          },
        );
      case NewsDetails.path:
        return MaterialWithModalsPageRoute(
          builder: (context) {
            var data = settings.arguments as Map<String, dynamic>;
            return NewsDetails(
              slug: data['slug'],
              inAppMsgId: data['inAppMsgId'],
              notificationId: data['notificationId'],
            );
            // return NewsDetails(
            //   slug: settings.arguments["slug"],
            // );
          },
        );
      // case StockDetails.path:
      //   return MaterialWithModalsPageRoute(
      //     builder: (context) {
      //       final arguments = settings.arguments as Map<String, dynamic>?;
      //       return StockDetails(
      //         symbol: arguments!['slug'],
      //         inAppMsgId: arguments['inAppMsgId'],
      //         notificationId: arguments['notificationId'],
      //       );
      //       // return StockDetails(symbol: settings.arguments as String);
      //     },
      //   );
      case StockDetail.path:
        return MaterialWithModalsPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            return StockDetail(
              symbol: arguments!['slug'],
              inAppMsgId: arguments['inAppMsgId'],
              notificationId: arguments['notificationId'],
            );
            // return StockDetails(symbol: settings.arguments as String);
          },
        );
      // case StockDetailiFrameItem.path:
      //   return MaterialWithModalsPageRoute(
      //     builder: (context) {
      //       return StockDetailiFrameItem(
      //           type: settings.arguments as CommentType);
      //     },
      //   );
      case Blog.path:
        final arguments = settings.arguments as Map<String, dynamic>?;
        String? id = arguments?['id'] as String?;
        BlogsType? type = arguments?['type'] as BlogsType?;
        String? inAppMsgId = arguments?['inAppMsgId'] as String?;
        String? notificationId = arguments?['notificationId'] as String?;
        return MaterialWithModalsPageRoute(
          builder: (context) {
            return Blog(
              type: type ?? BlogsType.blog,
              id: id ?? "",
              inAppMsgId: inAppMsgId,
              notificationId: notificationId,
            );
          },
        );
      case BlogDetail.path:
        return MaterialWithModalsPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            return BlogDetail(
              slug: arguments!['slug'],
              inAppMsgId: arguments['inAppMsgId'],
              notificationId: arguments['notificationId'],
            );
          },
        );
      case Tabs.path:
        return MaterialWithModalsPageRoute(
          builder: (context) {
            return Tabs(index: (settings.arguments as int?) ?? 0);
          },
        );
      case NewsAuthorIndex.path:
        final arguments = settings.arguments as Map<String, dynamic>;

        DetailListType data = arguments["data"] as DetailListType;
        BlogsType type = arguments["type"] as BlogsType;
        return MaterialWithModalsPageRoute(
          builder: (context) {
            return NewsAuthorIndex(
              data: data,
              type: type,
            );
          },
        );
      case SectorIndustry.path:
        final arguments = settings.arguments as Map<String, dynamic>;
        StockStates type = arguments["type"] as StockStates;
        String name = arguments["name"] as String;
        String titleName = arguments["titleName"] as String;

        return MaterialWithModalsPageRoute(
          builder: (context) {
            return SectorIndustry(
              name: name,
              stockStates: type,
              titleName: titleName,
            );
          },
        );
      case GainersLosersIndex.path:
        final arguments = settings.arguments as Map<String, dynamic>;
        StocksType type = arguments["type"] as StocksType;
        return MaterialWithModalsPageRoute(
          builder: (context) {
            return GainersLosersIndex(type: type);
          },
        );
      case GapUpDownStocks.path:
        // final arguments = settings.arguments as Map<String, dynamic>;
        // StocksType type = arguments["type"] as StocksType;
        return MaterialWithModalsPageRoute(
          builder: (context) {
            return const GapUpDownStocks();
          },
        );
      case PennyStocks.path:
        // final arguments = settings.arguments as Map<String, dynamic>;
        // StocksType type = arguments["type"] as StocksType;
        return MaterialWithModalsPageRoute(
          builder: (context) {
            return const PennyStocks();
          },
        );
      case InsiderDetailsType.path:
        final arguments = settings.arguments as Map<String, dynamic>;
        final companySlug = arguments['companySlug'] as String?;
        final reportingSlug = arguments['reportingSlug'] as String?;

        final companyName = arguments['companyName'] as String?;
        final reportingName = arguments['reportingName'] as String?;

        return MaterialWithModalsPageRoute(
          builder: (context) {
            return InsiderDetailsType(
              companySlug: companySlug ?? "",
              reportingSlug: reportingSlug ?? "",
              companyName: companyName ?? "",
              reportingName: reportingName ?? "",
            );
          },
        );
      case BlogIndexNew.path:
        final arguments = settings.arguments as Map<String, dynamic>?;
        String? inAppMsgId = arguments?['inAppMsgId'] as String?;
        String? notificationId = arguments?['notificationId'] as String?;
        return MaterialWithModalsPageRoute(
          builder: (context) {
            return BlogIndexNew(
              inAppMsgId: inAppMsgId,
              notificationId: notificationId,
            );
          },
        );
      case CongressionalDetail.path:
        final arguments = settings.arguments as Map<String, dynamic>?;
        String slug = arguments?['slug'] as String;
        return MaterialWithModalsPageRoute(
          builder: (context) {
            return CongressionalDetail(slug: slug);
          },
        );
    }
    // return _errorRoute();
    return MaterialWithModalsPageRoute(
      builder: (context) {
        return const Splash();
      },
    );
  }

  static Route<dynamic> handleDeepLink(Uri uri) {
    String type = containsSpecificPath(uri);
    String slug = extractLastPathComponent(uri);

    switch (type) {
      case "blog":
        return MaterialWithModalsPageRoute(
          builder: (context) => BlogDetail(slug: slug),
        );
      case "news":
        return MaterialWithModalsPageRoute(
          builder: (context) => NewsDetails(slug: slug),
        );
      case "stock_detail":
        return MaterialPageRoute(
          builder: (context) => StockDetail(symbol: slug),
        );
      case "dashboard":
        return MaterialWithModalsPageRoute(builder: (context) => const Tabs());
      default:
        return MaterialPageRoute(
          builder: (context) => const Tabs(),
        );
    }
  }

  // static Route _errorRoute() {
  //   return MaterialWithModalsPageRoute(
  //       builder: (context) => BaseContainer(
  //             body: Center(
  //               child: Text(
  //                 "ERROR PAGE....",
  //                 style: stylePTSansBold(),
  //               ),
  //             ),
  //           ));
  // }

  static List<SingleChildWidget> get providers {
    return [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(create: (_) => SearchProvider()),
      ChangeNotifierProvider(create: (_) => NewsProvider()),
      ChangeNotifierProvider(create: (_) => TrendingProvider()),
      ChangeNotifierProvider(create: (_) => InsiderTradingProvider()),
      ChangeNotifierProvider(create: (_) => WatchlistProvider()),
      // ChangeNotifierProvider(create: (_) => StockDetailProvider()),
      ChangeNotifierProvider(create: (_) => InsiderTradingDetailsProvider()),
      ChangeNotifierProvider(create: (_) => RedditTwitterProvider()),
      ChangeNotifierProvider(create: (_) => CompareStocksProvider()),
      ChangeNotifierProvider(create: (_) => AllStocksProvider()),
      ChangeNotifierProvider(create: (_) => SectorIndustryProvider()),
      ChangeNotifierProvider(create: (_) => MoreStocksProvider()),
      ChangeNotifierProvider(create: (_) => BlogProvider()),
      ChangeNotifierProvider(create: (_) => TopTrendingProvider()),
      ChangeNotifierProvider(create: (_) => FeaturedNewsProvider()),
      ChangeNotifierProvider(create: (_) => HeaderNewsProvider()),
      ChangeNotifierProvider(create: (_) => AlertProvider()),
      ChangeNotifierProvider(create: (_) => NewsDetailProvider()),
      ChangeNotifierProvider(create: (_) => NewsTypeProvider()),
      ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ChangeNotifierProvider(create: (_) => FeaturedTickerProvider()),
      ChangeNotifierProvider(create: (_) => TrendingIndustriesProvider()),
      ChangeNotifierProvider(create: (_) => NewsCategoryProvider()),
      ChangeNotifierProvider(create: (_) => LowPriceStocksProvider()),
      ChangeNotifierProvider(create: (_) => HighLowPeProvider()),
      // ChangeNotifierProvider(create: (_) => PennyStocksProvider()),
      ChangeNotifierProvider(create: (_) => FiftyTwoWeeksProvider()),
      // ChangeNotifierProvider(create: (_) => HighLowBetaStocksProvider()),
      ChangeNotifierProvider(create: (_) => IndicesProvider()),
      ChangeNotifierProvider(create: (_) => MostActiveProvider()),
      ChangeNotifierProvider(create: (_) => WhatWeDoProvider()),
      ChangeNotifierProvider(create: (_) => TermsAndPolicyProvider()),
      ChangeNotifierProvider(create: (_) => ContactUsProvider()),
      ChangeNotifierProvider(create: (_) => FaqProvide()),
      ChangeNotifierProvider(create: (_) => DividendsProvider()),
      ChangeNotifierProvider(create: (_) => EarningsProvider()),
      ChangeNotifierProvider(create: (_) => StockScreenerProvider()),
      ChangeNotifierProvider(create: (_) => PlaidProvider()),
      ChangeNotifierProvider(create: (_) => CongressionalProvider()),
      // ChangeNotifierProvider(create: (_) => PennyStocksProvider()),
      // ChangeNotifierProvider(create: (_) => FiftyTwoWeeksProvider()),
      // ChangeNotifierProvider(create: (_) => ScrollControllerProvider()),
      ChangeNotifierProvider(create: (_) => FilterProvider()),
      ChangeNotifierProvider(create: (_) => GapUpProvider()),
      ChangeNotifierProvider(create: (_) => GapDownProvider()),
      ChangeNotifierProvider(create: (_) => BlogProviderNew()),

      ChangeNotifierProvider(create: (_) => HighPeProvider()),
      ChangeNotifierProvider(create: (_) => LowPeProvider()),
      ChangeNotifierProvider(create: (_) => HighPeGrowthProvider()),
      ChangeNotifierProvider(create: (_) => LowPeGrowthProvider()),
      ChangeNotifierProvider(create: (_) => TodayTopGainerProvider()),
      ChangeNotifierProvider(create: (_) => HighBetaStocksProvider()),
      ChangeNotifierProvider(create: (_) => LowsBetaStocksProvider()),
      ChangeNotifierProvider(create: (_) => NegativeBetaStocksProvider()),
      ChangeNotifierProvider(create: (_) => MostActivePennyStocksProviders()),
      ChangeNotifierProvider(create: (_) => TopTodayPennyStocksProviders()),
      ChangeNotifierProvider(create: (_) => UnusualTradingVolumeProvider()),
      ChangeNotifierProvider(create: (_) => MostVolatileStocksProvider()),
      ChangeNotifierProvider(create: (_) => TodayTopLoserProvider()),
      ChangeNotifierProvider(create: (_) => TodayBreakoutStockProvider()),
      ChangeNotifierProvider(create: (_) => Dow30Provider()),
      ChangeNotifierProvider(create: (_) => SnP500Provider()),
      ChangeNotifierProvider(create: (_) => StockDetailProviderNew()),
      ChangeNotifierProvider(create: (_) => MostPopularPennyStocksProviders()),
      ChangeNotifierProvider(create: (_) => CongressionalDetailProvider()),
    ];
  }
}

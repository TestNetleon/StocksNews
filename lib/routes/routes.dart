import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/managers/blogs.dart';
import 'package:stocks_news_new/managers/home.dart';
import 'package:stocks_news_new/managers/market/market.dart';
import 'package:stocks_news_new/managers/market/most_bullish.dart';
import 'package:stocks_news_new/managers/notification/most_bullish.dart';
import 'package:stocks_news_new/tournament/provider/leaderboard.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/tournament/provider/search.dart';
import 'package:stocks_news_new/providers/ad_provider.dart';
import 'package:stocks_news_new/providers/ai_provider.dart';
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
import 'package:stocks_news_new/providers/fifty_two_weeks_high_provider.dart';
import 'package:stocks_news_new/providers/fifty_two_weeks_provider.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/gap_down_provider.dart';
import 'package:stocks_news_new/providers/gap_up_provider.dart';
import 'package:stocks_news_new/providers/help_desk.dart';
import 'package:stocks_news_new/providers/help_desk_provider.dart';
import 'package:stocks_news_new/providers/high_beta_stocks_providers.dart';
import 'package:stocks_news_new/providers/high_pe_growth_provider.dart';
import 'package:stocks_news_new/providers/high_pe_provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/insider_trading_company_provider.dart';
import 'package:stocks_news_new/providers/insider_trading_provider.dart';
import 'package:stocks_news_new/providers/indices_provider.dart';
import 'package:stocks_news_new/providers/leaderboard.dart';
import 'package:stocks_news_new/providers/low_pe_growth_provider.dart';
import 'package:stocks_news_new/providers/low_pe_provider.dart';
import 'package:stocks_news_new/providers/low_beta_stocks_providers.dart';
import 'package:stocks_news_new/providers/membership.dart';
import 'package:stocks_news_new/providers/more_stocks_provider.dart';
import 'package:stocks_news_new/providers/morningstar_txn_provider.dart';
import 'package:stocks_news_new/providers/most_active_provider.dart';
import 'package:stocks_news_new/providers/most_popular_penny_provider.dart';
import 'package:stocks_news_new/providers/snp_500_provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/providers/store_provider.dart';
import 'package:stocks_news_new/providers/today_breackout_stocks_provider.dart';
import 'package:stocks_news_new/providers/today_top_loser_provider.dart';
import 'package:stocks_news_new/screens/auth/newFlow/login.dart';
import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/providers/top_gainer_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/providers/top_loser_scanner_provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/trade_provider.dart';
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
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/affiliate/index.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/auth/qrScan/index.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_success.dart';
import 'package:stocks_news_new/screens/blogDetail/index.dart';
import 'package:stocks_news_new/screens/contactUs/contact_us.dart';
import 'package:stocks_news_new/screens/marketData/dividends/dividends.dart';
import 'package:stocks_news_new/screens/marketData/earnings/earnings.dart';
import 'package:stocks_news_new/screens/marketData/fiftyTwoWeeks/index.dart';
import 'package:stocks_news_new/screens/marketData/highLowPE/index.dart';
import 'package:stocks_news_new/screens/marketData/highsLowsBetaStocks/index.dart';
import 'package:stocks_news_new/screens/marketData/indices/index.dart';
import 'package:stocks_news_new/screens/marketData/mostActive/index.dart';
import 'package:stocks_news_new/screens/faq/index.dart';
import 'package:stocks_news_new/screens/homeSpash/index.dart';
import 'package:stocks_news_new/screens/myAccount/my_account.dart';
import 'package:stocks_news_new/screens/notifications/index.dart';
import 'package:stocks_news_new/screens/search/search.dart';
import 'package:stocks_news_new/screens/start/index.dart';
import 'package:stocks_news_new/screens/stockDetail/index.dart';
import 'package:stocks_news_new/screens/tabs/compareNew/index.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/compare_stocks.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/plaid/portfolio/index.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/new_detail.dart';
import 'package:stocks_news_new/screens/trendingIndustries/index.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/tradingSimulator/providers/trading_search_provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_open_list_provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_pending_list_provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_portfollo_provider.dart';
import 'package:stocks_news_new/ui/tabs/more/notificationSettings/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/compareStocks/compare.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../managers/news.dart';
import '../managers/onboarding.dart';
import '../managers/search.dart';
import '../managers/signals.dart';
import '../managers/tools.dart';
import '../managers/user.dart';
import '../models/my_home_premium.dart';
import '../tournament/provider/trades.dart';
import '../providers/offerMembership/black_friday.dart';
import '../providers/featured_ticker.dart';
import '../providers/high_low_pe.dart';
import '../providers/low_prices_stocks.dart';
import '../providers/missions/provider.dart';
import '../providers/notification_settings.dart';
import '../providers/offerMembership/christmas.dart';
import '../providers/scroll_controller.dart';
import '../providers/stockAnalysis/provider.dart';
import '../screens/auth/base/base_auth.dart';
import '../tradingSimulator/providers/trading_simulator.dart';
import '../providers/trending_industries.dart';
import '../screens/marketData/congressionalData/index.dart';
import '../screens/marketData/lowPriceStocks/index.dart';
import '../screens/whatWeDo/index.dart';
import '../tradingSimulator/providers/ts_transaction_list.dart';
import '../ui/account/login.dart';
import '../ui/account/verify.dart';
import '../ui/onboarding/default_home.dart';
import '../ui/onboarding/slides.dart';
import '../ui/onboarding/splash.dart';
import '../ui/subscription/manager.dart';
import '../ui/subscription/screens/purchased/purchased.dart';
import '../ui/subscription/screens/view/plans.dart';
import '../ui/subscription/screens/start/subscription.dart';
import '../ui/tabs/more/articles/detail.dart';
import '../ui/tabs/more/articles/index.dart';
import '../ui/tabs/more/news/detail.dart';
import '../ui/tabs/more/news/index.dart';
import '../ui/tabs/signals/insiders/company/from_company.dart';
import '../ui/tabs/signals/insiders/reporting/from_reporting.dart';
import '../ui/tabs/signals/politicians/detail.dart';
import '../ui/tabs/tabs.dart';
import '../ui/tabs/tools/plaidConnect/portfolio.dart';

class Routes {
  static var routes = {
    //NEW routes
    Splash.path: (_) => const Splash(),
    DefaultHome.path: (_) => const DefaultHome(),
    OnboardingSlides.path: (_) => const OnboardingSlides(),
    NotificationSettings.path: (_) => const NotificationSettings(),
    AccountLoginIndex.path: (_) => const AccountLoginIndex(),
    ToolsPortfolioIndex.path: (_) => const ToolsPortfolioIndex(),
    ToolsCompareIndex.path: (_) => const ToolsCompareIndex(),
    CategoriesNewsIndex.path: (_) => const CategoriesNewsIndex(),
    BlogsIndex.path: (_) => const BlogsIndex(),
    SubscriptionIndex.path: (_) => const SubscriptionIndex(),
    SubscriptionPlansIndex.path: (_) => const SubscriptionPlansIndex(),
    PurchasedIndex.path: (_) => const PurchasedIndex(),

    //--------------------------------------

    Login.path: (_) => const Login(),
    SignUpSuccess.path: (_) => const SignUpSuccess(),
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
    HomePlaidAdded.path: (_) => const HomePlaidAdded(),
    ReferAFriend.path: (_) => const ReferAFriend(),
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

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  static Route getRouteGenerate(RouteSettings settings) {
    var routingData = settings.name;
    switch (routingData) {
      case Tabs.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            int? index = arguments?['index'];
            int? trendingIndex = arguments?['trendingIndex'];
            String? inAppMsgId = arguments?['inAppMsgId'];
            return Tabs(
              index: index ?? 0,
              trendingIndex: trendingIndex ?? 0,
              inAppMsgId: inAppMsgId,
            );
          },
        );

      case AccountVerificationIndex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            String countryCode = arguments?['countryCode'];
            String phone = arguments?['phone'];
            String verificationId = arguments?['verificationId'];
            return AccountVerificationIndex(
              countryCode: countryCode,
              phone: phone,
              verificationId: verificationId,
            );
          },
        );

      case SignalInsidersCompanyIndex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            InsiderTradeRes data = arguments?['data'];

            return SignalInsidersCompanyIndex(data: data);
          },
        );

      case SignalInsidersReportingIndex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            InsiderTradeRes data = arguments?['data'];

            return SignalInsidersReportingIndex(data: data);
          },
        );

      case SignalPoliticianDetailIndex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            PoliticianTradeRes data = arguments?['data'];

            return SignalPoliticianDetailIndex(data: data);
          },
        );

      case NewsDetailIndex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            String slug = arguments?['slug'];

            return NewsDetailIndex(slug: slug);
          },
        );

      case BlogsDetailIndex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            String slug = arguments?['slug'];

            return BlogsDetailIndex(slug: slug);
          },
        );

      default:
    }

    return MaterialPageRoute(
      builder: (context) {
        return const Splash();
      },
    );
  }

  static Route<dynamic> handleDeepLink(Uri uri) {
    DeeplinkEnum type = containsSpecificPath(uri);
    String slug = extractLastPathComponent(uri);

    Utils().showLog("GENERATED ROUT DeepLinking ***=> $type  $slug");
    popHome = false;

    Timer(const Duration(seconds: 5), () {
      onDeepLinking = false;
    });

    switch (type) {
      // case "blog":
      case DeeplinkEnum.blogDetail:
        return MaterialPageRoute(
          builder: (context) => BlogDetail(slug: slug),
        );
      // case "news":
      case DeeplinkEnum.newsDetail:
        return MaterialPageRoute(
          builder: (context) => NewsDetails(slug: slug),
        );
      // case "stock_detail":
      case DeeplinkEnum.stocksDetail:
        return MaterialPageRoute(
          builder: (context) => StockDetail(symbol: slug),
        );
      // case "dashboard":
      case DeeplinkEnum.dashboard:
        return MaterialPageRoute(builder: (context) => const Tabs());
      // case "login":
      case DeeplinkEnum.login:
        Timer(const Duration(seconds: 1), () async {
          bool userPresent = false;
          UserProvider provider =
              navigatorKey.currentContext!.read<UserProvider>();
          if (await provider.checkForUser()) {
            userPresent = true;
          }
          // if (!userPresent) loginSheet();
          if (!userPresent) loginFirstSheet();
        });
        return MaterialPageRoute(builder: (context) => const Tabs());
      // case "signUp":
      case DeeplinkEnum.signup:
        Timer(const Duration(seconds: 1), () async {
          bool userPresent = false;
          UserProvider provider =
              navigatorKey.currentContext!.read<UserProvider>();
          if (await provider.checkForUser()) {
            userPresent = true;
          }
          // if (!userPresent) signupSheet();
          if (!userPresent) loginFirstSheet();
        });
        return MaterialPageRoute(builder: (context) => const Tabs());
      default:
        // log("HERE ");
        return MaterialPageRoute(builder: (context) => const Tabs());
    }
  }

  // static Route _errorRoute() {
// }

// class AllProvider {
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
      ChangeNotifierProvider(create: (_) => ScrollControllerProvider()),
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
      ChangeNotifierProvider(create: (_) => LeaderBoardProvider()),
      ChangeNotifierProvider(create: (_) => FiftyTwoWeeksHighProvider()),
      ChangeNotifierProvider(create: (_) => HelpDeskProvider()),
      ChangeNotifierProvider(create: (_) => MembershipProvider()),
      ChangeNotifierProvider(create: (_) => MorningstarTxnProvider()),
      ChangeNotifierProvider(create: (_) => AIProvider()),
      ChangeNotifierProvider(create: (_) => StoreProvider()),
      ChangeNotifierProvider(create: (_) => TradeProviderNew()),
      ChangeNotifierProvider(create: (_) => NotificationsSettingProvider()),
      ChangeNotifierProvider(create: (_) => TradingSimulatorProvider()),
      ChangeNotifierProvider(create: (_) => TradingSearchProvider()),
      ChangeNotifierProvider(create: (_) => TsOpenListProvider()),
      ChangeNotifierProvider(create: (_) => TsPendingListProvider()),
      ChangeNotifierProvider(create: (_) => TsPortfolioProvider()),
      ChangeNotifierProvider(create: (_) => AdProvider()),
      ChangeNotifierProvider(create: (_) => NewHelpDeskProvider()),
      ChangeNotifierProvider(create: (_) => MSAnalysisProvider()),
      ChangeNotifierProvider(create: (_) => MissionProvider()),
      ChangeNotifierProvider(create: (_) => TournamentProvider()),
      ChangeNotifierProvider(create: (_) => TournamentTradesProvider()),
      ChangeNotifierProvider(create: (_) => BlackFridayProvider()),
      ChangeNotifierProvider(create: (_) => ChristmasProvider()),
      ChangeNotifierProvider(create: (_) => TsTransactionListProvider()),
      ChangeNotifierProvider(create: (_) => MarketScannerProvider()),
      ChangeNotifierProvider(create: (_) => TopGainerScannerProvider()),
      ChangeNotifierProvider(create: (_) => TopLoserScannerProvider()),
      ChangeNotifierProvider(create: (_) => TournamentSearchProvider()),
      ChangeNotifierProvider(create: (_) => TournamentLeaderboardProvider()),
      // ChangeNotifierProvider(create: (_) => ScannerProvider()),

      //MARK: New UI providers
      ChangeNotifierProvider(create: (_) => OnboardingManager()),
      ChangeNotifierProvider(create: (_) => MyHomeManager()),
      ChangeNotifierProvider(create: (_) => MarketManager()),
      // ChangeNotifierProvider(create: (_) => AlertsWatchlistAction()),
      ChangeNotifierProvider(create: (_) => MostBullishManager()),
      ChangeNotifierProvider(create: (_) => NotificationSettingsManager()),
      ChangeNotifierProvider(create: (_) => UserManager()),
      ChangeNotifierProvider(create: (_) => ToolsManager()),
      ChangeNotifierProvider(create: (_) => SignalsManager()),
      ChangeNotifierProvider(create: (_) => SearchManager()),
      ChangeNotifierProvider(create: (_) => NewsManager()),
      ChangeNotifierProvider(create: (_) => BlogsManager()),
      ChangeNotifierProvider(create: (_) => SubscriptionManager()),
    ];
  }
}

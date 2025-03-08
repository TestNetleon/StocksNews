import 'package:flutter/material.dart';
import 'package:stocks_news_new/managers/alerts.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/managers/blogs.dart';
import 'package:stocks_news_new/managers/faq.dart';
import 'package:stocks_news_new/managers/feedback.dart';
import 'package:stocks_news_new/managers/global.dart';
import 'package:stocks_news_new/managers/helpdesk.dart';
import 'package:stocks_news_new/managers/home.dart';
import 'package:stocks_news_new/managers/legal.dart';
import 'package:stocks_news_new/managers/market/industries/industries.dart';
import 'package:stocks_news_new/managers/market/sectors/sectors.dart';
import 'package:stocks_news_new/managers/market/stocks/52Weeks/fifty_two_weeks_high.dart';
import 'package:stocks_news_new/managers/market/stocks/52Weeks/fifty_two_weeks_low.dart';
import 'package:stocks_news_new/managers/market/alerts_watchlist_action.dart';
import 'package:stocks_news_new/managers/market/stocks/dividends/dividends.dart';
import 'package:stocks_news_new/managers/market/stocks/earnings/earnings.dart';
import 'package:stocks_news_new/managers/market/stocks/gapUpDown/gap_down.dart';
import 'package:stocks_news_new/managers/market/stocks/gapUpDown/gap_up.dart';
import 'package:stocks_news_new/managers/market/stocks/highLowBeta/high_beta.dart';
import 'package:stocks_news_new/managers/market/stocks/highLowBeta/low_beta.dart';
import 'package:stocks_news_new/managers/market/stocks/highLowBeta/negative_beta.dart';
import 'package:stocks_news_new/managers/market/stocks/highLowPe/high_pe.dart';
import 'package:stocks_news_new/managers/market/stocks/highLowPe/high_pe_growth.dart';
import 'package:stocks_news_new/managers/market/stocks/highLowPe/low_pe.dart';
import 'package:stocks_news_new/managers/market/stocks/highLowPe/low_pe_growth.dart';
import 'package:stocks_news_new/managers/market/stocks/indices/amex/amex.dart';
import 'package:stocks_news_new/managers/market/stocks/indices/dow30/dow_30.dart';
import 'package:stocks_news_new/managers/market/stocks/indices/nasdaq/nasdaq.dart';
import 'package:stocks_news_new/managers/market/stocks/indices/nyse/nyse.dart';
import 'package:stocks_news_new/managers/market/stocks/indices/s&p500/snp_500.dart';
import 'package:stocks_news_new/managers/market/stocks/lowPrice/stocks_under.dart';
import 'package:stocks_news_new/managers/market/market.dart';
import 'package:stocks_news_new/managers/market/stocks/mostActive/mostActive/most_active.dart';
import 'package:stocks_news_new/managers/market/stocks/mostActive/mostVolatile/most_volatile.dart';
import 'package:stocks_news_new/managers/market/stocks/mostActive/unusualTrading/unusual_trading.dart';
import 'package:stocks_news_new/managers/market/stocks/pennyStocks/mostActive/most_active.dart';
import 'package:stocks_news_new/managers/market/stocks/pennyStocks/mostPopular/most_popular.dart';
import 'package:stocks_news_new/managers/market/stocks/pennyStocks/topTodays/top_tadays.dart';
import 'package:stocks_news_new/managers/market/stocks/trending/most_bearish.dart';
import 'package:stocks_news_new/managers/market/stocks/trending/most_bullish.dart';
import 'package:stocks_news_new/managers/market/stocks/gainer&losers/todays_breakout.dart';
import 'package:stocks_news_new/managers/market/stocks/gainer&losers/todays_gainer.dart';
import 'package:stocks_news_new/managers/market/stocks/gainer&losers/todays_losers.dart';
import 'package:stocks_news_new/managers/notification/most_bullish.dart';
import 'package:stocks_news_new/managers/referral/leader_board_manager.dart';
import 'package:stocks_news_new/managers/referral/redeem_manager.dart';
import 'package:stocks_news_new/managers/referral/referral_manager.dart';
import 'package:stocks_news_new/managers/referral/referral_points_manager.dart';
import 'package:stocks_news_new/managers/watchlist.dart';

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
import 'package:stocks_news_new/screens/affiliate/index.dart';
import 'package:stocks_news_new/screens/auth/qrScan/index.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_success.dart';
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
import 'package:stocks_news_new/screens/tabs/compareNew/index.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/compare_stocks.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/plaid/portfolio/index.dart';
import 'package:stocks_news_new/screens/trendingIndustries/index.dart';
import 'package:stocks_news_new/ui/tabs/market/industries/industries_view.dart';
import 'package:stocks_news_new/ui/tabs/market/sectors/sector_view.dart';

import 'package:stocks_news_new/ui/tabs/more/alerts/index.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/billionaires_index.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/index.dart';
import 'package:stocks_news_new/ui/tabs/more/faq/index.dart';
import 'package:stocks_news_new/ui/tabs/more/feedback/index.dart';
import 'package:stocks_news_new/ui/tabs/more/helpdesk/chats/index.dart';
import 'package:stocks_news_new/ui/tabs/more/helpdesk/front/index.dart';
import 'package:stocks_news_new/ui/tabs/more/helpdesk/listing/index.dart';
import 'package:stocks_news_new/ui/tabs/more/helpdesk/tickets/index.dart';
import 'package:stocks_news_new/ui/tabs/more/notificationSettings/index.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/index.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/pointsTransaction/index.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/redeem/index.dart';
import 'package:stocks_news_new/ui/tabs/more/watchlist/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/compareStocks/compare.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/gainers.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/losers.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/portpolio.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/s_open.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/s_pending.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/s_recurring.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/s_transaction.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/ticker_search.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/trade.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/conditionalOrder/ConditionalTrades.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/conditionalOrder/RecurringOrder/recurring_index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/tickerSearch/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/tradeBuySell/index.dart';

import 'package:stocks_news_new/utils/constants.dart';
import '../managers/aiAnalysis/ai.dart';
import '../managers/news.dart';
import '../managers/onboarding.dart';
import '../managers/search.dart';
import '../managers/signals.dart';
import '../managers/stockDetail/stock.detail.dart';
import '../managers/tools.dart';
import '../managers/user.dart';
import '../models/my_home_premium.dart';
import '../providers/offerMembership/black_friday.dart';
import '../providers/featured_ticker.dart';
import '../providers/high_low_pe.dart';
import '../providers/low_prices_stocks.dart';
import '../providers/missions/provider.dart';
import '../providers/notification_settings.dart';
import '../providers/offerMembership/christmas.dart';
import '../providers/scroll_controller.dart';
import '../providers/stockAnalysis/provider.dart';
import '../providers/trending_industries.dart';
import '../screens/marketData/congressionalData/index.dart';
import '../screens/marketData/lowPriceStocks/index.dart';
import '../screens/whatWeDo/index.dart';
import '../ui/account/auth/login.dart';
import '../ui/account/auth/verify.dart';
import '../ui/account/update/delete.dart';
import '../ui/account/update/email_verify.dart';
import '../ui/account/update/index.dart';
import '../ui/aiAnalysis/index.dart';
import '../ui/legal/index.dart';
import '../ui/onboarding/default_home.dart';
import '../ui/onboarding/slides.dart';
import '../ui/onboarding/splash.dart';
import '../ui/stockDetail/index.dart';
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
import '../ui/tabs/tools/scanner/index.dart';
import '../ui/tabs/tools/scanner/manager/scanner.dart';

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
    UpdatePersonalDetailIndex.path: (_) => const UpdatePersonalDetailIndex(),
    AlertIndex.path: (_) => const AlertIndex(),
    WatchListIndex.path: (_) => const WatchListIndex(),
    FaqIndex.path: (_) => const FaqIndex(),
    HelpDeskIndex.path: (_) => const HelpDeskIndex(),
    DeletePersonalDetail.path: (_) => const DeletePersonalDetail(),
    HelpDeskCreateIndex.path: (_) => const HelpDeskCreateIndex(),
    RequestNewIndex.path: (_) => const RequestNewIndex(),
    FeedbackIndex.path: (_) => const FeedbackIndex(),
    BillionairesIndex.path: (_) => const BillionairesIndex(),
    ReferralIndex.path: (_) => const ReferralIndex(),
    RedeemPoints.path: (_) => const RedeemPoints(),

    //--------------------------------------

    Login.path: (_) => const Login(),
    SignUpSuccess.path: (_) => const SignUpSuccess(),
    Search.path: (_) => const Search(),
    FAQ.path: (_) => const FAQ(),
    Notifications.path: (_) => const Notifications(),
    //Alerts.path: (_) => const Alerts(),
    //WatchList.path: (_) => const WatchList(),
    LowPriceStocksIndex.path: (_) => const LowPriceStocksIndex(),
    CongressionalIndex.path: (_) => const CongressionalIndex(),
    StartIndex.path: (_) => const StartIndex(),
    MyAccount.path: (_) => const MyAccount(),
    //ContactUs.path: (_) => const ContactUs(),
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
            bool? update = arguments?['update'];
            return AccountVerificationIndex(
              countryCode: countryCode,
              phone: phone,
              verificationId: verificationId,
              update: update,
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

      case HelpDeskAllChatsIndex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            String ticketId = arguments?['ticketId'];

            return HelpDeskAllChatsIndex(ticketId: ticketId);
          },
        );
      case SimulatorIndex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            int? initialIndex = arguments?['initialIndex'];

            return SimulatorIndex(initialIndex: initialIndex ?? 0);
          },
        );
      case SearchTickerIndex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            StockType? stockType = arguments?['stockType'];
            return SearchTickerIndex(selectedStock: stockType);
          },
        );
      case TradeBuySellIndex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            StockType? stockType = arguments?['stockType'];
            num? qty = arguments?['qty'];
            num? editTradeID = arguments?['editTradeID'];
            return TradeBuySellIndex(
                qty: qty, editTradeID: editTradeID, selectedStock: stockType);
          },
        );
      case ConditionalTradesIndex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            ConditionType? conditionType = arguments?['conditionType'];
            num? qty = arguments?['qty'];
            num? editTradeID = arguments?['editTradeID'];
            String? tradeType = arguments?['tradeType'];
            return ConditionalTradesIndex(
              qty: qty,
              editTradeID: editTradeID,
              conditionalType: conditionType,
              tradeType: tradeType,
            );
          },
        );

      case RecurringIndex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            num? editTradeID = arguments?['editTradeID'];
            return RecurringIndex(
              editTradeID: editTradeID,
            );
          },
        );

      case BillionairesDetailIndex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            String slug = arguments?['slug'];
            return BillionairesDetailIndex(slug: slug);
          },
        );

      case IndustriesViewIndex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            String slug = arguments?['slug'];

            return IndustriesViewIndex(slug: slug);
          },
        );
      case SectorViewIndex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            String slug = arguments?['slug'];

            return SectorViewIndex(slug: slug);
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

      case LegalInfoIndex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            String? slug = arguments?['slug'];

            return LegalInfoIndex(slug: slug);
          },
        );

      case AccountEmailVerificationIndex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            String email = arguments?['email'];

            return AccountEmailVerificationIndex(email: email);
          },
        );
      case SDIndex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            String symbol = arguments?['symbol'];

            return SDIndex(symbol: symbol);
          },
        );

      case AIindex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            String symbol = arguments?['symbol'];

            return AIindex(symbol: symbol);
          },
        );

      case ToolsScannerIndex.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            int? index = arguments?['index'];

            return ToolsScannerIndex(index: index);
          },
        );
      case ReferPointsTransaction.path:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            return ReferPointsTransaction(
              type: arguments?['type'],
              title: arguments?['title'],
            );
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

  // static Route<dynamic> handleDeepLink(Uri uri) {
  //   DeeplinkEnum type = containsSpecificPath(uri);
  //   String slug = extractLastPathComponent(uri);

  //   Utils().showLog("GENERATED ROUT DeepLinking ***=> $type  $slug");
  //   popHome = false;

  //   Timer(const Duration(seconds: 5), () {
  //     onDeepLinking = false;
  //   });

  //   switch (type) {
  //     // case "blog":
  //     case DeeplinkEnum.blogDetail:
  //       return MaterialPageRoute(
  //         builder: (context) => BlogDetail(slug: slug),
  //       );
  //     // case "news":
  //     case DeeplinkEnum.newsDetail:
  //       return MaterialPageRoute(
  //         builder: (context) => NewsDetails(slug: slug),
  //       );
  //     // case "stock_detail":
  //     case DeeplinkEnum.stocksDetail:
  //       return MaterialPageRoute(
  //         builder: (context) => StockDetail(symbol: slug),
  //       );
  //     // case "dashboard":
  //     case DeeplinkEnum.dashboard:
  //       return MaterialPageRoute(builder: (context) => const Tabs());
  //     // case "login":
  //     case DeeplinkEnum.login:
  //       Timer(const Duration(seconds: 1), () async {
  //         bool userPresent = false;
  //         UserProvider provider =
  //             navigatorKey.currentContext!.read<UserProvider>();
  //         if (await provider.checkForUser()) {
  //           userPresent = true;
  //         }
  //         // if (!userPresent) loginSheet();
  //         if (!userPresent) loginFirstSheet();
  //       });
  //       return MaterialPageRoute(builder: (context) => const Tabs());
  //     // case "signUp":
  //     case DeeplinkEnum.signup:
  //       Timer(const Duration(seconds: 1), () async {
  //         bool userPresent = false;
  //         UserProvider provider =
  //             navigatorKey.currentContext!.read<UserProvider>();
  //         if (await provider.checkForUser()) {
  //           userPresent = true;
  //         }
  //         // if (!userPresent) signupSheet();
  //         if (!userPresent) loginFirstSheet();
  //       });
  //       return MaterialPageRoute(builder: (context) => const Tabs());
  //     default:
  //       // log("HERE ");
  //       return MaterialPageRoute(builder: (context) => const Tabs());
  //   }
  // }

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
      // ChangeNotifierProvider(create: (_) => TradeProviderNew()),
      ChangeNotifierProvider(create: (_) => NotificationsSettingProvider()),
      // ChangeNotifierProvider(create: (_) => TradingSimulatorProvider()),
      // ChangeNotifierProvider(create: (_) => TradingSearchProvider()),
      // ChangeNotifierProvider(create: (_) => TsOpenListProvider()),
      // ChangeNotifierProvider(create: (_) => TsPendingListProvider()),
      // ChangeNotifierProvider(create: (_) => TsPortfolioProvider()),
      ChangeNotifierProvider(create: (_) => AdProvider()),
      ChangeNotifierProvider(create: (_) => NewHelpDeskProvider()),
      ChangeNotifierProvider(create: (_) => MSAnalysisProvider()),
      ChangeNotifierProvider(create: (_) => MissionProvider()),
      // ChangeNotifierProvider(create: (_) => TournamentProvider()),
      // ChangeNotifierProvider(create: (_) => TournamentTradesProvider()),
      ChangeNotifierProvider(create: (_) => BlackFridayProvider()),
      ChangeNotifierProvider(create: (_) => ChristmasProvider()),
      // ChangeNotifierProvider(create: (_) => TsTransactionListProvider()),
      // ChangeNotifierProvider(create: (_) => TournamentSearchProvider()),
      // ChangeNotifierProvider(create: (_) => TournamentLeaderboardProvider()),
      // ChangeNotifierProvider(create: (_) => ScannerProvider()),

      //MARK: New UI providers
      ChangeNotifierProvider(create: (_) => OnboardingManager()),
      ChangeNotifierProvider(create: (_) => MyHomeManager()),
      // ChangeNotifierProvider(create: (_) => AlertsWatchlistAction()),
      ChangeNotifierProvider(create: (_) => NotificationSettingsManager()),
      ChangeNotifierProvider(create: (_) => UserManager()),
      ChangeNotifierProvider(create: (_) => ToolsManager()),
      ChangeNotifierProvider(create: (_) => SignalsManager()),
      ChangeNotifierProvider(create: (_) => SearchManager()),
      ChangeNotifierProvider(create: (_) => NewsManager()),
      ChangeNotifierProvider(create: (_) => BlogsManager()),
      ChangeNotifierProvider(create: (_) => SubscriptionManager()),
      ChangeNotifierProvider(create: (_) => LegalInfoManager()),
      ChangeNotifierProvider(create: (_) => SDManager()),
      // ChangeNotifierProvider(create: (_) => MarketScannerM()),
      // ChangeNotifierProvider(create: (_) => TopGainerScannerM()),
      // ChangeNotifierProvider(create: (_) => TopLoserScannerM()),
      ChangeNotifierProvider(create: (_) => AlertsM()),
      ChangeNotifierProvider(create: (_) => WatchListManagers()),
      ChangeNotifierProvider(create: (_) => AlertsWatchlistManager()),
      ChangeNotifierProvider(create: (_) => FaqManager()),
      ChangeNotifierProvider(create: (_) => AIManager()),
      ChangeNotifierProvider(create: (_) => NewHelpDeskManager()),
      ChangeNotifierProvider(create: (_) => PortfolioManager()),
      ChangeNotifierProvider(create: (_) => SOpenManager()),
      ChangeNotifierProvider(create: (_) => SPendingManager()),
      ChangeNotifierProvider(create: (_) => SRecurringManager()),
      ChangeNotifierProvider(create: (_) => STransactionManager()),
      ChangeNotifierProvider(create: (_) => TradeManager()),
      ChangeNotifierProvider(create: (_) => TickerSearchManager()),
      ChangeNotifierProvider(create: (_) => FeedbackManager()),
      ChangeNotifierProvider(create: (_) => BillionairesManager()),
      ChangeNotifierProvider(create: (_) => ReferralManager()),
      ChangeNotifierProvider(create: (_) => ReferralPointsManager()),
      ChangeNotifierProvider(create: (_) => LeaderBoardManager()),
      ChangeNotifierProvider(create: (_) => RedeemManager()),

      //SCANNER Start---------------
      ChangeNotifierProvider(create: (_) => ScannerManager()),
      ChangeNotifierProvider(create: (_) => GlobalManager()),
      ChangeNotifierProvider(create: (_) => ScannerGainersManager()),
      ChangeNotifierProvider(create: (_) => ScannerLosersManager()),
      //SCANNER End---------------

      // MARKET DATA Start ---------------
      ChangeNotifierProvider(create: (_) => MarketManager()),
      ChangeNotifierProvider(create: (_) => MostBullishManager()),
      ChangeNotifierProvider(create: (_) => MostBearishManager()),
      ChangeNotifierProvider(create: (_) => TodaysGainerManager()),
      ChangeNotifierProvider(create: (_) => TodaysLosersManager()),
      ChangeNotifierProvider(create: (_) => TodaysBreakoutManager()),
      ChangeNotifierProvider(create: (_) => GapUpManager()),
      ChangeNotifierProvider(create: (_) => GapDownManager()),
      ChangeNotifierProvider(create: (_) => HighPeManager()),
      ChangeNotifierProvider(create: (_) => LowPeManager()),
      ChangeNotifierProvider(create: (_) => HighPeGrowthManager()),
      ChangeNotifierProvider(create: (_) => LowPeGrowthManager()),
      ChangeNotifierProvider(create: (_) => FiftyTwoWeeksHighManager()),
      ChangeNotifierProvider(create: (_) => FiftyTwoWeeksLowManager()),
      ChangeNotifierProvider(create: (_) => HighBetaManager()),
      ChangeNotifierProvider(create: (_) => LowBetaManager()),
      ChangeNotifierProvider(create: (_) => NegativeBetaManager()),
      ChangeNotifierProvider(create: (_) => Dow30Manager()),
      ChangeNotifierProvider(create: (_) => Snp500Manager()),
      ChangeNotifierProvider(create: (_) => NyseManager()),
      ChangeNotifierProvider(create: (_) => AmexManager()),
      ChangeNotifierProvider(create: (_) => NasdaqManager()),
      ChangeNotifierProvider(create: (_) => StocksUnderManager()),
      ChangeNotifierProvider(create: (_) => MostActiveManager()),
      ChangeNotifierProvider(create: (_) => MostVolatileManager()),
      ChangeNotifierProvider(create: (_) => UnusualTradingManager()),
      ChangeNotifierProvider(create: (_) => MostActivePennyStocksManager()),
      ChangeNotifierProvider(create: (_) => MostPopularPennyStocksManager()),
      ChangeNotifierProvider(create: (_) => TopTodaysPennyStocksManager()),
      ChangeNotifierProvider(create: (_) => DividendsManager()),
      ChangeNotifierProvider(create: (_) => EarningsManager()),
      ChangeNotifierProvider(create: (_) => IndustriesManager()),
      ChangeNotifierProvider(create: (_) => SectorsManager()),
      // MARKET DATA End ---------------
    ];
  }
}

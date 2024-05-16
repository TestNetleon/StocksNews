import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:stocks_news_new/modals/news_datail_res.dart';
import 'package:stocks_news_new/providers/alert_provider.dart';
import 'package:stocks_news_new/providers/all_stocks_provider.dart';
import 'package:stocks_news_new/providers/blog_provider.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/insider_trading_company_provider.dart';
import 'package:stocks_news_new/providers/insider_trading_provider.dart';
import 'package:stocks_news_new/providers/more_stocks_provider.dart';
import 'package:stocks_news_new/providers/news_detail.provider.dart';
import 'package:stocks_news_new/providers/news_provider.dart';
import 'package:stocks_news_new/providers/notification_provider.dart';
import 'package:stocks_news_new/providers/reddit_twitter_provider.dart';
import 'package:stocks_news_new/providers/search_provider.dart';
import 'package:stocks_news_new/providers/sector_industry_provider.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/providers/top_trending_provider.dart';
import 'package:stocks_news_new/providers/trending_provider.dart';
//
import 'package:stocks_news_new/providers/user_provider.dart';

import 'package:provider/provider.dart';

import 'package:provider/single_child_widget.dart';
import 'package:stocks_news_new/providers/watchlist_provider.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/auth/createAccount/create_account.dart';
import 'package:stocks_news_new/screens/auth/qrScan/index.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_success.dart';
import 'package:stocks_news_new/screens/blogDetail/index.dart';
import 'package:stocks_news_new/screens/blogs/index.dart';
import 'package:stocks_news_new/screens/contactUs/contact_us.dart';
import 'package:stocks_news_new/screens/faq/index.dart';
import 'package:stocks_news_new/screens/myAccount/my_account.dart';
import 'package:stocks_news_new/screens/notifications/index.dart';
import 'package:stocks_news_new/screens/search/search.dart';
import 'package:stocks_news_new/screens/splash/splash.dart';
import 'package:stocks_news_new/screens/start/index.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/redditComments/i_frame_item.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/sectorIndustry/sector_industry.dart';
import 'package:stocks_news_new/screens/stocks/index.dart';
import 'package:stocks_news_new/screens/t&cAndPolicy/tc_policy.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/compare_stocks.dart';
import 'package:stocks_news_new/screens/tabs/insider/insiderDetails/insider_details.dart';
import 'package:stocks_news_new/screens/tabs/news/newsAuthor/index.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/new_detail.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/screens/trendingIndustries/index.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import '../providers/featured_ticker.dart';
import '../screens/whatWeDo/index.dart';

class Routes {
  static var routes = {
    Splash.path: (_) => const Splash(),
    // Login.path: (_) => const Login(),
    // SignUp.path: (_) => const SignUp(),
    CreateAccount.path: (_) => const CreateAccount(),
    SignUpSuccess.path: (_) => const SignUpSuccess(),
    // Tabs.path: (_) => const Tabs(),
    // OTPSignup.path: (_) => const OTPSignup(),
    // OTPLogin.path: (_) => const OTPLogin(),
    Search.path: (_) => const Search(),
    FAQ.path: (_) => const FAQ(),
    Notifications.path: (_) => const Notifications(),
    Alerts.path: (_) => const Alerts(),
    WatchList.path: (_) => const WatchList(),
    StartIndex.path: (_) => const StartIndex(),
    MyAccount.path: (_) => const MyAccount(),
    ContactUs.path: (_) => const ContactUs(),
    CompareStocks.path: (_) => const CompareStocks(),
    QrScan.path: (_) => const QrScan(),
    StocksIndex.path: (_) => const StocksIndex(),
    IndexBlog.path: (_) => const IndexBlog(),
    TrendingIndustries.path: (_) => const TrendingIndustries(),
    WhatWeDoIndex.path: (_) => const WhatWeDoIndex(),
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
    switch (routingData) {
      case TCandPolicy.path:
        return MaterialWithModalsPageRoute(
          builder: (context) {
            return TCandPolicy(policyType: settings.arguments as PolicyType);
          },
        );

      case NewsDetails.path:
        return MaterialWithModalsPageRoute(
          builder: (context) {
            return NewsDetails(slug: settings.arguments as String?);
          },
        );

      case StockDetails.path:
        return MaterialWithModalsPageRoute(
          builder: (context) {
            return StockDetails(symbol: settings.arguments as String);
          },
        );

      case StockDetailiFrameItem.path:
        return MaterialWithModalsPageRoute(
          builder: (context) {
            return StockDetailiFrameItem(
                type: settings.arguments as CommentType);
          },
        );

      case Blog.path:
        final arguments = settings.arguments as Map<String, dynamic>?;
        String? id = arguments?['id'] as String?;
        BlogsType? type = arguments?['type'] as BlogsType?;
        return MaterialWithModalsPageRoute(
          builder: (context) {
            return Blog(
              type: type ?? BlogsType.blog,
              id: id ?? "",
            );
          },
        );

      case BlogDetail.path:
        return MaterialWithModalsPageRoute(
          builder: (context) {
            return BlogDetail(id: settings.arguments as String);
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
    }
    return _errorRoute();
  }

  static Route _errorRoute() {
    return MaterialWithModalsPageRoute(
        builder: (context) => BaseContainer(
              body: Center(
                child: Text(
                  "ERROR PAGE....",
                  style: stylePTSansBold(),
                ),
              ),
            ));
  }

  static List<SingleChildWidget> get providers {
    return [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(create: (_) => SearchProvider()),
      ChangeNotifierProvider(create: (_) => NewsProvider()),
      ChangeNotifierProvider(create: (_) => TrendingProvider()),
      ChangeNotifierProvider(create: (_) => InsiderTradingProvider()),
      ChangeNotifierProvider(create: (_) => WatchlistProvider()),
      ChangeNotifierProvider(create: (_) => StockDetailProvider()),
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

      // ChangeNotifierProvider(create: (_) => ScrollControllerProvider()),
    ];
  }
}

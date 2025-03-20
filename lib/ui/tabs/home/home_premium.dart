import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/managers/home/home_tabs.dart';
import 'package:stocks_news_new/ui/AdManager/service.dart';
import 'package:stocks_news_new/ui/tabs/home/plaid/index.dart';
import 'package:stocks_news_new/ui/tabs/home/refer/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'insiderTrades/insider_trades.dart';
import 'mostBought/index.dart';
import 'news/news.dart';
import 'politiciansTrades/politician_trades.dart';
import 'trendingGainerLoser/index.dart';
import 'trendingWatchlist/watchlist.dart';

class HomePremiumIndex extends StatelessWidget {
  const HomePremiumIndex({super.key});

  @override
  Widget build(BuildContext context) {
    MyHomeManager manager = context.watch<MyHomeManager>();
    HomeTabsManager tabsManager = context.watch<HomeTabsManager>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeWatchlistContainer(),
        Container(
          margin: EdgeInsets.only(
            left: Pad.pad16,
            right: Pad.pad16,
            top: Pad.pad24,
          ),
          child: ReferAndEarnBox(),
        ),
        HomeMostBoughtIndex(),
        PlaidHomeGetStarted(),
        Visibility(
          visible: manager.data?.adManagers?.data?.place2 != null,
          child: AdManagerIndex(
              places: AdPlaces.place2,
              data: manager.data?.adManagers?.data?.place2),
        ),
        VisibilityDetector(
          key: const Key('home_trending_visibility'),
          onVisibilityChanged: (VisibilityInfo info) {
            if (info.visibleFraction > 0.1 &&
                tabsManager.dataTrending == null) {
              tabsManager.setTrendingLoaded(true);
              tabsManager.getHomeTrending();
            }
          },
          child: BaseLoaderContainer(
            isLoading: tabsManager.isLoadingTrending,
            hasData: tabsManager.dataTrending != null,
            showPreparingText: true,
            removeErrorWidget: true,
            placeholder: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 20),
              child: CircularProgressIndicator(),
            ),
            child: TrendingGainerLoser(),
          ),
        ),
        HomeNewsIndex(newsData: manager.homePremiumData?.featuredNews),
        HomeInsiderTradesIndex(
          insiderData: manager.homePremiumData?.insiderTrading,
        ),
        HomePoliticianTradesIndex(
          politicianData: manager.homePremiumData?.congressionalStocks,
        ),
        Visibility(
          visible: manager.data?.adManagers?.data?.place3 != null,
          child: AdManagerIndex(
              places: AdPlaces.place3,
              data: manager.data?.adManagers?.data?.place3),
        ),
        // HomeNewsIndex(newsData: manager.homePremiumData?.financialNews),
        // HomeNewsIndex(newsData: manager.homePremiumData?.recentNews),
      ],
    );
  }
}

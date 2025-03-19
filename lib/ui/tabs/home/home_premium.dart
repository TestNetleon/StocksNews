import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/home.dart';

import 'insiderTrades/insider_trades.dart';
import 'news/news.dart';
import 'politiciansTrades/politician_trades.dart';
import 'trendingWatchlist/watchlist.dart';

class HomePremiumIndex extends StatelessWidget {
  const HomePremiumIndex({super.key});

  @override
  Widget build(BuildContext context) {
    MyHomeManager manager = context.watch<MyHomeManager>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeWatchlistContainer(),
        HomeNewsIndex(newsData: manager.homePremiumData?.featuredNews),
        HomeInsiderTradesIndex(
          insiderData: manager.homePremiumData?.insiderTrading,
        ),
        HomePoliticianTradesIndex(
          politicianData: manager.homePremiumData?.congressionalStocks,
        ),
        // HomeNewsIndex(newsData: manager.homePremiumData?.financialNews),
        // HomeNewsIndex(newsData: manager.homePremiumData?.recentNews),
      ],
    );
  }
}

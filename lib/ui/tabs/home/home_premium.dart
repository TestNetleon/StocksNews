import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home.dart';

import 'news/news.dart';
import 'politiciansTrades/politician_trades.dart';

class HomePremiumIndex extends StatelessWidget {
  const HomePremiumIndex({super.key});

  @override
  Widget build(BuildContext context) {
    MyHomeManager manager = context.watch<MyHomeManager>();

    return Column(
      children: [
        HomeNewsIndex(newsData: manager.homePremiumData?.featuredNews),
        HomePoliticianTradesIndex(
          politicianData: manager.homePremiumData?.congressionalStocks,
        ),
        HomeNewsIndex(newsData: manager.homePremiumData?.financialNews),
        HomeNewsIndex(newsData: manager.homePremiumData?.recentNews),
      ],
    );
  }
}

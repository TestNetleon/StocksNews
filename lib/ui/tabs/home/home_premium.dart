import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home.dart';

import 'news/news.dart';

class HomePremiumIndex extends StatelessWidget {
  const HomePremiumIndex({super.key});

  @override
  Widget build(BuildContext context) {
    MyHomeManager provider = context.watch<MyHomeManager>();

    return Column(
      children: [
        HomeNewsIndex(newsData: provider.homePremiumData?.featuredNews),
        HomeNewsIndex(newsData: provider.homePremiumData?.financialNews),
      ],
    );
  }
}

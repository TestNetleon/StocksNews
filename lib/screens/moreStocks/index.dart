import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/moreStocks/topGainerLoser/container.dart';
import 'package:stocks_news_new/utils/constants.dart';

import 'topTrending/container.dart';

class MoreStocks extends StatelessWidget {
  final StocksType type;
  const MoreStocks({required this.type, super.key});
//
  @override
  Widget build(BuildContext context) {
    return type == StocksType.gainers || type == StocksType.losers
        ? GainerLoserContainer(type: type)
        : const TopTrendingContainer();
    //  ChangeNotifierProvider.value(
    //     value: TopTrendingProvider(), child: const TopTrendingContainer());

    // MoreStocksContainer(type: type);
  }
}

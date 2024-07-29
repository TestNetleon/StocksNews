import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/stockAnalysis/widget/main_tabbar.dart';
import 'package:stocks_news_new/screens/stockAnalysis/widget/peer_comparison.dart';
import 'package:stocks_news_new/screens/stockAnalysis/widget/price_volatility.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/stockAnalysis/widget/stock_analysis.dart';
import 'package:stocks_news_new/screens/stockAnalysis/widget/stock_highlight.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class StockAnalysis extends StatefulWidget {
  const StockAnalysis({super.key});

  @override
  State<StockAnalysis> createState() => _StockAnalysisState();
}

class _StockAnalysisState extends State<StockAnalysis> {
  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      appBar: AppBarHome(isPopback: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              StockHighlight(),
              SpacerVertical(height: Dimen.padding),
              StockSubAnalysis(),
              SpacerVertical(height: Dimen.padding),
              PriceVolatility(),
              SpacerVertical(height: Dimen.padding),
              PerformanceTabBar(),
              SpacerVertical(height: Dimen.padding),
              PeerComparison(),
              SpacerVertical(height: Dimen.padding),
            ],
          ),
        ),
      ),
    );
  }
}

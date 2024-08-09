import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/prediction/Widget/our_take.dart';
import 'package:stocks_news_new/screens/stockAnalysis/faq/faq.dart';
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

import '../../modals/stock_details_res.dart';
import '../../providers/stock_detail_new.dart';
import '../stockDetail/stockDetailTabs/overview/top_widget.dart';
import 'otherStocks/other.dart';
import 'predictionChart/chart.dart';
import 'radar/radar.dart';
import 'widget/app_bar.dart';

class StockAnalysis extends StatefulWidget {
  const StockAnalysis({super.key});

  @override
  State<StockAnalysis> createState() => _StockAnalysisState();
}

class _StockAnalysisState extends State<StockAnalysis> {
  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    KeyStats? keyStats = provider.tabRes?.keyStats;
    return BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      appBar: AppBarHome(
        isPopback: true,
        showTrailing: false,
        canSearch: false,
        title: keyStats?.name ?? "N/A",
        subTitle: "",
        widget: keyStats == null ? null : const PredictionAppBar(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SdTopWidgetDetail(),
              // SpacerVertical(height: Dimen.padding),
              PredictionRadarGraph(),
              PredictionOtherStocks(),
              SpacerVertical(height: Dimen.padding),
              PredictionOurTake(),
              SpacerVertical(height: Dimen.padding),
              StockHighlight(),
              SpacerVertical(height: Dimen.padding),
              StockSubAnalysis(),
              SpacerVertical(height: Dimen.padding),
              PriceVolatility(),
              SpacerVertical(height: Dimen.padding),
              PerformanceTabBar(),
              SpacerVertical(height: Dimen.padding),
              PredictionForecastChart(),
              PeerComparison(),
              SpacerVertical(height: Dimen.padding),
              PredictionFaqs(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/screens/MsAnalysis/faq/faq.dart';
import 'package:stocks_news_new/screens/MsAnalysis/widget/peer_comparison.dart';
import 'package:stocks_news_new/screens/MsAnalysis/widget/price_volatility.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../modals/stock_details_res.dart';
import '../../providers/stock_detail_new.dart';
import '../stockDetail/stockDetailTabs/overview/top_widget.dart';
import 'highlights/index.dart';
import 'otherStocks/other.dart';
import 'ourTake/index.dart';
import 'performance/tabs.dart';
import 'predictionChart/chart.dart';
import 'radar/radar.dart';
import 'swot/index.dart';
import 'widget/app_bar.dart';

class MsAnalysis extends StatefulWidget {
  const MsAnalysis({super.key});

  @override
  State<MsAnalysis> createState() => _MsAnalysisState();
}

class _MsAnalysisState extends State<MsAnalysis> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MSAnalysisProvider>().callAPIs();
    });
  }

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
              MsRadarGraph(),
              MsOtherStocks(),
              SpacerVertical(height: Dimen.padding),
              MsOurTake(),
              SpacerVertical(height: Dimen.padding),
              MsOurHighlights(),
              SpacerVertical(height: Dimen.padding),
              MsSwotAnalysis(),
              SpacerVertical(height: Dimen.padding),
              MsPriceVolatility(),
              SpacerVertical(height: Dimen.padding),
              MsPerformanceTabs(),
              SpacerVertical(height: Dimen.padding),
              MsForecastChart(),
              MsPeerComparison(),
              SpacerVertical(height: Dimen.padding),
              MsFAQs(),
            ],
          ),
        ),
      ),
    );
  }
}

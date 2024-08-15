import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/MsAnalysis/performance/performance_tabbarview/overview_widgets/financial.dart';
import 'package:stocks_news_new/screens/MsAnalysis/performance/performance_tabbarview/overview_widgets/fundamental.dart';
import 'package:stocks_news_new/screens/MsAnalysis/performance/performance_tabbarview/overview_widgets/performance.dart';
import 'package:stocks_news_new/screens/MsAnalysis/performance/performance_tabbarview/overview_widgets/price.dart';
import 'package:stocks_news_new/screens/MsAnalysis/performance/performance_tabbarview/overview_widgets/shareholding.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class PerformanceOverview extends StatefulWidget {
  const PerformanceOverview({super.key});

  @override
  State<PerformanceOverview> createState() => _PerformanceOverviewState();
}

class _PerformanceOverviewState extends State<PerformanceOverview> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: const [
          PerformanceWidget(),
          FundamentalWidget(),
          PriceWidget(),
          FinancialWidget(),
          ShareholdingWidget(),
          SpacerVertical(
            height: 10,
          )
        ],
      ),
    );
  }
}

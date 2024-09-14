import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/MsAnalysis/overviewTabs/view/fundamentals/index.dart';
import 'financial/index.dart';
import 'performance/index.dart';
import 'priceVolume/index.dart';
import 'shareHoldings/index.dart';

class MsOverview extends StatelessWidget {
  const MsOverview({super.key});
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        MsPerformance(),
        MsFundamental(),
        MsPriceVolume(),
        MsFinancial(),
        MsShareholdings(),
      ],
    );
  }
}

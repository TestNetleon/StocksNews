import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/MsAnalysis/overviewTabs/view/fundamentals/index.dart';
import '../../../../providers/stockAnalysis/provider.dart';
import 'financial/index.dart';
import 'performance/index.dart';
import 'priceVolume/index.dart';

class MsOverview extends StatelessWidget {
  const MsOverview({super.key});
  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();

    return Column(
      children: [
        if (provider.completeData?.overviewText?.performance?.status == true)
          MsPerformance(),
        if (provider.completeData?.fundamentals != null &&
            provider.completeData?.overviewText?.fundamentals?.status == true)
          MsFundamental(),
        // if (provider.pvData != null && provider.pvData?.isNotEmpty == true)
        if (provider.completeData?.overviewText?.priceVolume?.status == true)
          MsPriceVolume(),
        if (provider.financialsData != null &&
            provider.financialsData?.isNotEmpty == true &&
            provider.completeData?.overviewText?.financials?.status == true)
          MsFinancial(),
        // MsShareholdings(),
      ],
    );
  }
}

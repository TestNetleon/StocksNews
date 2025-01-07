import 'package:flutter/material.dart';
import 'package:stocks_news_new/stocksScanner/screens/marketScanner/index.dart';
import 'package:stocks_news_new/stocksScanner/screens/topGainers/index.dart';
import 'package:stocks_news_new/stocksScanner/screens/topLosers/index.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

class ScannerContainer extends StatelessWidget {
  const ScannerContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommonTabContainer(
      physics: NeverScrollableScrollPhysics(),
      scrollable: true,
      tabs: ["MARKET SCANNER", "TOP GAINERS", "TOP LOSERS"],
      widgets: [
        MarketScanner(),
        ScannerTopGainer(),
        ScannerTopLosers(),
      ],
    );
  }
}

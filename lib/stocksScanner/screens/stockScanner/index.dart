import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/stocksScanner/screens/marketScanner/market_scanner_filter.dart';
import 'package:stocks_news_new/stocksScanner/screens/stockScanner/scanner_container.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class StocksScanner extends StatelessWidget {
  const StocksScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: AppBarHome(
        isPopBack: true,
        title: "Stocks Scanner",
        canSearch: false,
        showTrailing: false,
        filterApplied: true,
        onFilterClick: () {
          Navigator.push(context, createRoute(MarketScannerFilter()));
        },
      ),
      body: ScannerContainer(),
    );
  }
}

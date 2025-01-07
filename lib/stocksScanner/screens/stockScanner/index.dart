import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/stocksScanner/screens/stockScanner/scanner_container.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class StocksScanner extends StatelessWidget {
  const StocksScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(
        isPopBack: true,
        title: "Stocks Scanner",
        canSearch: false,
        showTrailing: false,
      ),
      body: ScannerContainer(),
    );
  }
}

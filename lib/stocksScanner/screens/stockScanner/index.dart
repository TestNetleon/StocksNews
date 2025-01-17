import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/screens/marketScanner/market_scanner_filter.dart';
import 'package:stocks_news_new/stocksScanner/screens/stockScanner/scanner_container.dart';
import 'package:stocks_news_new/stocksScanner/screens/stockScanner/scanner_webview.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/loading.dart';

class StocksScanner extends StatefulWidget {
  const StocksScanner({super.key});

  @override
  State<StocksScanner> createState() => _StocksScannerState();
}

class _StocksScannerState extends State<StocksScanner> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketScannerProvider>().getScannerType();
    });
  }

  @override
  Widget build(BuildContext context) {
    MarketScannerProvider provider = context.watch<MarketScannerProvider>();
    return BaseContainer(
      appBar: AppBarHome(
        isPopBack: true,
        title: "Stocks Scanner",
        canSearch: false,
        showTrailing: false,
        isScannerFilter: true,
        onFilterClick: () {
          Navigator.push(context, createRoute(MarketScannerFilter()));
        },
      ),
      body: provider.isLoading
          ? Loading()
          : provider.isScannerWebview
              ? ScannerWebview()
              : ScannerContainer(),
    );
  }
}

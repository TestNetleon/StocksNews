import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/screens/marketScanner/offline_data.dart';
import 'package:stocks_news_new/stocksScanner/screens/marketScanner/online_data.dart';
import 'package:stocks_news_new/stocksScanner/screens/stockScanner/widget_preparing.dart';

class MarketScanner extends StatefulWidget {
  const MarketScanner({super.key});

  @override
  State<MarketScanner> createState() => _MarketScannerState();
}

class _MarketScannerState extends State<MarketScanner> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MarketScannerProvider provider = context.read<MarketScannerProvider>();
      provider.startListeningPorts();
      // TODO:
      // provider.getOfflineData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<MarketScannerProvider>(
        builder: (context, provider, child) {
          if (provider.dataList != null) {
            return MarketScannerOnline();
          } else if (provider.offlineDataList != null) {
            return MarketScannerOffline();
          } else {
            return ScannerPreparing();
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/managers/market_scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/market/offline_data_two.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/market/online_data.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/widget/widget_preparing.dart';

import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';

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
      MarketScannerM provider = context.read<MarketScannerM>();
      provider.startListeningPorts();
    });
  }

  _callPort() async {
    MarketScannerM scannerProvider =
        context.read<MarketScannerM>();

    await scannerProvider.getScannerPorts(
      loading: true,
      start: false,
      set: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonRefreshIndicator(
      onRefresh: () async {
        _callPort();
        MarketScannerM provider = context.read<MarketScannerM>();
        provider.startListeningPorts();
      },
      child: SingleChildScrollView(
        child: Consumer<MarketScannerM>(
          builder: (context, provider, child) {
            if (provider.dataList != null) {
              return MarketScannerOnline();
            } else if (provider.offlineDataList != null) {
              return MarketScannerOfflineTwo();
            } else {
              return ScannerPreparing();
            }
          },
        ),
      ),
    );
  }
}

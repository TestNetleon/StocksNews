import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/stocksScanner/manager/losers_stream.dart';
import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/providers/top_loser_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/screens/stockScanner/widget_preparing.dart';
import 'package:stocks_news_new/stocksScanner/screens/topLosers/offline_data_two.dart';
import 'package:stocks_news_new/stocksScanner/screens/topLosers/online_data.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';

class ScannerTopLosers extends StatefulWidget {
  const ScannerTopLosers({super.key});

  @override
  State<ScannerTopLosers> createState() => _ScannerTopLosersState();
}

class _ScannerTopLosersState extends State<ScannerTopLosers> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketScannerProvider>().stopListeningPorts();
      TopLoserScannerProvider provider =
          context.read<TopLoserScannerProvider>();
      provider.startListeningPorts();
      // provider.getOfflineData();
    });
  }

  @override
  Widget build(BuildContext context) {
    TopLoserScannerProvider provider = context.read<TopLoserScannerProvider>();
    return CommonRefreshIndicator(
      onRefresh: () async {
        MarketLosersStream().initializePorts();
        provider.clearFilter();
      },
      child: SingleChildScrollView(
        child: Consumer<TopLoserScannerProvider>(
          builder: (context, provider, child) {
            if (provider.dataList != null) {
              return TopLosersOnline();
            }
            // else if (provider.offlineDataList != null &&
            //     marketScannerProvider.scannerIndex == 2) {
            //   return TopLosersOffline();
            // }
            else if (provider.offlineDataList != null) {
              return TopLosersOfflineTwo();
            } else {
              return ScannerPreparing();
            }
          },
        ),
      ),
    );
  }
}

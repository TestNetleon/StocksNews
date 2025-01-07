import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/stocksScanner/providers/top_gainer_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/screens/topGainers/offline_data.dart';
import 'package:stocks_news_new/stocksScanner/screens/topGainers/online_data.dart';
import 'package:stocks_news_new/utils/theme.dart';

class ScannerTopGainer extends StatefulWidget {
  const ScannerTopGainer({super.key});

  @override
  State<ScannerTopGainer> createState() => _ScannerTopGainerState();
}

class _ScannerTopGainerState extends State<ScannerTopGainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TopGainerScannerProvider provider =
          context.read<TopGainerScannerProvider>();
      provider.startListeningPorts();
      // provider.getOfflineData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<TopGainerScannerProvider>(
        builder: (context, provider, child) {
          if (provider.dataList != null) {
            return TopGainerOnline();
          } else if (provider.offlineDataList != null) {
            return TopGainerOffline();
          } else {
            return Center(
              child: Text(
                "Preparing...",
                style: stylePTSansBold(),
              ),
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/managers/market_scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/managers/top_gainer_scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/topGainer/offline_data_two.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/topGainer/online_data.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/widget/widget_preparing.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/services/streams/gainers_stream.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';

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
      // _callPort();
      context.read<MarketScannerM>().stopListeningPorts();
      TopGainerScannerM provider =
          context.read<TopGainerScannerM>();
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
  Widget build(BuildContext context) {
    TopGainerScannerM provider =
        context.watch<TopGainerScannerM>();
    return CommonRefreshIndicator(
      onRefresh: () async {
        await _callPort();
        MarketGainersStream().initializePorts();
        provider.resetLiveFilter();
      },
      child: SingleChildScrollView(
        child: Consumer<TopGainerScannerM>(
          builder: (context, provider, child) {
            if (provider.dataList != null) {
              return TopGainerOnline();
            } else if (provider.offlineDataList != null) {
              return TopGainerOfflineTwo();
            } else {
              return ScannerPreparing();
            }
          },
        ),
      ),
    );
  }
}

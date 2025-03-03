import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/managers/market_scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/managers/top_loser_scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/topLoser/offline_data_two.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/topLoser/online_data.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/widget/widget_preparing.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/services/streams/losers_stream.dart';
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
      context.read<MarketScannerM>().stopListeningPorts();
      TopLoserScannerM provider =
          context.read<TopLoserScannerM>();
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
    TopLoserScannerM provider = context.read<TopLoserScannerM>();
    return CommonRefreshIndicator(
      onRefresh: () async {
        _callPort();

        MarketLosersStream().initializePorts();
        provider.resetLiveFilter();
      },
      child: SingleChildScrollView(
        child: Consumer<TopLoserScannerM>(
          builder: (context, provider, child) {
            if (provider.dataList != null) {
              return TopLosersOnline();
            }
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

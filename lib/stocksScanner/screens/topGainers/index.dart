// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
// import 'package:stocks_news_new/stocksScanner/providers/top_gainer_scanner_provider.dart';
// import 'package:stocks_news_new/stocksScanner/screens/stockScanner/widget_preparing.dart';
// import 'package:stocks_news_new/stocksScanner/screens/topGainers/offline_data_two.dart';
// import 'package:stocks_news_new/stocksScanner/screens/topGainers/online_data.dart';

// import 'offline_data.dart';

// class ScannerTopGainer extends StatefulWidget {
//   const ScannerTopGainer({super.key});

//   @override
//   State<ScannerTopGainer> createState() => _ScannerTopGainerState();
// }

// class _ScannerTopGainerState extends State<ScannerTopGainer> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<MarketScannerProvider>().stopListeningPorts();
//       TopGainerScannerProvider provider =
//           context.read<TopGainerScannerProvider>();
//       provider.startListeningPorts();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     MarketScannerProvider marketScannerProvider =
//         context.watch<MarketScannerProvider>();

//     return SingleChildScrollView(
//       child: Consumer<TopGainerScannerProvider>(
//         builder: (context, provider, child) {
//           if (provider.dataList != null) {
//             return TopGainerOnline();
//           }
//            else if (provider.offlineDataList != null &&
//               marketScannerProvider.scannerIndex == 2) {
//             return TopGainerOffline();
//           }
//           else if (provider.offlineDataList != null) {
//             return TopGainerOfflineTwo();
//           } else {
//             return ScannerPreparing();
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/providers/top_gainer_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/screens/stockScanner/widget_preparing.dart';
import 'package:stocks_news_new/stocksScanner/screens/topGainers/offline_data_two.dart';
import 'package:stocks_news_new/stocksScanner/screens/topGainers/online_data.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';

import '../../manager/gainers_stream.dart';

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
      _callPort();
      context.read<MarketScannerProvider>().stopListeningPorts();
      TopGainerScannerProvider provider =
          context.read<TopGainerScannerProvider>();
      provider.startListeningPorts();
    });
  }

  _callPort() async {
    MarketScannerProvider scannerProvider =
        context.read<MarketScannerProvider>();

    await scannerProvider.getScannerPorts(
      loading: true,
      start: false,
      set: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    TopGainerScannerProvider provider =
        context.watch<TopGainerScannerProvider>();
    return CommonRefreshIndicator(
      onRefresh: () async {
        await _callPort();
        MarketGainersStream().initializePorts();
        provider.resetLiveFilter();
      },
      child: SingleChildScrollView(
        child: Consumer<TopGainerScannerProvider>(
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

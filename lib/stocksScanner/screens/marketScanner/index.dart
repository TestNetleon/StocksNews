// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
// import 'package:stocks_news_new/stocksScanner/screens/marketScanner/offline_data.dart';
// import 'package:stocks_news_new/stocksScanner/screens/marketScanner/offline_data_two.dart';
// import 'package:stocks_news_new/stocksScanner/screens/marketScanner/online_data.dart';
// import 'package:stocks_news_new/stocksScanner/screens/stockScanner/widget_preparing.dart';

// class MarketScanner extends StatefulWidget {
//   const MarketScanner({super.key});

//   @override
//   State<MarketScanner> createState() => _MarketScannerState();
// }

// class _MarketScannerState extends State<MarketScanner> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       MarketScannerProvider provider = context.read<MarketScannerProvider>();
//       provider.startListeningPorts();
//     });
//   }

//   @override
//   void dispose() {
//     // MarketScannerProvider provider = context.read<MarketScannerProvider>();
//     // provider.stopListeningPorts();
//     // Utils().showLog("DISPOSE CALLED");
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Consumer<MarketScannerProvider>(
//         builder: (context, provider, child) {
//           if (provider.dataList != null) {
//             return MarketScannerOnline();
//           } else if (provider.offlineDataList != null &&
//               provider.scannerIndex == 2) {
//             return MarketScannerOffline();
//           } else if (provider.offlineDataList != null &&
//               provider.scannerIndex == 3) {
//             return MarketScannerOfflineTwo();
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
import 'package:stocks_news_new/stocksScanner/screens/marketScanner/offline_data_two.dart';
import 'package:stocks_news_new/stocksScanner/screens/marketScanner/online_data.dart';
import 'package:stocks_news_new/stocksScanner/screens/stockScanner/widget_preparing.dart';
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
      _callPort();
      MarketScannerProvider provider = context.read<MarketScannerProvider>();
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
  void dispose() {
    // MarketScannerProvider provider = context.read<MarketScannerProvider>();
    // provider.stopListeningPorts();
    // Utils().showLog("DISPOSE CALLED");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonRefreshIndicator(
      onRefresh: () async {
        _callPort();
        MarketScannerProvider provider = context.read<MarketScannerProvider>();
        provider.startListeningPorts();
      },
      child: SingleChildScrollView(
        child: Consumer<MarketScannerProvider>(
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

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
// import 'package:stocks_news_new/stocksScanner/manager/gainers_stream.dart';
// import 'package:stocks_news_new/stocksScanner/manager/losers_stream.dart';
// import 'package:stocks_news_new/stocksScanner/manager/scanner_stream.dart';
// import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
// import 'package:stocks_news_new/stocksScanner/screens/marketScanner/market_scanner_filter.dart';
// import 'package:stocks_news_new/stocksScanner/screens/stockScanner/scanner_container.dart';
// import 'package:stocks_news_new/stocksScanner/screens/stockScanner/scanner_webview.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';
// import 'package:stocks_news_new/widgets/loading.dart';

// //MARK: WEB
// class StocksScanner extends StatefulWidget {
//   const StocksScanner({super.key});

//   @override
//   State<StocksScanner> createState() => _StocksScannerState();
// }

// class _StocksScannerState extends State<StocksScanner> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     // MarketScannerProvider provider = context.watch<MarketScannerProvider>();
//     return BaseContainer(
//       appBar: AppBarHome(
//         isPopBack: true,
//         title: "Stocks Scanner",
//         canSearch: false,
//         showTrailing: false,
//         isScannerFilter: false,
//       ),
//       body: ScannerWebview(),
//     );
//   }
// }

// //MARK: APP
// class StocksScannerApp extends StatefulWidget {
//   const StocksScannerApp({super.key});

//   @override
//   State<StocksScannerApp> createState() => _StocksScannerAppState();
// }

// class _StocksScannerAppState extends State<StocksScannerApp> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<MarketScannerProvider>().getScannerPorts();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     MarketScannerProvider provider = context.watch<MarketScannerProvider>();
//     return PopScope(
//       onPopInvokedWithResult: (didPop, result) {
//         MarketScannerStream().stopListeningPorts();
//         MarketGainersStream().stopListeningPorts();
//         MarketLosersStream().stopListeningPorts();
//       },
//       child: BaseContainer(
//         appBar: AppBarHome(
//           isPopBack: true,
//           title: "Stocks Scanner",
//           canSearch: false,
//           showTrailing: false,
//           isScannerFilter: true,
//           onFilterClick: () {
//             Navigator.push(
//               context,
//               createRoute(MarketScannerFilter()),
//             );
//           },
//         ),
//         body: provider.isLoading ? Loading() : ScannerContainer(),
//       ),
//     );
//   }
// }

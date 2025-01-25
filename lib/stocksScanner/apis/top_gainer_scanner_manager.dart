// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
// import 'package:stocks_news_new/stocksScanner/providers/top_gainer_scanner_provider.dart';
// import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';

// import '../../routes/my_app.dart';
// import '../manager/client.dart';
// import 'streaming_data.dart';

// class TopGainerScannerDataManager {
//   static final TopGainerScannerDataManager instance =
//       TopGainerScannerDataManager._internal();

//   TopGainerScannerDataManager._internal();

//   factory TopGainerScannerDataManager() {
//     return instance;
//   }

//   bool isOfflineCalled = false;
//   bool listening = true;
//   int checkInterval = 120000;
//   int checkOfflineInterval = 5000;

//   Future<void> initializePorts() async {
//     listening = true;
//     isOfflineCalled = false;

//     TopGainerScannerProvider provider =
//         navigatorKey.currentContext!.read<TopGainerScannerProvider>();

//     MarketScannerProvider scannerProvider =
//         navigatorKey.currentContext!.read<MarketScannerProvider>();
//     bool? callOffline =
//         scannerProvider.port?.port?.checkMarketOpenApi?.checkPostMarket == true;
//     Utils().showLog('Call Offline $callOffline');
//     if (callOffline) {
//       await getOfflineData();
//       return;
//     }

//     int? port = scannerProvider.port?.port?.gainerLoserPort?.gainer ?? 8021;
//     final url = 'https://dev.stocks.news:$port/topGainersLosers?type=gainers';

//     try {
//       // Check offline data condition
//       Timer(Duration(milliseconds: checkOfflineInterval), () async {
//         if (!isOfflineCalled && provider.offlineDataList == null && listening) {
//           isOfflineCalled = true;
//           await getOfflineData();
//         }
//       });

//       // Connect to SSE stream
//       final sseClient = SSEClient(url);

//       await for (var eventData in sseClient.listen()) {
//         if (!listening) {
//           break;
//         }

//         // Process the event data
//         isOfflineCalled = true;
//         try {
//           final List<dynamic> decodedResponse = jsonDecode(eventData);
//           await provider.updateData(marketScannerResFromJson(decodedResponse));
//         } catch (e) {
//           Utils().showLog("Error processing event data: $e");
//         }
//       }
//     } catch (e) {
//       if (!isOfflineCalled) {
//         isOfflineCalled = true;
//         if (navigatorKey.currentContext!
//                 .read<TopGainerScannerProvider>()
//                 .offlineDataList ==
//             null) {
//           await getOfflineData();
//         }
//       }
//     }
//   }

//   // Method to stop listening to event streams
//   void stopListeningPorts() {
//     listening = false;
//     Utils().showLog("Stopped listening to event sources.");
//   }

//   // Method to fetch offline data
//   Future<void> getOfflineData() async {
//     try {
//       MarketScannerProvider scannerProvider =
//           navigatorKey.currentContext!.read<MarketScannerProvider>();

//       int? port = scannerProvider.port?.port?.otherPortRes?.offline ?? 8080;
//       final url =
//           Uri.parse('https://dev.stocks.news:$port/topGainer?shortBy=2');
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         Utils().showLog(response.body);
//         final List<dynamic> decodedResponse = jsonDecode(response.body);
//         TopGainerScannerProvider provider =
//             navigatorKey.currentContext!.read<TopGainerScannerProvider>();
//         provider.updateOfflineData(scannerResFromJson(decodedResponse));
//       } else {
//         Utils().showLog('Error fetching offline data: ${response.statusCode}');
//       }
//     } catch (e) {
//       Utils().showLog("Error fetching offline data: $e");
//     }
//   }
// }

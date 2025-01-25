// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// // import 'package:eventsource3/eventsource.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/routes/my_app.dart';
// import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
// import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
// import 'package:stocks_news_new/stocksScanner/providers/top_loser_scanner_provider.dart';
// import 'package:stocks_news_new/utils/utils.dart';

// import '../manager/client.dart';
// import '../providers/market_scanner_provider.dart';

// class TopLoserScannerDataManager {
//   static final TopLoserScannerDataManager instance =
//       TopLoserScannerDataManager._internal();

//   TopLoserScannerDataManager._internal();

//   factory TopLoserScannerDataManager() {
//     return instance;
//   }

//   bool subscribed = true;
//   // static const checkInterval = 5000;
//   var isOfflineCalled = false;
//   var listening = true;
//   int checkInterval = 12000;
//   int checkOfflineInterval = 5000;

//   void initializePorts() async {
//     listening = true;
//     isOfflineCalled = false;
//     TopLoserScannerProvider provider =
//         navigatorKey.currentContext!.read<TopLoserScannerProvider>();
//     MarketScannerProvider scannerProvider =
//         navigatorKey.currentContext!.read<MarketScannerProvider>();

//     int? port = scannerProvider.port?.port?.gainerLoserPort?.loser ?? 8021;
//     try {
//       bool? callOffline =
//           scannerProvider.port?.port?.checkMarketOpenApi?.checkPostMarket ==
//               true;

//       if (callOffline) {
//         await getOfflineData();
//         return;
//       }
//     } catch (e) {
// //
//     }

//     try {
//       final url = 'https://dev.stocks.news:$port/topGainersLosers?type=losers';
//       Utils().showLog('running for.. $url');

//       Utils().showLog("Loops starts");
//       Timer(Duration(milliseconds: checkOfflineInterval), () async {
//         if (!isOfflineCalled) {
//           isOfflineCalled = true;
//           if (navigatorKey.currentContext!
//                       .read<TopLoserScannerProvider>()
//                       .offlineDataList ==
//                   null &&
//               listening == true) {
//             await getOfflineData();
//           }
//         }
//       });
//       // Connect to SSE stream
//       final sseClient = SSEClient(url);
//       Utils().showLog('HI');
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
//                 .read<TopLoserScannerProvider>()
//                 .offlineDataList ==
//             null) {
//           await getOfflineData();
//         }
//       }
//     }
//   }

//   // Method to cancel all StreamSubscriptions
//   void stopListeningPorts() {
//     listening = false;
//   }

//   Future getOfflineData() async {
//     // if (isOfflineCalled) return;
//     // showGlobalProgressDialog();
//     try {
//       MarketScannerProvider scannerProvider =
//           navigatorKey.currentContext!.read<MarketScannerProvider>();

//       int? port = scannerProvider.port?.port?.otherPortRes?.offline ?? 8080;
//       final url = Uri.parse(
//         'https://dev.stocks.news:$port/topLoser?shortBy=2',
//       );
//       Utils().showLog("$url");
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         Utils().showLog(response.body);
//         final List<dynamic> decodedResponse = jsonDecode(response.body);
//         TopLoserScannerProvider provider =
//             navigatorKey.currentContext!.read<TopLoserScannerProvider>();
//         provider.updateOfflineData(scannerResFromJson(decodedResponse));
//       } else {
//         Utils().showLog('Error fetching data from $url');
//       }
//     } catch (err) {
//       Utils().showLog('Error: Offline data fetched $err');
//     }
//     // closeGlobalProgressDialog();
//   }
// }

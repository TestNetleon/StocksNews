import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/providers/top_loser_scanner_provider.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../manager/client.dart';
import '../providers/market_scanner_provider.dart';

// class MarketLosersStream {
//   static final MarketLosersStream instance = MarketLosersStream._internal();

//   MarketLosersStream._internal();

//   factory MarketLosersStream() {
//     return instance;
//   }

//   bool subscribed = true;
//   var isOfflineCalled = false;
//   var listening = true;
//   int checkInterval = 12000;
//   int checkOfflineInterval = 5000;
//   final Map<String, SSEClient> _activeConnections = {};

//   void initializePorts() async {
//     listening = true;
//     isOfflineCalled = false;

//     final provider =
//         navigatorKey.currentContext!.read<TopLoserScannerProvider>();
//     final scannerProvider =
//         navigatorKey.currentContext!.read<MarketScannerProvider>();

//     int? port = scannerProvider.port?.port?.gainerLoserPort?.loser ?? 8021;

//     // Check if we need offline data first
//     final callOffline =
//         scannerProvider.port?.port?.checkMarketOpenApi?.checkPostMarket ??
//             false;
//     if (callOffline) {
//       await getOfflineData();
//       return;
//     }

//     try {
//       final url = 'https://dev.stocks.news:$port/topGainersLosers?type=losers';
//       Utils().showLog('running for.. $url');

//       // Handle offline data check periodically
//       Timer(Duration(milliseconds: checkOfflineInterval), () async {
//         if (!isOfflineCalled) {
//           isOfflineCalled = true;
//           if (navigatorKey.currentContext!
//                       .read<TopLoserScannerProvider>()
//                       .offlineDataList ==
//                   null &&
//               listening) {
//             await getOfflineData();
//           }
//         }
//       });

//       // Connect to SSE stream
//       final sseClient = SSEClient(url);

//       // Track active SSE connection
//       _activeConnections[url] = sseClient;
//       await for (var eventData in sseClient.listen()) {
//         if (!listening) break;

//         try {
//           final List<dynamic> decodedResponse = jsonDecode(eventData);
//           await provider.updateData(marketScannerResFromJson(decodedResponse));
//           isOfflineCalled = true;
//         } catch (e) {
//           Utils().showLog("Error processing event data: $e");
//         }
//       }
//     } catch (e) {
//       // Handle network failures
//       if (!isOfflineCalled) {
//         isOfflineCalled = true;
//         if (provider.offlineDataList == null) {
//           await getOfflineData();
//         }
//       }
//     }
//   }

//   Future<void> getOfflineData() async {
//     try {
//       final scannerProvider =
//           navigatorKey.currentContext!.read<MarketScannerProvider>();
//       int? port = scannerProvider.port?.port?.otherPortRes?.offline ?? 8080;
//       final url = Uri.parse('https://dev.stocks.news:$port/topLoser?shortBy=2');

//       Utils().showLog("$url");

//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final List<dynamic> decodedResponse = jsonDecode(response.body);
//         final provider =
//             navigatorKey.currentContext!.read<TopLoserScannerProvider>();
//         provider.updateOfflineData(scannerResFromJson(decodedResponse));
//       } else {
//         Utils().showLog('Error fetching data from $url');
//       }
//     } catch (err) {
//       Utils().showLog('Error fetching offline data: $err');
//     }
//   }

//   Future<void> stopListeningPorts() async {
//     listening = false;

//     // Close all active SSE connections
//     for (final client in _activeConnections.values) {
//       client.close(); // Close each SSE connection
//     }

//     _activeConnections.clear(); // Clear the map after closing connections
//     Utils().showLog("Stopped all SSE connections.");
//   }
// }

class MarketLosersStream {
  static final MarketLosersStream instance = MarketLosersStream._internal();

  MarketLosersStream._internal();

  factory MarketLosersStream() {
    return instance;
  }

  bool subscribed = true;
  var isOfflineCalled = false;
  var listening = true;
  int checkInterval = 12000;
  int checkOfflineInterval = 5000;
  final Map<String, SSEClient> _activeConnections = {};

  Future<void> initializePorts() async {
    listening = true;
    isOfflineCalled = false;

    final provider =
        navigatorKey.currentContext!.read<TopLoserScannerProvider>();
    final scannerProvider =
        navigatorKey.currentContext!.read<MarketScannerProvider>();

    int? port = scannerProvider.port?.port?.gainerLoserPort?.loser ?? 8021;
    final callOffline =
        scannerProvider.port?.port?.checkMarketOpenApi?.checkPostMarket ??
            false;
    Utils().showLog('Call Offline $callOffline');

    // if (callOffline) {
    //   await getOfflineData();
    //   return;
    // }
    final url = 'https://dev.stocks.news:$port/topGainersLosers?type=losers';

    final sseClient = SSEClient(url);
    _activeConnections[url] = sseClient;
    Timer(Duration(milliseconds: checkOfflineInterval), () async {
      if (!isOfflineCalled && provider.offlineDataList == null && listening) {
        isOfflineCalled = true;
        await getOfflineData();
      }
    });
    try {
      await for (var eventData in sseClient.listen()) {
        if (!listening) break;

        isOfflineCalled = true;
        try {
          final List<dynamic> decodedResponse = jsonDecode(eventData);
          await provider.updateData(marketScannerResFromJson(decodedResponse));
        } catch (e) {
          Utils().showLog("Error processing event data: $e");
        }
      }
    } catch (e) {
      await _handleConnectionError();
    }
  }

  Future<void> _handleConnectionError() async {
    int retryCount = 0;
    const maxRetries = 2;
    const retryDelay = Duration(seconds: 3);

    while (retryCount < maxRetries) {
      try {
        await Future.delayed(retryDelay * retryCount);
        await initializePorts(); // Retry initialization
        break; // Success, exit loop
      } catch (e) {
        retryCount++;
        if (retryCount == maxRetries) {
          await getOfflineData(); // Fall back after max retries
        }
      }
    }
  }

  Future<void> _handleNetworkFailure() async {
    if (!isOfflineCalled) {
      isOfflineCalled = true;
      final provider =
          navigatorKey.currentContext!.read<TopLoserScannerProvider>();
      if (provider.offlineDataList == null) {
        await getOfflineData();
      }
    }
  }

  Future<void> getOfflineData() async {
    try {
      final scannerProvider =
          navigatorKey.currentContext!.read<MarketScannerProvider>();
      int? port = scannerProvider.port?.port?.otherPortRes?.offline ?? 8080;
      final url = Uri.parse('https://dev.stocks.news:$port/topLoser?shortBy=2');
      Utils().showLog("Fetching offline data from $url");

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = jsonDecode(response.body);
        final provider =
            navigatorKey.currentContext!.read<TopLoserScannerProvider>();
        provider.updateOfflineData(scannerResFromJson(decodedResponse));
      } else {
        Utils().showLog('Error fetching data from $url');
      }
    } catch (err) {
      Utils().showLog('Error fetching offline data: $err');
    }
  }

  Future<void> stopListeningPorts() async {
    listening = false;
    for (final client in _activeConnections.values) {
      client.close();
    }
    _activeConnections.clear();
    Utils().showLog("Stopped all SSE connections.");
  }
}

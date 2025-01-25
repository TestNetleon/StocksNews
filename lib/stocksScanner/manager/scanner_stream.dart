// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/routes/my_app.dart';
// import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
// import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
// import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
// import 'package:stocks_news_new/utils/utils.dart';

// import '../manager/client.dart';

// class MarketScannerStream {
//   static final MarketScannerStream instance = MarketScannerStream._internal();
//   MarketScannerStream._internal();

//   factory MarketScannerStream() {
//     return instance;
//   }

//   bool _isOfflineCalled = false;
//   bool _isListening = false;
//   final Map<String, SSEClient> _activeConnections = {};

//   static const int checkOfflineInterval = 5000;

//   bool get isListening => _isListening;

//   Future<void> initializePorts() async {
//     if (_isListening) {
//       await stopListeningPorts(); // Stop any existing connections first
//     }

//     _isListening = true;
//     _isOfflineCalled = false;

//     final provider = navigatorKey.currentContext!.read<MarketScannerProvider>();

//     int? startingPort = provider.port?.port?.scannerPort?.start ?? 8021;
//     int? endingPort = provider.port?.port?.scannerPort?.end ?? 8040;
//     bool? callOffline =
//         provider.port?.port?.checkMarketOpenApi?.checkPostMarket == true;

//     Utils().showLog('Call Offline $callOffline');

//     if (callOffline) {
//       await getOfflineData();
//       return;
//     }

//     // Create URLs for all ports
//     final urls = List.generate(
//       endingPort - startingPort + 1,
//       (index) => "https://dev.stocks.news:${startingPort + index}/sse",
//     );

//     // Set offline data timer
//     Timer(Duration(milliseconds: checkOfflineInterval), () async {
//       if (!_isOfflineCalled &&
//           provider.offlineDataList == null &&
//           _isListening) {
//         _isOfflineCalled = true;
//         await getOfflineData();
//       }
//     });

//     try {
//       Utils().showLog("Starting connection to event sources...");
//       await Future.wait(
//         urls.map((url) => _connectToSseClient(url, provider)),
//       );
//     } catch (e) {
//       Utils().showLog("Error initializing ports: $e");
//       if (!_isOfflineCalled && provider.offlineDataList == null) {
//         _isOfflineCalled = true;
//         await getOfflineData();
//       }
//     }
//   }

//   Future<void> _connectToSseClient(
//       String url, MarketScannerProvider provider) async {
//     try {
//       Utils().showLog("Connecting to $url...");

//       // Use SSEClient to listen to the SSE stream
//       final sseClient = SSEClient(url);
//       _activeConnections[url] = sseClient; // Track the connection

//       final eventStream = sseClient.listen();

//       await for (final event in eventStream) {
//         if (!_isListening) {
//           sseClient.close(); // Close the connection if listening stops
//           _activeConnections.remove(url); // Remove from tracking
//           break;
//         }

//         if (event.isNotEmpty) {
//           _handleEventData(event, provider);
//         }
//       }
//     } catch (e) {
//       Utils().showLog("Failed to connect to $url: $e");
//       _activeConnections.remove(url); // Cleanup on failure
//       await _retryConnection(url, provider);
//     }
//   }

//   Future<void> _retryConnection(
//       String url, MarketScannerProvider provider) async {
//     // Retry connection with backoff logic
//     int retryCount = 0;
//     const maxRetries = 5;
//     const retryDelay = Duration(seconds: 5);

//     while (retryCount < maxRetries) {
//       try {
//         Utils().showLog("Retrying connection to $url...");
//         await Future.delayed(retryDelay * retryCount);
//         await _connectToSseClient(url, provider);
//         break; // Successfully connected, exit the loop
//       } catch (e) {
//         retryCount++;
//         if (retryCount == maxRetries) {
//           Utils().showLog("Failed to connect after $maxRetries attempts: $e");
//         }
//       }
//     }
//   }

//   void _handleEventData(String data, MarketScannerProvider provider) {
//     try {
//       _isOfflineCalled = false;
//       final List<dynamic> decodedResponse = jsonDecode(data);

//       provider.updateData(marketScannerResFromJson(decodedResponse));
//       Utils().showLog("Event data processed successfully");
//     } catch (e) {
//       Utils().showLog("Error processing event data: $e");
//     }
//   }

//     Future<void> stopListeningPorts() async {
//       _isListening = false;

//       // Close all active SSE connections
//       for (final client in _activeConnections.values) {
//         client.close(); // Close each SSE connection
//       }

//       _activeConnections.clear(); // Clear the map after closing connections
//       Utils().showLog("Stopped all SSE connections.");
//     }

//   Future<void> getOfflineData() async {
//     final provider = navigatorKey.currentContext!.read<MarketScannerProvider>();

//     int? port = provider.port?.port?.otherPortRes?.offline ?? 8080;

//     final url = Uri.parse(
//       'https://dev.stocks.news:$port/getScreener?sector=${provider.filterParams?.sector}',
//     );

//     try {
//       final response = await http.get(url).timeout(Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         final List<dynamic> decodedResponse = jsonDecode(response.body);
//         provider.updateOfflineData(scannerResFromJson(decodedResponse));
//       } else {
//         Utils().showLog('Error fetching offline data: ${response.statusCode}');
//       }
//     } on TimeoutException {
//       Utils().showLog('Request to fetch offline data timed out');
//     }
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../manager/client.dart';
import '../providers/market_scanner_provider.dart';

class MarketScannerStream {
  static final MarketScannerStream instance = MarketScannerStream._internal();
  MarketScannerStream._internal();

  factory MarketScannerStream() {
    return instance;
  }

  bool _isOfflineCalled = false;
  bool _isListening = false;
  static const int checkOfflineInterval = 5000;
  final Map<String, SSEClient> _activeConnections = {};

  bool get isListening => _isListening;

  Future<void> initializePorts() async {
    if (_isListening) {
      await stopListeningPorts(); // Stop existing connections first
    }

    _isListening = true;
    _isOfflineCalled = false;

    final provider = navigatorKey.currentContext!.read<MarketScannerProvider>();
    final startingPort = provider.port?.port?.scannerPort?.start ?? 8021;
    final endingPort = provider.port?.port?.scannerPort?.end ?? 8040;
    final callOffline =
        provider.port?.port?.checkMarketOpenApi?.checkPostMarket == true;

    Utils().showLog('Call Offline $callOffline');

    // if (callOffline) {
    //   await getOfflineData();
    //   return;
    // }

    final urls = List.generate(
      endingPort - startingPort + 1,
      (index) => "https://dev.stocks.news:${startingPort + index}/sse",
    );

    // Set offline data timer
    Timer(Duration(milliseconds: checkOfflineInterval), () async {
      if (!_isOfflineCalled &&
          provider.offlineDataList == null &&
          _isListening) {
        _isOfflineCalled = true;
        await getOfflineData();
      }
    });

    try {
      Utils().showLog("Starting connection to event sources...");
      await Future.wait(urls.map((url) => _connectToSseClient(url, provider)));
    } catch (e) {
      Utils().showLog("Error initializing ports: $e");
      if (!_isOfflineCalled && provider.offlineDataList == null) {
        _isOfflineCalled = true;
        await getOfflineData();
      }
    }
  }

  Future<void> _connectToSseClient(
      String url, MarketScannerProvider provider) async {
    try {
      Utils().showLog("Connecting to $url...");

      final sseClient = SSEClient(url);
      _activeConnections[url] = sseClient;

      await for (final event in sseClient.listen()) {
        if (!_isListening) {
          // sseClient.close();
          _activeConnections.remove(url);
          break;
        }

        if (event.isNotEmpty) {
          _handleEventData(event, provider);
        }
      }
    } catch (e) {
      Utils().showLog("Failed to connect to $url: $e");
      _activeConnections.remove(url);
      await _retryConnection(url, provider);
    }
  }

  Future<void> _retryConnection(
      String url, MarketScannerProvider provider) async {
    int retryCount = 0;
    const maxRetries = 2;
    const retryDelay = Duration(seconds: 5);

    while (retryCount < maxRetries) {
      try {
        Utils().showLog("Retrying connection to $url...");
        await Future.delayed(retryDelay * retryCount);
        await _connectToSseClient(url, provider);
        break;
      } catch (e) {
        retryCount++;
        if (retryCount == maxRetries) {
          Utils().showLog("Failed to connect after $maxRetries attempts: $e");
        }
      }
    }
  }

  void _handleEventData(String data, MarketScannerProvider provider) {
    try {
      _isOfflineCalled = false;
      final List<dynamic> decodedResponse = jsonDecode(data);

      provider.updateData(marketScannerResFromJson(decodedResponse));
      Utils().showLog("Event data processed successfully");
    } catch (e) {
      Utils().showLog("Error processing event data: $e");
    }
  }

  Future<void> stopListeningPorts() async {
    _isListening = false;

    for (final client in _activeConnections.values) {
      client.close();
    }

    _activeConnections.clear();
    Utils().showLog("Stopped all SSE connections.");
  }

  Future<void> getOfflineData() async {
    final provider = navigatorKey.currentContext!.read<MarketScannerProvider>();

    final port = provider.port?.port?.otherPortRes?.offline ?? 8080;
    final url = Uri.parse(
        'https://dev.stocks.news:$port/getScreener?sector=${provider.filterParams?.sector}');

    try {
      final response = await http.get(url).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = jsonDecode(response.body);
        provider.updateOfflineData(scannerResFromJson(decodedResponse));
      } else {
        Utils().showLog('Error fetching offline data: ${response.statusCode}');
      }
    } on TimeoutException {
      Utils().showLog('Request to fetch offline data timed out');
    }
  }
}

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

// class MarketScannerDataManager {
//   static final MarketScannerDataManager instance =
//       MarketScannerDataManager._internal();
//   MarketScannerDataManager._internal();

//   factory MarketScannerDataManager() {
//     return instance;
//   }

//   bool _isOfflineCalled = false;
//   bool _isListening = false;
//   static const int checkInterval = 180000;
//   static const int checkOfflineInterval = 5000;

//   bool get isListening => _isListening;

//   Future<void> initializePorts() async {
//     if (_isListening) {
//       await stopListeningPorts(); // Ensure clean state before starting
//     }

//     _isListening = true;
//     _isOfflineCalled = false;

//     MarketScannerProvider provider =
//         navigatorKey.currentContext!.read<MarketScannerProvider>();

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
//           _isListening == true) {
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

//       SSEClient sseClient = SSEClient(url);
//       Stream<String> eventStream = sseClient.listen();

//       // Listen for the events and process data
//       await for (var event in eventStream) {
//         if (!_isListening) return;

//         if (event.isNotEmpty) {
//           _handleEventData(event, provider);
//         }
//       }
//     } catch (e) {
//       Utils().showLog("Failed to connect to $url: $e");
//       await _retryConnection(url, provider);
//     }
//   }

//   Future<void> _retryConnection(
//       String url, MarketScannerProvider provider) async {
//     // Retry connection with backoff logic
//     int retryCount = 0;
//     final maxRetries = 5;
//     final retryDelay = Duration(seconds: 5);

//     while (retryCount < maxRetries) {
//       try {
//         Utils().showLog("Retrying connection to $url...");
//         await Future.delayed(retryDelay * retryCount);
//         await _connectToSseClient(url, provider);
//         break; // Successfully connected, break the loop
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

//   Future<void> stopListeningPorts() async {
//     _isListening = false;
//     Utils().showLog("Stopped all EventSource listeners.");
//   }

//   Future<void> getOfflineData() async {
//     final provider = navigatorKey.currentContext!.read<MarketScannerProvider>();

//     int? port = provider.port?.port?.otherPortRes?.offline ?? 8080;

//     final url = Uri.parse(
//       'https://dev.stocks.news:$port/getScreener?sector=${provider.filterParams?.sector}',
//     );
//     final response = await http.get(url).timeout(Duration(seconds: 10));

//     try {
//       if (response.statusCode == 200) {
//         final List<dynamic> decodedResponse = jsonDecode(response.body);
//         provider.updateOfflineData(scannerResFromJson(decodedResponse));
//       } else {
//         Utils().showLog('Error fetching offline data: ${response.statusCode}');
//       }
//     } on TimeoutException catch (_) {
//       Utils().showLog('Request to fetch offline data timed out');
//     }
//   }
// }

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

// class MarketScannerDataManager {
//   static final MarketScannerDataManager instance =
//       MarketScannerDataManager._internal();

//   MarketScannerDataManager._internal();

//   bool _isOfflineCalled = false;
//   bool _isListening = false;

//   static const int checkInterval = 180000;
//   static const int checkOfflineInterval = 5000;

//   bool get isListening => _isListening;

// //MARK: Initialize Port
//   Future<void> initializePorts() async {
//     if (_isListening) {
//       await stopListeningPorts();
//     }

//     _isListening = true;
//     _isOfflineCalled = false;

//     final provider = navigatorKey.currentContext!.read<MarketScannerProvider>();

//     final startingPort = provider.port?.port?.scannerPort?.start ?? 8021;
//     final endingPort = provider.port?.port?.scannerPort?.end ?? 8040;
//     final callOffline =
//         provider.port?.port?.checkMarketOpenApi?.checkPostMarket == true;

//     Utils().showLog('Call Offline: $callOffline');
//     if (callOffline) {
//       await getOfflineData();
//       return;
//     }

//     final urls = List.generate(
//       endingPort - startingPort + 1,
//       (index) => "https://dev.stocks.news:${startingPort + index}/sse",
//     );

//     Timer(Duration(milliseconds: checkOfflineInterval), () async {
//       if (!_isOfflineCalled &&
//           provider.offlineDataList == null &&
//           _isListening) {
//         _isOfflineCalled = true;
//         await getOfflineData();
//       }
//     });

//     try {
//       Utils().showLog("Starting connections to SSE servers...");
//       await Future.wait(urls.map((url) => _connectToSseClient(url, provider)));
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

//       final sseClient = SSEClient(url);
//       final eventStream = sseClient.listen();

//       await for (var event in eventStream) {
//         if (!_isListening) return;

//         if (event.isNotEmpty) {
//           _handleEventData(event, provider);
//         }
//       }
//     } catch (e) {
//       Utils().showLog("Connection failed to $url: $e");
//       await _retryConnection(url, provider);
//     }
//   }

//   Future<void> _retryConnection(
//       String url, MarketScannerProvider provider) async {
//     const maxRetries = 5;
//     const retryDelay = Duration(seconds: 5);

//     for (int attempt = 1; attempt <= maxRetries; attempt++) {
//       try {
//         Utils().showLog("Retrying connection to $url (Attempt $attempt)...");
//         await Future.delayed(retryDelay * attempt);
//         await _connectToSseClient(url, provider);
//         break;
//       } catch (e) {
//         if (attempt == maxRetries) {
//           Utils()
//               .showLog("Max retries reached. Failed to reconnect to $url: $e");
//         }
//       }
//     }
//   }

//   void _handleEventData(String data, MarketScannerProvider provider) {
//     try {
//       _isOfflineCalled = false;
//       final decodedResponse = jsonDecode(data) as List<dynamic>;

//       provider.updateData(marketScannerResFromJson(decodedResponse));
//       Utils().showLog("Event data processed successfully.");
//     } catch (e) {
//       Utils().showLog("Error processing event data: $e");
//     }
//   }

// //MARK: Stop listening
//   Future<void> stopListeningPorts() async {
//     _isListening = false;
//     Utils().showLog("Stopped all SSE connections.");
//   }

//   ///MARK: Offline
//   Future<void> getOfflineData() async {
//     final provider = navigatorKey.currentContext!.read<MarketScannerProvider>();
//     final port = provider.port?.port?.otherPortRes?.offline ?? 8080;

//     final url = Uri.parse(
//       'https://dev.stocks.news:$port/getScreener?sector=${provider.filterParams?.sector}',
//     );

//     try {
//       final response = await http.get(url).timeout(Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         final decodedResponse = jsonDecode(response.body) as List<dynamic>;
//         provider.updateOfflineData(scannerResFromJson(decodedResponse));
//         Utils().showLog("Offline data fetched successfully.");
//       } else {
//         Utils().showLog(
//             "Error fetching offline data. Status code: ${response.statusCode}");
//       }
//     } on TimeoutException {
//       Utils().showLog("Request to fetch offline data timed out.");
//     } catch (e) {
//       Utils().showLog("Error fetching offline data: $e");
//     }
//   }
// }

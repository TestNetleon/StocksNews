import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/live.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/offline.dart';

import 'package:stocks_news_new/utils/utils.dart';

import 'client.dart';

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

    ScannerManager provider =
        navigatorKey.currentContext!.read<ScannerManager>();
    final startingPort = provider.portData?.port?.scanner?.start ?? 8021;
    final endingPort = provider.portData?.port?.scanner?.end ?? 8040;

    final checkPostMarket =
        provider.portData?.port?.checkMarketOpenApi?.checkPostMarket == true;

    final postMarketStream =
        provider.portData?.port?.checkMarketOpenApi?.postMarketStream == true;

    Utils().showLog(
        'Call Offline ${checkPostMarket && postMarketStream == false}');

    if (checkPostMarket && !postMarketStream) {
      await getOfflineData();
      return;
    }

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

  Future<void> _connectToSseClient(String url, ScannerManager provider) async {
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
      getOfflineData();

      // await _retryConnection(url, provider);
    }
  }

  void _handleEventData(String data, ScannerManager provider) {
    try {
      _isOfflineCalled = false;
      final List<dynamic> decodedResponse = jsonDecode(data);

      provider.updateData(liveScannerResFromJson(decodedResponse));
      if (kDebugMode) {
        print("-----------------------------");
      }
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
    final provider = navigatorKey.currentContext!.read<ScannerManager>();

    final port = provider.portData?.port?.other?.offline ?? 8080;
    final url = Uri.parse(
        'https://dev.stocks.news:$port/getScreener?sector=${provider.filterParams?.sector}');

    try {
      final response = await http.get(url).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = jsonDecode(response.body);
        provider.updateOfflineData(offlineScannerResFromJson(decodedResponse));
      } else {
        Utils().showLog('Error fetching offline data: ${response.statusCode}');
      }
    } on TimeoutException {
      Utils().showLog('Request to fetch offline data timed out');
    }
  }
}

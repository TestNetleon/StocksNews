import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eventsource3/eventsource.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/utils/utils.dart';

class MarketScannerDataManager {
  static final MarketScannerDataManager instance =
      MarketScannerDataManager._internal();
  MarketScannerDataManager._internal();

  factory MarketScannerDataManager() {
    return instance;
  }

  final Map<String, EventSource> _eventSources = {};
  final Map<String, StreamSubscription> _eventSubscriptions = {};
  bool _isOfflineCalled = false;
  bool _isListening = false;
  static const int checkInterval = 5000;

  bool get isListening => _isListening;

  Future<void> initializePorts() async {
    if (_isListening) {
      await stopListeningPorts(); // Ensure clean state before starting
    }

    _isListening = true;
    _isOfflineCalled = false;

    MarketScannerProvider provider =
        navigatorKey.currentContext!.read<MarketScannerProvider>();

    // Create URLs for all ports
    final urls = List.generate(
        16, (index) => "https://dev.stocks.news:${8021 + index}/sse");

    // Set offline data timer
    Timer(Duration(milliseconds: checkInterval), () async {
      if (!_isOfflineCalled && provider.offlineDataList == null) {
        _isOfflineCalled = true;
        await getOfflineData();
      }
    });

    try {
      await Future.wait(
          urls.map((url) => _connectToEventSource(url, provider)));
    } catch (e) {
      Utils().showLog("Error initializing ports: $e");
      if (!_isOfflineCalled && provider.offlineDataList == null) {
        _isOfflineCalled = true;
        await getOfflineData();
      }
    }
  }

  Future<void> _connectToEventSource(
      String url, MarketScannerProvider provider) async {
    try {
      final eventSource =
          await EventSource.connect(url).timeout(Duration(seconds: 5));

      final subscription = eventSource.listen(
        (Event event) {
          if (!_isListening) return;

          if (event.data != null && event.data!.isNotEmpty) {
            _handleEventData(event.data!, provider);
          }
        },
        cancelOnError: true,
        onDone: () => Utils().showLog("Connection closed to $url"),
        onError: (err) => Utils().showLog("Error in connection to $url: $err"),
      );

      _eventSources[url] = eventSource;
      _eventSubscriptions[url] = subscription;
    } catch (e) {
      Utils().showLog("Failed to connect to $url: $e");
      throw e;
    }
  }

  void _handleEventData(String data, MarketScannerProvider provider) {
    try {
      _isOfflineCalled = false;
      final List<dynamic> decodedResponse = jsonDecode(data);
      provider.updateData(marketScannerResFromJson(decodedResponse));
    } catch (e) {
      Utils().showLog("Error processing event data: $e");
    }
  }

  Future<void> stopListeningPorts() async {
    _isListening = false;

    // Close EventSources
    // for (var entry in _eventSources.entries) {
    //   try {
    //     entry.value.client.close(); // Removed await since it returns void
    //     Utils().showLog("Closed EventSource for ${entry.key}");
    //   } catch (e) {
    //     Utils().showLog("Error closing EventSource for ${entry.key}: $e");
    //   }
    // }

    // Cancel subscriptions
    for (var entry in _eventSubscriptions.entries) {
      try {
        // await entry.value.cancel();
        entry.value.pause();
        Utils().showLog("Cancelled subscription for ${entry.key}");
      } catch (e) {
        Utils().showLog("Error cancelling subscription for ${entry.key}: $e");
      }
    }

    _eventSources.clear();
    _eventSubscriptions.clear();
  }

  Future<void> getOfflineData() async {
    final provider = navigatorKey.currentContext!.read<MarketScannerProvider>();

    try {
      final url = Uri.parse(
        'https://dev.stocks.news:8080/getScreener?sector=${provider.filterParams?.sector}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = jsonDecode(response.body);
        provider.updateOfflineData(scannerResFromJson(decodedResponse));
      } else {
        Utils().showLog('Error fetching offline data: ${response.statusCode}');
      }
    } catch (err) {
      Utils().showLog('Error fetching offline data: $err');
    }
  }
}

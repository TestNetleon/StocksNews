import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/providers/top_loser_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/screens/sorting/shorting.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../manager/client.dart';
import '../providers/market_scanner_provider.dart';

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

    if (callOffline) {
      await getOfflineData();
      return;
    }

    // final url = 'https://dev.stocks.news:$port/topGainersLosers?type=losers';

    final url = provider.filterParams?.sortBy == 3
        ? 'https://dev.stocks.news:$port/topGainersLosers?type=losersVolumeAsc'
        : 'https://dev.stocks.news:$port/topGainersLosers?type=losers';

    Utils().showLog("LIVE URL => $url");

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
          // TO STOP MIXING streaming because streaming not closing at all
          if (provider.filterParams?.sortBy == 2 &&
              sseClient.url !=
                  "https://dev.stocks.news:$port/topGainersLosers?type=losers") {
            return;
          } else if (provider.filterParams?.sortBy == 3 &&
              sseClient.url !=
                  "https://dev.stocks.news:$port/topGainersLosers?type=losersVolumeAsc") {
            return;
          }
          Utils().showLog("--- ${sseClient.url}");
          final List<dynamic> decodedResponse = jsonDecode(eventData);
          await provider.updateData(marketScannerResFromJson(decodedResponse));
        } catch (e) {
          Utils().showLog("Error processing event data: $e");
        }
      }
    } catch (e) {
      _activeConnections.remove(url);
      getOfflineData();
    }
  }

  // Future<void> _handleConnectionError() async {
  //   int retryCount = 0;
  //   const maxRetries = 2;
  //   const retryDelay = Duration(seconds: 3);

  //   while (retryCount < maxRetries) {
  //     try {
  //       await Future.delayed(retryDelay * retryCount);
  //       await initializePorts(); // Retry initialization
  //       break; // Success, exit loop
  //     } catch (e) {
  //       retryCount++;
  //       if (retryCount == maxRetries) {
  //         await getOfflineData(); // Fall back after max retries
  //       }
  //     }
  //   }
  // }

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
      final TopLoserScannerProvider topLoserProvider =
          navigatorKey.currentContext!.read<TopLoserScannerProvider>();
      int? port = scannerProvider.port?.port?.otherPortRes?.offline ?? 8080;
      // final url = Uri.parse('https://dev.stocks.news:$port/topLoser?shortBy=2');
      // Utils().showLog("Fetching offline data from $url");

      String offlineUrl = '';

      if (topLoserProvider.filterParams?.sortByHeader ==
          SortByEnums.perChange.name) {
        offlineUrl = 'https://dev.stocks.news:$port/topLoser?shortBy=1';
      } else if (topLoserProvider.filterParams?.sortByHeader ==
          SortByEnums.volume.name) {
        offlineUrl = 'https://dev.stocks.news:$port/topLoser?shortBy=2';
      } else {
        offlineUrl = 'https://dev.stocks.news:$port/topLoser?shortBy=1';
      }

      final url = Uri.parse(offlineUrl);

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
      Utils().showLog('Error fetching offline data lose: $err');
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

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/losers.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/live.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/offline.dart';

import 'package:stocks_news_new/utils/utils.dart';

import 'client.dart';

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

    ScannerLosersManager losersManager =
        navigatorKey.currentContext!.read<ScannerLosersManager>();
    ScannerManager scannerManager =
        navigatorKey.currentContext!.read<ScannerManager>();

    int? port = scannerManager.portData?.port?.gainerLoser?.loser ?? 8021;
    final checkPostMarket =
        scannerManager.portData?.port?.checkMarketOpenApi?.checkPostMarket ==
            true;

    final postMarketStream =
        scannerManager.portData?.port?.checkMarketOpenApi?.postMarketStream ==
            true;

    Utils().showLog(
        'Call Offline ${checkPostMarket && postMarketStream == false}');

    if (checkPostMarket && !postMarketStream) {
      await getOfflineData();
      return;
    }

    // final url = 'https://dev.stocks.news:$port/topGainersLosers?type=losers';

    final url = losersManager.filterParams?.sortBy == 3
        ? 'https://dev.stocks.news:$port/topGainersLosers?type=losersVolumeAsc'
        : 'https://dev.stocks.news:$port/topGainersLosers?type=losers';

    Utils().showLog("LIVE URL => $url");

    final sseClient = SSEClient(url);
    _activeConnections[url] = sseClient;
    Timer(Duration(milliseconds: checkOfflineInterval), () async {
      if (!isOfflineCalled &&
          losersManager.offlineDataList == null &&
          listening) {
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
          if (losersManager.filterParams?.sortBy == 2 &&
              sseClient.url !=
                  "https://dev.stocks.news:$port/topGainersLosers?type=losers") {
            return;
          } else if (losersManager.filterParams?.sortBy == 3 &&
              sseClient.url !=
                  "https://dev.stocks.news:$port/topGainersLosers?type=losersVolumeAsc") {
            return;
          }
          Utils().showLog("--- ${sseClient.url}");
          final List<dynamic> decodedResponse = jsonDecode(eventData);
          await losersManager
              .updateData(liveScannerResFromJson(decodedResponse));
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

  Future<void> getOfflineData() async {
    try {
      ScannerManager scannerManager =
          navigatorKey.currentContext!.read<ScannerManager>();
      final ScannerLosersManager losersManager =
          navigatorKey.currentContext!.read<ScannerLosersManager>();
      int? port = scannerManager.portData?.port?.other?.offline ?? 8080;
      // final url = Uri.parse('https://dev.stocks.news:$port/topLoser?shortBy=2');
      // Utils().showLog("Fetching offline data from $url");

      String offlineUrl = '';

      if ((losersManager.filterParams?.sortByHeader ==
              SortByEnums.perChange.name) ||
          (losersManager.filterParams?.sortByHeader ==
              SortByEnums.postMarketPerChange.name)) {
        offlineUrl = 'https://dev.stocks.news:$port/topLoser?shortBy=1';
      } else if (losersManager.filterParams?.sortByHeader ==
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
        ScannerLosersManager losersManager =
            navigatorKey.currentContext!.read<ScannerLosersManager>();

        losersManager
            .updateOfflineData(offlineScannerResFromJson(decodedResponse));
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

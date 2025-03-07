import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/gainers.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/live.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/offline.dart';

import '../../../../../routes/my_app.dart';
import '../../../../../utils/utils.dart';
import '../models/scanner_port.dart';
import 'client.dart';

class MarketGainersStream {
  static final MarketGainersStream instance = MarketGainersStream._internal();
  MarketGainersStream._internal();

  factory MarketGainersStream() {
    return instance;
  }

  static const int checkOfflineInterval = 5000;
  bool isOfflineCalled = false;
  bool listening = true;
  final Map<String, SSEClient> _activeConnections = {};

  Future<void> initializePorts() async {
    listening = true;
    isOfflineCalled = false;

    ScannerGainersManager manager =
        navigatorKey.currentContext!.read<ScannerGainersManager>();
    ScannerManager scannerManager =
        navigatorKey.currentContext!.read<ScannerManager>();

    CheckMarketOpenRes? checkMarketOpenApi =
        scannerManager.portData?.port?.checkMarketOpenApi;

    final checkPostMarket = checkMarketOpenApi?.checkPostMarket == true;

    final postMarketStream = checkMarketOpenApi?.postMarketStream == true;

    Utils().showLog(
        'Call Offline ${checkPostMarket && postMarketStream == false}');

    if (checkPostMarket && !postMarketStream) {
      await getOfflineData();
      return;
    }

    int? port = scannerManager.portData?.port?.gainerLoser?.gainer ?? 8021;
    final url = manager.filterParams?.sortBy == 3
        ? 'https://dev.stocks.news:$port/topGainersLosers?type=gainersVolumeDesc'
        : 'https://dev.stocks.news:$port/topGainersLosers?type=gainers';

    final sseClient = SSEClient(url);
    _activeConnections[url] = sseClient;

    Timer(Duration(milliseconds: checkOfflineInterval), () async {
      if (!isOfflineCalled && manager.offlineDataList == null && listening) {
        isOfflineCalled = true;
        await getOfflineData();
      }
    });

    try {
      Utils().showLog("Updated URL => $url");

      await for (var eventData in sseClient.listen()) {
        if (!listening) break;
        isOfflineCalled = true;
        try {
          // TO STOP MIXING streaming because streaming not closing at all
          if (manager.filterParams?.sortBy == 2 &&
              sseClient.url !=
                  "https://dev.stocks.news:$port/topGainersLosers?type=gainers") {
            return;
          } else if (manager.filterParams?.sortBy == 3 &&
              sseClient.url !=
                  "https://dev.stocks.news:$port/topGainersLosers?type=gainersVolumeDesc") {
            return;
          }
          Utils().showLog("--- ${sseClient.url}");

          final List<dynamic> decodedResponse = jsonDecode(eventData);
          await manager.updateData(liveScannerResFromJson(decodedResponse));
        } catch (e) {
          Utils().showLog("Error processing event data: $e");
        }
      }
    } catch (e) {
      // await _handleConnectionError();
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
    ScannerManager scannerManager =
        navigatorKey.currentContext!.read<ScannerManager>();
    final ScannerGainersManager gainersManager =
        navigatorKey.currentContext!.read<ScannerGainersManager>();
    int? port = scannerManager.portData?.port?.other?.offline ?? 8080;

    String offlineUrl = '';

    if ((gainersManager.filterParams?.sortByHeader ==
            SortByEnums.perChange.name) ||
        gainersManager.filterParams?.sortByHeader ==
            SortByEnums.postMarketPerChange.name) {
      offlineUrl = 'https://dev.stocks.news:$port/topGainer?shortBy=1';
    } else if (gainersManager.filterParams?.sortByHeader ==
        SortByEnums.volume.name) {
      offlineUrl = 'https://dev.stocks.news:$port/topGainer?shortBy=2';
    } else {
      offlineUrl = 'https://dev.stocks.news:$port/topGainer?shortBy=1';
    }

    final url = Uri.parse(offlineUrl);

    print('$url');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = jsonDecode(response.body);
        ScannerGainersManager gainersManager =
            navigatorKey.currentContext!.read<ScannerGainersManager>();
        gainersManager
            .updateOfflineData(offlineScannerResFromJson(decodedResponse));
      } else {
        Utils().showLog('Error fetching offline data: ${response.statusCode}');
      }
    } catch (e) {
      Utils().showLog("Error fetching offline data: $e");
    }
  }

  Future<void> stopListeningPorts() async {
    listening = false;
    for (var client in _activeConnections.values) {
      client.close();
    }
    _activeConnections.clear();
    Utils().showLog("Stopped all SSE connections.");
  }
}

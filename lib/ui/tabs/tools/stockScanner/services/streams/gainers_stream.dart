import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/managers/market_scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/managers/top_gainer_scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/sorting/shorting.dart';

import 'package:stocks_news_new/ui/tabs/tools/stockScanner/services/client.dart';
import 'package:stocks_news_new/utils/utils.dart';



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

    TopGainerScannerM provider =
        navigatorKey.currentContext!.read<TopGainerScannerM>();
    MarketScannerM scannerProvider =
        navigatorKey.currentContext!.read<MarketScannerM>();

    final checkPostMarket =
        scannerProvider.port?.port?.checkMarketOpenApi?.checkPostMarket == true;

    final postMarketStream =
        scannerProvider.port?.port?.checkMarketOpenApi?.postMarketStream ==
            true;

    Utils().showLog(
        'Call Offline ${checkPostMarket && postMarketStream == false}');

    if (checkPostMarket && !postMarketStream) {
      await getOfflineData();
      return;
    }

    int? port = scannerProvider.port?.port?.gainerLoserPort?.gainer ?? 8021;
    final url = provider.filterParams?.sortBy == 3
        ? 'https://dev.stocks.news:$port/topGainersLosers?type=gainersVolumeDesc'
        : 'https://dev.stocks.news:$port/topGainersLosers?type=gainers';

    final sseClient = SSEClient(url);
    _activeConnections[url] = sseClient;

    Timer(Duration(milliseconds: checkOfflineInterval), () async {
      if (!isOfflineCalled && provider.offlineDataList == null && listening) {
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
          if (provider.filterParams?.sortBy == 2 &&
              sseClient.url !=
                  "https://dev.stocks.news:$port/topGainersLosers?type=gainers") {
            return;
          } else if (provider.filterParams?.sortBy == 3 &&
              sseClient.url !=
                  "https://dev.stocks.news:$port/topGainersLosers?type=gainersVolumeDesc") {
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

  Future<void> getOfflineData() async {
    final scannerProvider =
        navigatorKey.currentContext!.read<MarketScannerM>();
    final TopGainerScannerM topGainerProvider =
        navigatorKey.currentContext!.read<TopGainerScannerM>();
    int? port = scannerProvider.port?.port?.otherPortRes?.offline ?? 8080;

    String offlineUrl = '';

    if (topGainerProvider.filterParams?.sortByHeader ==
        SortByEnums.perChange.name) {
      offlineUrl = 'https://dev.stocks.news:$port/topGainer?shortBy=1';
    } else if (topGainerProvider.filterParams?.sortByHeader ==
        SortByEnums.volume.name) {
      offlineUrl = 'https://dev.stocks.news:$port/topGainer?shortBy=2';
    } else {
      offlineUrl = 'https://dev.stocks.news:$port/topGainer?shortBy=1';
    }

    final url = Uri.parse(offlineUrl);

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = jsonDecode(response.body);
        final provider =
            navigatorKey.currentContext!.read<TopGainerScannerM>();
        provider.updateOfflineData(scannerResFromJson(decodedResponse));
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

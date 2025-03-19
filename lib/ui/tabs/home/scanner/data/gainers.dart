import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/tabs/home/scanner/manager/gainers.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/data/client.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/live.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/offline.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/scanner_port.dart';
import 'package:stocks_news_new/utils/utils.dart';

class HomeGainersStream {
  static final HomeGainersStream instance = HomeGainersStream._internal();
  HomeGainersStream._internal();

  factory HomeGainersStream() {
    return instance;
  }

  static const int checkOfflineInterval = 5000;
  bool isOfflineCalled = false;
  bool listening = true;
  final Map<String, SSEClient> _activeConnections = {};

  Future<void> initializePorts() async {
    listening = true;
    isOfflineCalled = false;

    HomeGainersManager manager =
        navigatorKey.currentContext!.read<HomeGainersManager>();
    MyHomeManager homeManager =
        navigatorKey.currentContext!.read<MyHomeManager>();

    CheckMarketOpenRes? checkMarketOpenApi =
        homeManager.data?.scannerPort?.port?.checkMarketOpenApi;

    final checkPostMarket = checkMarketOpenApi?.checkPostMarket == true;

    final postMarketStream = checkMarketOpenApi?.postMarketStream == true;

    Utils().showLog(
        'Call Offline ${checkPostMarket && postMarketStream == false}');

    if (checkPostMarket && !postMarketStream) {
      await getOfflineData();
      return;
    }

    int? port =
        homeManager.data?.scannerPort?.port?.gainerLoser?.gainer ?? 8021;
    final url =
        'https://dev.stocks.news:$port/topGainersLosersLimit?type=gainers';

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

          // Utils().showLog("--- ${sseClient.url}");

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

  Future<void> getOfflineData() async {
    MyHomeManager homeManager =
        navigatorKey.currentContext!.read<MyHomeManager>();

    int? port = homeManager.data?.scannerPort?.port?.other?.offline ?? 8080;

    String offlineUrl = '';
    offlineUrl = 'https://dev.stocks.news:$port/topGainerLimit?shortBy=1';

    final url = Uri.parse(offlineUrl);

    print('$url');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = jsonDecode(response.body);
        HomeGainersManager gainersManager =
            navigatorKey.currentContext!.read<HomeGainersManager>();
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

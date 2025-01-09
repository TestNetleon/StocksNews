import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
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

  static final List<EventSource> eventSources = [];
  static bool subscribed = true;
  static const checkInterval = 5000;
  static final urls = [];
  static var isOfflineCalled = false;
  static var listening = true;

  static void initializePorts() async {
    listening = true;
    isOfflineCalled = false;
    MarketScannerProvider provider =
        navigatorKey.currentContext!.read<MarketScannerProvider>();
    final urls = [];
    for (int port = 8021; port <= 8036; port++) {
      urls.add("https://dev.stocks.news:$port/sse");
    }
    try {
      for (var url in urls) {
        Timer(const Duration(milliseconds: checkInterval), () async {
          if (!isOfflineCalled) {
            isOfflineCalled = true;
            if (navigatorKey.currentContext!
                    .read<MarketScannerProvider>()
                    .offlineDataList ==
                null) {
              await getOfflineData();
            }
          }
        });

        EventSource eventSource =
            await EventSource.connect(url).timeout(Duration(seconds: 5));
        eventSources.add(eventSource);

        eventSource.listen(
          (Event event) {
            if (!listening) {
              return;
            }
            if (event.data != null && event.data != "") {
              isOfflineCalled = false;
              final List<dynamic> decodedResponse =
                  jsonDecode(event.data ?? "");
              provider.updateData(marketScannerResFromJson(decodedResponse));
            }
          },
          cancelOnError: false,
          onDone: () {
            Utils().showLog("onError to $url");
          },
          onError: (err) {
            Utils().showLog("Error in connection to $url  $err");
          },
        );
      }
    } catch (e) {
      if (!isOfflineCalled) {
        isOfflineCalled = true;
        if (navigatorKey.currentContext!
                .read<MarketScannerProvider>()
                .offlineDataList ==
            null) {
          await getOfflineData();
        }
      }
    }
  }

  static void stopListeningPorts() {
    listening = false;
    for (var event in eventSources) {
      try {
        event.client.close();
      } catch (e) {
        debugPrint("ERROR Closing - $e");
      }
    }
    eventSources.clear();
  }

  static Future getOfflineData() async {
    // showGlobalProgressDialog();
    MarketScannerProvider provider =
        navigatorKey.currentContext!.read<MarketScannerProvider>();
    try {
      final url = Uri.parse(
        'https://dev.stocks.news:8080/getScreener?sector=${provider.filterParams?.sector}',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Utils().showLog("$url");
        Utils().showLog(response.body);
        final List<dynamic> decodedResponse = jsonDecode(response.body);
        provider.updateOfflineData(scannerResFromJson(decodedResponse));
      } else {
        Utils().showLog('Error fetching data from $url');
      }
    } catch (err) {
      Utils().showLog('Error: Offline data fetched $err');
    }
    // closeGlobalProgressDialog();
  }
}

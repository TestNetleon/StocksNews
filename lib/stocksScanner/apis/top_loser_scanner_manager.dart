import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:eventsource3/eventsource.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/providers/top_loser_scanner_provider.dart';
import 'package:stocks_news_new/utils/utils.dart';

class TopLoserScannerDataManager {
  static final TopLoserScannerDataManager instance =
      TopLoserScannerDataManager._internal();

  TopLoserScannerDataManager._internal();

  factory TopLoserScannerDataManager() {
    return instance;
  }

  final List<EventSource> eventSources = [];
  bool subscribed = true;
  // static const checkInterval = 5000;
  final urls = [];
  var isOfflineCalled = false;
  var listening = true;
  int checkInterval = 7000;
  int checkOfflineInterval = 5000;

  void initializePorts() async {
    listening = true;
    isOfflineCalled = false;
    TopLoserScannerProvider provider =
        navigatorKey.currentContext!.read<TopLoserScannerProvider>();

    final urls = [];

    for (int port = 8021; port <= 8036; port++) {
      urls.add("https://dev.stocks.news:$port/sse");
    }

    try {
      Utils().showLog("Loops starts");
      for (var url in urls) {
        Timer(Duration(milliseconds: checkOfflineInterval), () async {
          if (!isOfflineCalled) {
            isOfflineCalled = true;
            if (navigatorKey.currentContext!
                        .read<TopLoserScannerProvider>()
                        .offlineDataList ==
                    null &&
                listening == true) {
              await getOfflineData();
            }
          }
        });
        EventSource eventSource = await EventSource.connect(url)
            .timeout(Duration(milliseconds: checkInterval));
        eventSources.add(eventSource);
        eventSource.listen(
          (Event event) {
            if (!listening) {
              return;
            }
            if (event.data != null && event.data != "") {
              isOfflineCalled = true;
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
                .read<TopLoserScannerProvider>()
                .offlineDataList ==
            null) {
          await getOfflineData();
        }
      }
    }
  }

  // Method to cancel all StreamSubscriptions
  void stopListeningPorts() {
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

  Future getOfflineData() async {
    // if (isOfflineCalled) return;
    // showGlobalProgressDialog();
    try {
      final url = Uri.parse(
        'https://dev.stocks.news:8080/topLoser?shortBy=2',
      );
      Utils().showLog("$url");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Utils().showLog(response.body);
        final List<dynamic> decodedResponse = jsonDecode(response.body);
        TopLoserScannerProvider provider =
            navigatorKey.currentContext!.read<TopLoserScannerProvider>();
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

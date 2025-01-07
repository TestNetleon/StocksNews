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
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';

class TopLoserScannerDataManager {
  static final TopLoserScannerDataManager instance =
      TopLoserScannerDataManager._internal();

  TopLoserScannerDataManager._internal();

  factory TopLoserScannerDataManager() {
    return instance;
  }

  // Store event source subscriptions to be canceled later
  // static final List<StreamSubscription> eventSubscriptions = [];

  static final List<EventSource> eventSources = [];
  static bool subscribed = true;
  static const checkInterval = 15000;
  static final urls = [];
  static var isFetchDataOfflineCalled = false;
  static var listening = true;

  static void initializePorts() async {
    listening = true;
    // Loop over each URL and create an EventSource and its listeners dynamically
    TopLoserScannerProvider provider =
        navigatorKey.currentContext!.read<TopLoserScannerProvider>();

    final urls = [];

    for (int port = 8021; port <= 8036; port++) {
      urls.add("https://dev.stocks.news:$port/sse");
    }

    Utils().showLog("-- > $urls");

    // await startListeningPorts();

    try {
      Utils().showLog("Loops starts");
      for (var url in urls) {
        Utils().showLog("Step 1 -> $url");
        EventSource eventSource =
            await EventSource.connect(url).timeout(Duration(seconds: 10));
        eventSources.add(eventSource);
        Utils().showLog("Step 2 -> Connected");
        Timer(const Duration(milliseconds: checkInterval), () async {
          Utils().showLog(
            "Connected to $url, but no data received in ${checkInterval / 1000} seconds.",
          );
          if (!isFetchDataOfflineCalled) {
            await getOfflineData();
            isFetchDataOfflineCalled = true;
          }
        });

        eventSource.listen(
          (Event event) {
            Utils().showLog(
              "listen to => $url ${event.id} ${event.event} ",
              // "listen to => $url ${event.id} ${event.event} ${event.data} ",
            );
            if (!listening) {
              return;
            }
            isFetchDataOfflineCalled = true;
            if (event.data != null && event.data != "") {
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
      Timer(const Duration(milliseconds: checkInterval), () async {
        Utils().showLog(
          "NOT Connected to url, but no data received in ${checkInterval / 1000} seconds.",
        );
        if (!isFetchDataOfflineCalled) {
          await getOfflineData();
          isFetchDataOfflineCalled = true;
        }
      });
      Utils().showLog("ERROR connecting... $e");
    }
  }

  // Method to cancel all StreamSubscriptions
  static void stopListeningPorts() {
    listening = false;
    for (var event in eventSources) {
      // subscription.cancel(); // Cancel the subscription to stop listening
      try {
        event.client.close();
      } catch (e) {
        debugPrint("ERROR Closing - $e");
      }
    }
    eventSources.clear(); // Clear the list of subscriptions
  }

  static Future getOfflineData() async {
    showGlobalProgressDialog();
    try {
      final url = Uri.parse(
        'https://dev.stocks.news:8080/topLoser?shortBy=2',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Utils().showLog("$url");
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
    closeGlobalProgressDialog();
  }
}

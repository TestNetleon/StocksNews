// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'package:eventsource3/eventsource.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/routes/my_app.dart';
// import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
// import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
// import 'package:stocks_news_new/stocksScanner/providers/top_gainer_scanner_provider.dart';
// // import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
// import 'package:stocks_news_new/utils/utils.dart';

// class TopGainerScannerDataManager {
//   static final TopGainerScannerDataManager instance =
//       TopGainerScannerDataManager._internal();

//   TopGainerScannerDataManager._internal();

//   factory TopGainerScannerDataManager() {
//     return instance;
//   }

//   final List<EventSource> eventSources = [];
//   bool subscribed = true;
//   // static const checkInterval = 5000;
//   final urls = [];
//   var isOfflineCalled = false;
//   var listening = true;
//   int checkInterval = 120000;
//   int checkOfflineInterval = 5000;

//   void initializePorts() async {
//     listening = true;
//     isOfflineCalled = false;
//     TopGainerScannerProvider provider =
//         navigatorKey.currentContext!.read<TopGainerScannerProvider>();

//     final urls = [];

//     for (int port = 8021; port <= 8036; port++) {
//       urls.add("https://dev.stocks.news:$port/sse");
//       // urls.add(
//       //     'https://dev.stocks.news:$port/topGainersLosers?type=gainers&limit=50');
//     }

//     try {
//       for (var url in urls) {
//         Timer(Duration(milliseconds: checkOfflineInterval), () async {
//           if (!isOfflineCalled) {
//             isOfflineCalled = true;
//             if (navigatorKey.currentContext!
//                         .read<TopGainerScannerProvider>()
//                         .offlineDataList ==
//                     null &&
//                 listening == true) {
//               await getOfflineData();
//             }
//           }
//         });

//         EventSource eventSource = await EventSource.connect(url)
//             .timeout(Duration(milliseconds: checkInterval));
//         eventSources.add(eventSource);

//         eventSource.listen(
//           (Event event) async {
//             if (!listening) {
//               return;
//             }
//             if (event.data != null && event.data != "") {
//               isOfflineCalled = true;
//               final List<dynamic> decodedResponse =
//                   jsonDecode(event.data ?? "");
//               await provider
//                   .updateData(marketScannerResFromJson(decodedResponse));
//             }
//           },
//           cancelOnError: false,
//           onDone: () {
//             Utils().showLog("onError to $url");
//           },
//           onError: (err) {
//             Utils().showLog("Error in connection to $url  $err");
//           },
//         );
//       }
//     } catch (e) {
//       if (!isOfflineCalled) {
//         isOfflineCalled = true;
//         if (navigatorKey.currentContext!
//                 .read<TopGainerScannerProvider>()
//                 .offlineDataList ==
//             null) {
//           await getOfflineData();
//         }
//       }
//     }
//   }

//   // Method to cancel all StreamSubscriptions
//   void stopListeningPorts() {
//     listening = false;
//     for (var event in eventSources) {
//       try {
//         event.client.close();
//       } catch (e) {
//         debugPrint("ERROR Closing - $e");
//       }
//     }
//     try {
//       eventSources.clear();
//     } catch (e) {
//       debugPrint("ERROR Clearing - $e");
//     }
//   }

//   Future getOfflineData() async {
//     // showGlobalProgressDialog();
//     try {
//       final url = Uri.parse(
//         'https://dev.stocks.news:8080/topGainer?shortBy=2',
//       );
//       Utils().showLog("$url");
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         Utils().showLog("$url");
//         Utils().showLog(response.body);
//         final List<dynamic> decodedResponse = jsonDecode(response.body);
//         TopGainerScannerProvider provider =
//             navigatorKey.currentContext!.read<TopGainerScannerProvider>();
//         provider.updateOfflineData(scannerResFromJson(decodedResponse));
//       } else {
//         Utils().showLog('Error fetching data from $url');
//       }
//     } catch (err) {
//       Utils().showLog('Error: Offline data fetched $err');
//     }
//     // closeGlobalProgressDialog();
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:eventsource3/eventsource.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/providers/top_gainer_scanner_provider.dart';
// import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../providers/market_scanner_provider.dart';

class TopGainerScannerDataManager {
  static final TopGainerScannerDataManager instance =
      TopGainerScannerDataManager._internal();

  TopGainerScannerDataManager._internal();

  factory TopGainerScannerDataManager() {
    return instance;
  }

  final List<EventSource> eventSources = [];
  bool subscribed = true;
  // static const checkInterval = 5000;
  var isOfflineCalled = false;
  var listening = true;
  int checkInterval = 120000;
  int checkOfflineInterval = 5000;

  void initializePorts() async {
    listening = true;
    isOfflineCalled = false;
    TopGainerScannerProvider provider =
        navigatorKey.currentContext!.read<TopGainerScannerProvider>();

    MarketScannerProvider scannerProvider =
        navigatorKey.currentContext!.read<MarketScannerProvider>();

    int? port = scannerProvider.port?.port?.gainerLoserPort?.gainer ?? 8021;

    try {
      bool? callOffline =
          scannerProvider.port?.port?.checkMarketOpenApi?.checkPostMarket ==
              true;

      if (callOffline) {
        await getOfflineData();
        return;
      }
    } catch (e) {
//
    }

    try {
      final url = 'https://dev.stocks.news:$port/topGainersLosers?type=gainers';
      Utils().showLog('running for.. $url');
      Timer(Duration(milliseconds: checkOfflineInterval), () async {
        if (!isOfflineCalled) {
          isOfflineCalled = true;
          if (navigatorKey.currentContext!
                      .read<TopGainerScannerProvider>()
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
        (Event event) async {
          if (!listening) {
            return;
          }
          if (event.data != null && event.data != "") {
            isOfflineCalled = true;
            final List<dynamic> decodedResponse = jsonDecode(event.data ?? "");
            await provider
                .updateData(marketScannerResFromJson(decodedResponse));
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
    } catch (e) {
      if (!isOfflineCalled) {
        isOfflineCalled = true;
        if (navigatorKey.currentContext!
                .read<TopGainerScannerProvider>()
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
    try {
      eventSources.clear();
    } catch (e) {
      debugPrint("ERROR Clearing - $e");
    }
  }

  Future getOfflineData() async {
    // showGlobalProgressDialog();
    try {
      MarketScannerProvider scannerProvider =
          navigatorKey.currentContext!.read<MarketScannerProvider>();

      int? port = scannerProvider.port?.port?.otherPortRes?.offline ?? 8080;

      final url = Uri.parse(
        'https://dev.stocks.news:$port/topGainer?shortBy=2',
      );
      Utils().showLog("$url");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Utils().showLog("$url");
        Utils().showLog(response.body);
        final List<dynamic> decodedResponse = jsonDecode(response.body);
        TopGainerScannerProvider provider =
            navigatorKey.currentContext!.read<TopGainerScannerProvider>();
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

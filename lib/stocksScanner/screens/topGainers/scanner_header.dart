import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
// import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class TopGainerScannerHeader extends StatefulWidget {
  final bool isOnline;
  const TopGainerScannerHeader({super.key, this.isOnline = false});

  @override
  State<TopGainerScannerHeader> createState() => _TopGainerScannerHeaderState();
}

class _TopGainerScannerHeaderState extends State<TopGainerScannerHeader> {
  Timer? _timer;
  String _lastUpdated = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isOnline) {
        tz.initializeTimeZones();
        _timer = Timer.periodic(Duration(seconds: 1), (_) {
          // Initialize timezone data
          // Get New York timezone
          var newYork = tz.getLocation('America/New_York');
          // Get current time in New York timezone
          var nowInNewYork = tz.TZDateTime.now(newYork);
          setState(() {
            _lastUpdated =
                DateFormat("MM/dd/yy hh:mm:ss a").format(nowInNewYork);
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MarketScannerProvider provider = context.watch<MarketScannerProvider>();
    String marketStatus = "";
    if (provider.port?.port?.checkMarketOpenApi?.isMarketOpen == true) {
      marketStatus = "Live";
    } else if (provider.port?.port?.checkMarketOpenApi?.checkPreMarket ==
        true) {
      marketStatus = "Pre Market";
    } else {
      _lastUpdated = provider.port?.port?.checkMarketOpenApi?.dateTime ?? "";
      marketStatus = "Post Market";
    }

    // TopGainerScannerProvider provider =
    //     context.watch<TopGainerScannerProvider>();
    // List<MarketScannerRes>? dataList = provider.dataList;
    // List<ScannerRes>? offlineData = provider.offlineDataList;

//     String marketStatus = "";
//     if (dataList == null && offlineData == null) {
//       return SizedBox();
//     } else if (dataList != null && dataList.isNotEmpty) {
//       marketStatus = dataList[0].extendedHoursType ?? "";
//       // Utils().showLog('-------$marketStatus');
//       if (marketStatus == 'PreMarket') {
//         marketStatus = 'Pre Market';
//       } else if (marketStatus == 'PostMarket') {
//         marketStatus = 'Post Market';
//       }
//       // if (!(dataList[0].extendedHoursType == "PostMarket" ||
//       //     dataList[0].extendedHoursType == "PreMarket")) {
//       //   marketStatus = "Live";
//       // }
//       int count = 0;
// // Loop through the first 4 items (or until the list length if it's smaller than 4)
//       for (int i = 0; i < dataList.length && i < 4; i++) {
//         if (dataList[i].extendedHoursType == "PostMarket" ||
//             dataList[i].extendedHoursType == "PreMarket") {
//           count++;
//         }
//       }
// // If at least 4 of the first 4 entries have "PreMarket" or "PostMarket", set marketStatus to "Live"
//       if (count >= 4) {
//         marketStatus = "Live";
//       }
//     } else if (offlineData != null) {
//       marketStatus = offlineData[0].ext?.extendedHoursType ?? "Closed";
//       if (marketStatus == 'PreMarket') {
//         marketStatus = 'Pre Market';
//       } else if (marketStatus == 'PostMarket') {
//         marketStatus = 'Post Market';
//       }
//       Utils().showLog(" ==> ${offlineData[0].toJson()}");
//       _lastUpdated = offlineData[0].closeDate ?? "";
//     }

    // if (marketStatus == "") {
    //   marketStatus = provider.marketStatus ?? "";
    // }

    return Text(
      "Market Status : $marketStatus  |   Last Updated : $_lastUpdated",
      // "Market Status : $marketStatus  |   Last Updated : ",
      style: stylePTSansBold(fontSize: 13),
      maxLines: 1,
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
// import 'package:stocks_news_new/stocksScanner/providers/top_gainer_scanner_provider.dart';
// import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class TopLoserScannerHeader extends StatefulWidget {
  final bool isOnline;
  const TopLoserScannerHeader({
    super.key,
    this.isOnline = false,
  });

  @override
  State<TopLoserScannerHeader> createState() => _TopLoserScannerHeaderState();
}

class _TopLoserScannerHeaderState extends State<TopLoserScannerHeader> {
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
      } else {
        MarketScannerProvider provider = context.read<MarketScannerProvider>();
        _lastUpdated = provider.port?.port?.checkMarketOpenApi?.dateTime ?? "";
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
      // _lastUpdated = provider.port?.port?.checkMarketOpenApi?.dateTime ?? "";
      marketStatus = "Post Market";
    }

    // TopLoserScannerProvider provider = context.watch<TopLoserScannerProvider>();
    // List<MarketScannerRes>? dataList = provider.dataList;
    // List<ScannerRes>? offlineData = provider.offlineDataList;
    // String marketStatus = "";
    // if (dataList == null && offlineData == null) {
    //   return SizedBox();
    // } else if (dataList != null && dataList.isNotEmpty) {
    //   marketStatus = dataList[0].extendedHoursType ?? "";
    //   if (marketStatus == 'PreMarket') {
    //     marketStatus = 'Pre Market';
    //   } else if (marketStatus == 'PostMarket') {
    //     marketStatus = 'Post Market';
    //   }
    //   // if (!(dataList[0].extendedHoursType == "PostMarket" ||
    //   //     dataList[0].extendedHoursType == "PreMarket")) {
    //   //   marketStatus = "Live";
    //   // }
    //   int count = 0;
    //   for (int i = 0; i < dataList.length && i < 4; i++) {
    //     if (!(dataList[i].extendedHoursType == "PostMarket" ||
    //         dataList[i].extendedHoursType == "PreMarket")) {
    //       count++;
    //     }
    //   }
    //   if (count >= 1) {
    //     marketStatus = "Live";
    //   }
    // } else if (offlineData != null) {
    //   marketStatus = offlineData[0].ext?.extendedHoursType ?? "Closed";
    //   if (marketStatus == 'PreMarket') {
    //     marketStatus = 'Pre Market';
    //   } else if (marketStatus == 'PostMarket') {
    //     marketStatus = 'Post Market';
    //   }
    //   _lastUpdated = offlineData[0].closeDate;
    // }
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

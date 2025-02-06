import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class MarketScannerHeader extends StatefulWidget {
  final bool isOnline;
  const MarketScannerHeader({
    super.key,
    this.isOnline = false,
  });

  @override
  State<MarketScannerHeader> createState() => _MarketScannerHeaderState();
}

class _MarketScannerHeaderState extends State<MarketScannerHeader> {
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
      marketStatus = "Post Market";
    }

    // MarketScannerProvider provider = context.watch<MarketScannerProvider>();
    // List<MarketScannerRes>? dataList = provider.dataList;
    // List<ScannerRes>? offlineData = provider.offlineDataList;
    // if (offlineData != null && offlineData.isNotEmpty) {
    //   _lastUpdated =
    //       provider.port?.port?.checkMarketOpenApi?.extendedHoursDate ?? "";
    // }

    // if (dataList == null && offlineData == null) {
    //   return SizedBox();
    // }

    // if ((dataList == null || dataList.isEmpty) &&
    //     (offlineData == null || offlineData.isEmpty)) {
    //   return SizedBox();
    // } else if (dataList != null && dataList.isNotEmpty) {
    //   marketStatus = dataList[0].extendedHoursType ?? "";
    //   if (marketStatus == 'PreMarket') {
    //     marketStatus = 'Pre Market';
    //   } else if (marketStatus == 'PostMarket') {
    //     marketStatus = 'Post Market';
    //   }
    //   if (!(dataList[0].extendedHoursType == "PostMarket" ||
    //       dataList[0].extendedHoursType == "PreMarket")) {
    //     marketStatus = "Live";
    //   }
    // } else if (offlineData != null && offlineData.isNotEmpty) {
    //   marketStatus = offlineData[0].ext?.extendedHoursType == "PostMarket"
    //       ? 'Post Market'
    //       : 'Post Market';
    //   // offlineData[0].ext?.extendedHoursType ?? "Post Market";
    //   _lastUpdated = offlineData[0].closeDate;
    // } else if (marketStatus == "") {
    //   marketStatus = provider.marketStatus == "PostMarket"
    //       ? 'Post Market'
    //       : provider.marketStatus == "PreMarket"
    //           ? 'Pre Market'
    //           : '';
    // }
    // Utils().showLog("DATE => ${dataList![0].time}");
    return Text(
      "Market Status : $marketStatus  |   Last Updated : $_lastUpdated",
      // "Market Status : $marketStatus  |   Last Updated : ",
      style: stylePTSansBold(fontSize: 13),
      maxLines: 1,
    );
  }
}

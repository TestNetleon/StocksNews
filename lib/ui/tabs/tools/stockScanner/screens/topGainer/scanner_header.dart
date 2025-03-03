import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/managers/market_scanner.dart';
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
      } else {
        MarketScannerM provider = context.read<MarketScannerM>();
        _lastUpdated = provider.port?.port?.checkMarketOpenApi?.dateTime ?? "";
        setState(() {});
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
    MarketScannerM provider = context.watch<MarketScannerM>();
    String marketStatus = "";
    if (provider.port?.port?.checkMarketOpenApi?.isMarketOpen == true) {
      marketStatus = "Live";
    } else if (provider.port?.port?.checkMarketOpenApi?.checkPreMarket ==
        true) {
      marketStatus = "Pre Market";
    } else {
      marketStatus = "Post Market";
    }


    return Text(
      "Market Status : $marketStatus  |   Last Updated : $_lastUpdated",
      style: stylePTSansBold(fontSize: 13),
      maxLines: 1,
    );
  }
}

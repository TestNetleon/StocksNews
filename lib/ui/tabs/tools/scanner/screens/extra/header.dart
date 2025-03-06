import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/scanner.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import '../../models/scanner_port.dart';

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
        ScannerManager manager = context.read<ScannerManager>();
        _lastUpdated = manager.port?.port?.checkMarketOpenApi?.dateTime ?? "";
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
    ScannerManager manager = context.watch<ScannerManager>();
    CheckMarketOpenApiRes? checkMarketOpenApi =
        manager.port?.port?.checkMarketOpenApi;

    String marketStatus = "";
    if (checkMarketOpenApi?.isMarketOpen == true) {
      marketStatus = "Live";
    } else if (checkMarketOpenApi?.checkPreMarket == true) {
      marketStatus = "Pre Market";
    } else {
      marketStatus = "Post Market";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            children: [
              Text(
                'Market Status',
                style: styleBaseSemiBold(color: ThemeColors.neutral20),
              ),
              Text(
                marketStatus,
                style: styleBaseBold(),
              ),
            ],
          ),
        ),
        SpacerHorizontal(width: 20),
        Flexible(
          child: Column(
            children: [
              Text(
                'Last Updated',
                style: styleBaseSemiBold(color: ThemeColors.neutral20),
              ),
              Text(
                _lastUpdated,
                style: styleBaseBold(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

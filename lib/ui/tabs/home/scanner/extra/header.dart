import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import '../../../tools/scanner/models/scanner_port.dart';

class HomeScannerHeader extends StatefulWidget {
  final bool isOnline;
  const HomeScannerHeader({
    super.key,
    this.isOnline = false,
  });

  @override
  State<HomeScannerHeader> createState() => _HomeScannerHeaderState();
}

class _HomeScannerHeaderState extends State<HomeScannerHeader> {
  Timer? _timer;
  String _lastUpdated = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isOnline) {
        tz.initializeTimeZones();
        _timer = Timer.periodic(Duration(seconds: 1), (_) {
          var newYork = tz.getLocation('America/New_York');
          var nowInNewYork = tz.TZDateTime.now(newYork);
          setState(() {
            _lastUpdated =
                DateFormat("MM/dd/yy hh:mm:ss a").format(nowInNewYork);
          });
        });
      } else {
        MyHomeManager manager = context.read<MyHomeManager>();
        String date = _formatForOfflineData(
            manager.data?.scannerPort?.port?.checkMarketOpenApi?.dateTime);
        _lastUpdated = date;
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
    return Consumer<MyHomeManager>(
      builder: (context, value, child) {
        CheckMarketOpenRes? checkMarketOpenApi =
            value.data?.scannerPort?.port?.checkMarketOpenApi;

        String marketStatus = "";
        if (checkMarketOpenApi?.isMarketOpen == true) {
          marketStatus = "Live";
        } else if (checkMarketOpenApi?.checkPreMarket == true) {
          marketStatus = "Pre Market";
        } else {
          marketStatus = "Post Market";
        }

        return Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: Pad.pad10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Market Status',
                        style: styleBaseRegular(
                          color: ThemeColors.neutral20,
                          fontSize: 13,
                        ),
                      ),
                      SpacerVertical(height: 3),
                      Text(
                        marketStatus,
                        // style: styleBaseSemiBold(fontSize: 14),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  SpacerHorizontal(width: 20),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Last Updated',
                          style: styleBaseRegular(
                            color: ThemeColors.neutral20,
                            fontSize: 13,
                          ),
                        ),
                        SpacerVertical(height: 3),
                        Text(
                          _lastUpdated,
                          // style: styleBaseSemiBold(fontSize: 14),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BaseListDivider(),
          ],
        );
      },
    );
  }

  String _formatForOfflineData(String? dateTime) {
    if (dateTime == null || !dateTime.contains(" ")) {
      return dateTime ?? '';
    }
    try {
      List<String> parts = dateTime.split(" ");
      String datePart = parts[0];
      String timePart = parts[1];

      final inputFormat = DateFormat("HH:mm:ss");
      final parsedTime = inputFormat.parse(timePart);

      final outputFormat = DateFormat("hh:mm:ss a");
      String formattedTime = outputFormat.format(parsedTime);

      return "$datePart $formattedTime";
    } catch (e) {
      if (kDebugMode) {
        print("Error formatting time: $e");
      }
      return dateTime;
    }
  }
}

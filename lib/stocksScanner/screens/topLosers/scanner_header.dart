import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/providers/top_loser_scanner_provider.dart';
// import 'package:stocks_news_new/stocksScanner/providers/top_gainer_scanner_provider.dart';
// import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

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
        _timer = Timer.periodic(Duration(seconds: 1), (_) {
          setState(() {
            _lastUpdated = DateFormat("hh:mm:ss").format(DateTime.now());
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
    TopLoserScannerProvider provider = context.watch<TopLoserScannerProvider>();
    List<MarketScannerRes>? dataList = provider.dataList;
    List<ScannerRes>? offlineData = provider.offlineDataList;

    String marketStatus = "";
    if (dataList == null && offlineData == null) {
      return SizedBox();
    } else if (offlineData != null) {
      marketStatus = "Closed";
      _lastUpdated = offlineData[0].closeDate;
    } else if (dataList != null && dataList.isNotEmpty) {
      marketStatus = dataList[0].extendedHoursType ?? "";
      // if (!(dataList[0].extendedHoursType == "PostMarket" ||
      //     dataList[0].extendedHoursType == "PreMarket")) {
      //   marketStatus = "Live";
      // }
    }

    // if (marketStatus == "") {
    //   marketStatus = provider.marketStatus ?? "";
    // }

    return Text(
      "Market Status : $marketStatus  |   Last Updated : $_lastUpdated",
      style: stylePTSansBold(),
    );
  }

  DataCell _dataCell({required String text, bool change = false, num? value}) {
    return DataCell(
      ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ScreenUtil().screenWidth * .3,
        ),
        child: Text(
          // userPercent ? "$text%" : "$text",
          text,
          style: styleGeorgiaBold(
            fontSize: 12,
            // color: Colors.white,
            color: value != null
                ? (value >= 0 ? ThemeColors.accent : ThemeColors.sos)
                : Colors.white,
          ),
        ),
      ),
    );
  }
}

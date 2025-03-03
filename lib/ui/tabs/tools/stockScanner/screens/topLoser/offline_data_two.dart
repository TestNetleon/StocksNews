import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/managers/market_scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/managers/top_loser_scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/sorting/shorting.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/topGainer/top_gainer_filter.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/services/streams/losers_stream.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../widget/container.dart';
import 'scanner_header.dart';

class TopLosersOfflineTwo extends StatefulWidget {
  const TopLosersOfflineTwo({super.key});

  @override
  State<TopLosersOfflineTwo> createState() => _TopLosersOfflineTwoState();
}

class _TopLosersOfflineTwoState extends State<TopLosersOfflineTwo> {
  bool preMarket = false;
  bool postMarket = false;
  String? text;
  List<String> columnHeader = [
    // "Time",
    // "Symbol",
    "Company Name",
    "Sector",
    // "Bid",
    // "Ask",
    "Last Trade",
    "Net Change",
    "% Change",
    "Volume",
    "\$ Volume"
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      _setPrePost();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _setPrePost() {
    TopLoserScannerM provider = context.read<TopLoserScannerM>();
    MarketScannerM scannerProvider =
        context.read<MarketScannerM>();
    preMarket =
        scannerProvider.port?.port?.checkMarketOpenApi?.checkPreMarket ?? false;
    postMarket =
        scannerProvider.port?.port?.checkMarketOpenApi?.checkPostMarket ??
            false;

    provider.resetLiveFilter();

    text = preMarket
        ? 'Pre-Market'
        : postMarket
            ? 'Post-Market'
            : null;
  }

  @override
  Widget build(BuildContext context) {
    TopLoserScannerM provider = context.watch<TopLoserScannerM>();
    List<ScannerRes>? dataList = provider.offlineDataList;

    bool? gotPostMarket = dataList?.any(
      (element) => element.ext?.extendedHoursType == 'PostMarket',
    );
    if (dataList == null) {
      return SizedBox();
    }
    if (gotPostMarket == true) {
      int lastTradeIndex = columnHeader.indexOf("Last Trade");
      if (lastTradeIndex != -1 && !columnHeader.contains("Post Market Price")) {
        columnHeader.insert(lastTradeIndex + 1, "Post Market Price");
      }
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          TopLoserScannerHeader(isOnline: false),
          ScannerTopGainerFilter(
            onPercentClick: () async {
              provider.applyFilter(2);
              showGlobalProgressDialog();
              await MarketLosersStream.instance.getOfflineData();
              closeGlobalProgressDialog();
            },
            onVolumnClick: () async {
              provider.applyFilter(3);
              // provider.applyFilterValuesOnly(SortByEnums.volume.name, true);
              showGlobalProgressDialog();
              await MarketLosersStream.instance.getOfflineData();
              closeGlobalProgressDialog();
            },
            onRestartClick: () {
              MarketLosersStream().initializePorts();
              // provider.clearFilter();
            },
            isPercent: provider.filterParams?.sortBy == 2,
            isVolume: provider.filterParams?.sortBy == 3,
            orderByAsc: provider.filterParams?.sortByAsc,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            alignment: Alignment.centerRight,
            child: Visibility(
              visible: dataList.isNotEmpty == true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Visibility(
                      visible: dataList.isNotEmpty,
                      child: Text(
                        'No. of Results: ${dataList.length}',
                        style: styleGeorgiaBold(),
                      ),
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        scannerSorting(
                          showPreMarket: true,
                          text: text,
                          sortBy: provider.filterParams?.sortByAsc,
                          header: provider.filterParams?.sortByHeader,
                          sortByCallBack: (received) async {
                            Utils().showLog(
                                '${received.type}, ${received.ascending}');

                            Utils().showLog("--- Sorting");
                            provider.applySorting(
                                received.type.name, received.ascending);
                            Navigator.pop(context);
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Sort Stocks ',
                            style: styleGeorgiaBold(),
                          ),
                          Icon(Icons.sort),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ScannerBaseContainerOffline(dataList: dataList),
        ],
      ),
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

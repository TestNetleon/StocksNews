import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/stocksScanner/manager/losers_stream.dart';
import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/providers/top_loser_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/screens/topGainers/scanner_header.dart';
import 'package:stocks_news_new/stocksScanner/screens/topGainers/top_gainer_filter.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../utils/utils.dart';
import '../sorting/shorting.dart';
import '../widget/container.dart';

class TopLosersOfflineTwo extends StatefulWidget {
  const TopLosersOfflineTwo({super.key});

  @override
  State<TopLosersOfflineTwo> createState() => _TopLosersOfflineTwoState();
}

class _TopLosersOfflineTwoState extends State<TopLosersOfflineTwo> {
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
      TopLoserScannerProvider provider =
          context.read<TopLoserScannerProvider>();
      // provider.startListeningPorts();
      // provider.getOfflineData();
      provider.resetLiveFilter();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TopLoserScannerProvider provider = context.watch<TopLoserScannerProvider>();
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
          TopGainerScannerHeader(isOnline: false),
          ScannerTopGainerFilter(
            onPercentClick: () async {
              provider.applyFilter(2);
              // provider.applyFilterValuesOnly(SortByEnums.perChange.name, true);
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
                          sortBy: provider.filterParams?.sortByAsc,
                          header: provider.filterParams?.sortByHeader,
                          sortByCallBack: (received) async {
                            Utils().showLog(
                                '${received.type}, ${received.ascending}');

                            // if (received.type == SortByEnums.volume &&
                            //     (provider.filterParams == null ||
                            //         provider.filterParams?.sortByHeader ==
                            //             SortByEnums.perChange.name)) {
                            //   Utils().showLog("--- By Volume");
                            //   provider.applyFilterValuesOnly(
                            //       received.type.name, received.ascending);
                            //   showGlobalProgressDialog();
                            //   await MarketLosersStream.instance
                            //       .getOfflineData();
                            //   closeGlobalProgressDialog();
                            // } else if (received.type == SortByEnums.perChange &&
                            //     provider.filterParams?.sortByHeader ==
                            //         SortByEnums.volume.name) {
                            //   Utils().showLog("--- By % change");
                            //   provider.applyFilterValuesOnly(
                            //       received.type.name, received.ascending);
                            //   showGlobalProgressDialog();
                            //   await MarketLosersStream.instance
                            //       .getOfflineData();
                            //   closeGlobalProgressDialog();
                            // }
                            // else {
                            Utils().showLog("--- Sorting");
                            provider.applySorting(
                                received.type.name, received.ascending);
                            // }

                            // Timer(const Duration(milliseconds: 300), () {
                            // });

                            // if (received.type == SortByEnums.symbol) {
                            //   provider.applySorting(
                            //       'Symbol', received.ascending);
                            // } else if (received.type == SortByEnums.company) {
                            //   provider.applySorting(
                            //       'Company Name', received.ascending);
                            // } else if (received.type == SortByEnums.sector) {
                            //   provider.applySorting(
                            //       'Sector', received.ascending);
                            // } else if (received.type == SortByEnums.lastTrade) {
                            //   provider.applySorting(
                            //       'Last Trade', received.ascending);
                            // } else if (received.type == SortByEnums.netChange) {
                            //   provider.applySorting(
                            //       'Net Change', received.ascending);
                            // } else if (received.type == SortByEnums.perChange) {
                            //   provider.applySorting(
                            //       '% Change', received.ascending);
                            // } else if (received.type == SortByEnums.volume) {
                            //   provider.applySorting(
                            //       'Volume', received.ascending);
                            // } else if (received.type ==
                            //     SortByEnums.dollarVolume) {
                            //   provider.applySorting(
                            //       '\$ Volume', received.ascending);
                            // }

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

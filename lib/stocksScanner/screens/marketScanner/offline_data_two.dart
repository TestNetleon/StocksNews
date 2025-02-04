import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/screens/marketScanner/scanner_header.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../utils/utils.dart';
import '../sorting/shorting.dart';
import '../widget/container.dart';

class MarketScannerOfflineTwo extends StatefulWidget {
  const MarketScannerOfflineTwo({super.key});

  @override
  State<MarketScannerOfflineTwo> createState() =>
      _MarketScannerOfflineTwoState();
}

class _MarketScannerOfflineTwoState extends State<MarketScannerOfflineTwo> {
  bool preMarket = false;
  bool postMarket = false;
  String? text;
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   MarketScannerProvider provider = context.read<MarketScannerProvider>();
    //   provider.startListeningPorts();
    //   // provider.getOfflineData();
    // });
    _setPrePost();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _setPrePost() {
    MarketScannerProvider provider = context.read<MarketScannerProvider>();
    List<ScannerRes>? dataList = provider.offlineDataList;
    preMarket = dataList?.any(
          (element) {
            return element.ext?.extendedHoursType == 'PreMarket';
          },
        ) ==
        true;

    postMarket = dataList?.any(
          (element) {
            return element.ext?.extendedHoursType == 'PostMarket';
          },
        ) ==
        true;

    text = preMarket
        ? 'Pre-Market'
        : postMarket
            ? 'Post-Market'
            : null;
  }

  @override
  Widget build(BuildContext context) {
    MarketScannerProvider provider = context.watch<MarketScannerProvider>();
    List<ScannerRes>? dataList = provider.offlineDataList;
    List<String> tableHeader = provider.tableHeader;
    bool? gotPostMarket = dataList?.any(
      (element) => element.ext?.extendedHoursType == 'PostMarket',
    );
    if (dataList == null) {
      return SizedBox();
    }
    if (gotPostMarket == true) {
      int lastTradeIndex = provider.tableHeader.indexOf("Last Trade");
      if (lastTradeIndex != -1 && !tableHeader.contains("Post Market Price")) {
        tableHeader.insert(lastTradeIndex + 1, "Post Market Price");
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          MarketScannerHeader(isOnline: false),
          // Text(
          //   "Market Status :   |   Last Updated :",
          //   style: stylePTSansBold(),
          // ),
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
                      visible:
                          dataList.isNotEmpty && provider.isFilterApplied(),
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
                          showSector: false,
                          showPreMarket: true,
                          sortBy: provider.filterParams?.sortByAsc,
                          header: provider.filterParams?.sortBy,
                          text: text,
                          sortByCallBack: (received) {
                            Utils().showLog(
                                '${received.type}, ${received.ascending}');
                            provider.applySorting(
                                received.type.name, received.ascending);

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

          ScannerBaseContainerOffline(
            dataList: dataList,
          ),
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

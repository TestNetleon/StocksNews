import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/screens/marketScanner/scanner_header.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
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
  // List<String> columnHeader = [
  //   "Time",
  //   // "Symbol",
  //   "Company Name",
  //   "Sector",
  //   "Bid",
  //   "Ask",
  //   "Last Trade",
  //   "Net Change",
  //   "% Change",
  //   "Volume",
  //   "\$ Volume"
  // ];

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   MarketScannerProvider provider = context.read<MarketScannerProvider>();
    //   provider.startListeningPorts();
    //   // provider.getOfflineData();
    // });
  }

  @override
  void dispose() {
    super.dispose();
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
          const SpacerVertical(height: 10),
          Visibility(
            visible: dataList.isNotEmpty && provider.isFilterApplied(),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'Total number of results: ${dataList.length}',
                style: styleGeorgiaBold(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Visibility(
              visible: dataList.isNotEmpty == true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Sort Stocks ',
                    style: styleGeorgiaBold(),
                  ),
                  IconButton(
                      onPressed: () {
                        scannerSorting(
                          sortByCallBack: (received) {
                            Utils().showLog(
                                '${received.type}, ${received.ascending}');
                            if (received.type == SortByEnums.symbol) {
                              provider.applySorting('Symbol');
                            } else if (received.type == SortByEnums.company) {
                              provider.applySorting('Company Name');
                            } else if (received.type == SortByEnums.sector) {
                              provider.applySorting('Sector');
                            } else if (received.type == SortByEnums.lastTrade) {
                              provider.applySorting('Last Trade');
                            } else if (received.type == SortByEnums.netChange) {
                              provider.applySorting('Net Change');
                            } else if (received.type == SortByEnums.perChange) {
                              provider.applySorting('% Change');
                            } else if (received.type == SortByEnums.volume) {
                              provider.applySorting('Volume');
                            } else if (received.type ==
                                SortByEnums.dollarVolume) {
                              provider.applySorting('\$ Volume');
                            }

                            Navigator.pop(context);
                          },
                        );
                      },
                      icon: Icon(Icons.sort)),
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

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
// import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
// import 'package:stocks_news_new/stocksScanner/screens/marketScanner/scanner_header.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import '../widget/container.dart';

// class MarketScannerOfflineTwo extends StatefulWidget {
//   const MarketScannerOfflineTwo({super.key});

//   @override
//   State<MarketScannerOfflineTwo> createState() =>
//       _MarketScannerOfflineTwoState();
// }

// class _MarketScannerOfflineTwoState extends State<MarketScannerOfflineTwo> {
//   // List<String> columnHeader = [
//   //   "Time",
//   //   // "Symbol",
//   //   "Company Name",
//   //   "Sector",
//   //   "Bid",
//   //   "Ask",
//   //   "Last Trade",
//   //   "Net Change",
//   //   "% Change",
//   //   "Volume",
//   //   "\$ Volume"
//   // ];

//   @override
//   void initState() {
//     super.initState();
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   MarketScannerProvider provider = context.read<MarketScannerProvider>();
//     //   provider.startListeningPorts();
//     //   // provider.getOfflineData();
//     // });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     MarketScannerProvider provider = context.watch<MarketScannerProvider>();
//     List<ScannerRes>? dataList = provider.offlineDataList;
//     List<String> tableHeader = provider.tableHeader;
//     bool? gotPostMarket = dataList?.any(
//       (element) => element.ext?.extendedHoursType == 'PostMarket',
//     );
//     if (dataList == null) {
//       return SizedBox();
//     }
//     if (gotPostMarket == true) {
//       int lastTradeIndex = provider.tableHeader.indexOf("Last Trade");
//       if (lastTradeIndex != -1 && !tableHeader.contains("Post Market Price")) {
//         tableHeader.insert(lastTradeIndex + 1, "Post Market Price");
//       }
//     }

//     return Column(
//       children: [
//         MarketScannerHeader(isOnline: false),
//         const SpacerVertical(height: 10),
//         Visibility(
//           visible: dataList.isNotEmpty && provider.isFilterApplied(),
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 10),
//             child: Text(
//               'Total number of results: ${dataList.length}',
//               style: styleGeorgiaBold(),
//             ),
//           ),
//         ),
//         ScannerBaseContainerOffline(
//           dataList: dataList,
//         ),
//       ],
//     );
//   }

//   DataCell _dataCell({required String text, bool change = false, num? value}) {
//     return DataCell(
//       ConstrainedBox(
//         constraints: BoxConstraints(
//           maxWidth: ScreenUtil().screenWidth * .3,
//         ),
//         child: Text(
//           // userPercent ? "$text%" : "$text",
//           text,
//           style: styleGeorgiaBold(
//             fontSize: 12,
//             // color: Colors.white,
//             color: value != null
//                 ? (value >= 0 ? ThemeColors.accent : ThemeColors.sos)
//                 : Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }

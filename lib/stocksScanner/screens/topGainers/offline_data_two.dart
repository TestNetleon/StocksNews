import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/providers/top_gainer_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/screens/topGainers/scanner_header.dart';
// import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

import '../../../utils/utils.dart';
import '../sorting/shorting.dart';
import '../widget/container.dart';

class TopGainerOfflineTwo extends StatefulWidget {
  const TopGainerOfflineTwo({super.key});

  @override
  State<TopGainerOfflineTwo> createState() => _TopGainerOfflineTwoState();
}

class _TopGainerOfflineTwoState extends State<TopGainerOfflineTwo> {
  List<String> columnHeader = [
    // "Time",
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
      // TopGainerScannerProvider provider =
      //     context.read<TopGainerScannerProvider>();
      // provider.startListeningPorts();
      // provider.getOfflineData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TopGainerScannerProvider provider =
        context.watch<TopGainerScannerProvider>();
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

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
// import 'package:stocks_news_new/stocksScanner/providers/top_gainer_scanner_provider.dart';
// import 'package:stocks_news_new/stocksScanner/screens/topGainers/scanner_header.dart';
// import 'package:stocks_news_new/stocksScanner/screens/topGainers/top_gainer_filter.dart';
// // import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';

// import '../../manager/gainers_stream.dart';
// import '../widget/container.dart';

// class TopGainerOfflineTwo extends StatefulWidget {
//   const TopGainerOfflineTwo({super.key});

//   @override
//   State<TopGainerOfflineTwo> createState() => _TopGainerOfflineTwoState();
// }

// class _TopGainerOfflineTwoState extends State<TopGainerOfflineTwo> {
//   List<String> columnHeader = [
//     // "Time",
//     "Company Name",
//     "Sector",
//     // "Bid",
//     // "Ask",
//     "Last Trade",
//     "Net Change",
//     "% Change",
//     "Volume",
//     "\$ Volume"
//   ];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // TopGainerScannerProvider provider =
//       //     context.read<TopGainerScannerProvider>();
//       // provider.startListeningPorts();
//       // provider.getOfflineData();
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     TopGainerScannerProvider provider =
//         context.watch<TopGainerScannerProvider>();
//     List<ScannerRes>? dataList = provider.offlineDataList;
//     bool? gotPostMarket = dataList?.any(
//       (element) => element.ext?.extendedHoursType == 'PostMarket',
//     );
//     if (dataList == null) {
//       return SizedBox();
//     }
//     if (gotPostMarket == true) {
//       int lastTradeIndex = columnHeader.indexOf("Last Trade");
//       if (lastTradeIndex != -1 && !columnHeader.contains("Post Market Price")) {
//         columnHeader.insert(lastTradeIndex + 1, "Post Market Price");
//       }
//     }
//     return Column(
//       children: [
//         TopGainerScannerHeader(isOnline: false),
//         // const SpacerVertical(height: 10),
//         ScannerTopGainerFilter(
//           onPercentClick: () {
//             provider.applyFilter(2);
//           },
//           onVolumnClick: () {
//             provider.applyFilter(3);
//           },
//           onRestartClick: () {
//             MarketGainersStream().initializePorts();
//             provider.clearFilter();
//           },
//           isPercent: provider.filterParams?.sortBy == 2,
//           isVolume: provider.filterParams?.sortBy == 3,
//           orderByAsc: provider.filterParams?.sortByAsc,
//         ),

//         ScannerBaseContainerOffline(dataList: dataList),
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

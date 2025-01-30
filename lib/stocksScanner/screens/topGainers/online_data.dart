import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/stocksScanner/manager/gainers_stream.dart';
import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/providers/top_gainer_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/screens/topGainers/scanner_header.dart';
import 'package:stocks_news_new/stocksScanner/screens/topGainers/top_gainer_filter.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../utils/utils.dart';
import '../sorting/shorting.dart';
import '../widget/container.dart';

class TopGainerOnline extends StatefulWidget {
  const TopGainerOnline({super.key});

  @override
  State<TopGainerOnline> createState() => _TopGainerOnlineState();
}

class _TopGainerOnlineState extends State<TopGainerOnline> {
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
      // MarketScannerProvider provider = context.read<MarketScannerProvider>();
      // provider.startListeningPorts();
      // provider.getOfflineData();
      TopGainerScannerProvider provider =
          context.read<TopGainerScannerProvider>();
      provider.resetLiveFilter();
    });
  }

  @override
  void dispose() {
    TopGainerScannerProvider provider =
        navigatorKey.currentContext!.read<TopGainerScannerProvider>();
    provider.stopListeningPorts();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TopGainerScannerProvider provider =
        context.watch<TopGainerScannerProvider>();
    List<MarketScannerRes>? dataList = provider.dataList;

    if (dataList == null) {
      return SizedBox();
    }

    return Column(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              TopGainerScannerHeader(isOnline: true),
              ScannerTopGainerFilter(
                onPercentClick: () {
                  provider.applyFilter(2);
                },
                onVolumnClick: () {
                  provider.applyFilter(3);
                },
                onRestartClick: () {
                  MarketGainersStream().initializePorts();
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
              ScannerBaseContainer(dataList: dataList),
            ],
          ),
        ),
        // ScannerTopGainerFilter(
        //   onPercentClick: () {
        //     provider.applyFilter(2);
        //   },
        //   onVolumnClick: () {
        //     provider.applyFilter(3);
        //   },
        //   onRestartClick: () {
        //     MarketGainersStream().initializePorts();
        //     provider.clearFilter();
        //   },
        //   isPercent: provider.filterParams?.sortBy == 2,
        //   isVolume: provider.filterParams?.sortBy == 3,
        //   orderByAsc: provider.filterParams?.sortByAsc,
        // ),
      ],
    );
  }

  DataCell _dataCell({required String text, bool change = false, num? value}) {
    return DataCell(
      ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ScreenUtil().screenWidth * .3,
        ),
        child: Text(
          text,
          style: styleGeorgiaBold(
            fontSize: 12,
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
// import 'package:stocks_news_new/routes/my_app.dart';
// import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
// import 'package:stocks_news_new/stocksScanner/providers/top_gainer_scanner_provider.dart';
// import 'package:stocks_news_new/stocksScanner/screens/topGainers/scanner_header.dart';
// import 'package:stocks_news_new/stocksScanner/screens/topGainers/top_gainer_filter.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import '../../manager/gainers_stream.dart';
// import '../widget/container.dart';

// class TopGainerOnline extends StatefulWidget {
//   const TopGainerOnline({super.key});

//   @override
//   State<TopGainerOnline> createState() => _TopGainerOnlineState();
// }

// class _TopGainerOnlineState extends State<TopGainerOnline> {
//   List<String> columnHeader = [
//     // "Time",
//     // "Symbol",
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
//       // MarketScannerProvider provider = context.read<MarketScannerProvider>();
//       // provider.startListeningPorts();
//       // provider.getOfflineData();
//     });
//   }

//   @override
//   void dispose() {
//     TopGainerScannerProvider provider =
//         navigatorKey.currentContext!.read<TopGainerScannerProvider>();
//     provider.stopListeningPorts();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     TopGainerScannerProvider provider =
//         context.watch<TopGainerScannerProvider>();
//     List<MarketScannerRes>? dataList = provider.dataList;

//     if (dataList == null) {
//       return SizedBox();
//     }

//     return Column(
//       children: [
//         TopGainerScannerHeader(isOnline: true),
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

//         ScannerBaseContainer(dataList: dataList),
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
//           text,
//           style: styleGeorgiaBold(
//             fontSize: 12,
//             color: value != null
//                 ? (value >= 0 ? ThemeColors.accent : ThemeColors.sos)
//                 : Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }

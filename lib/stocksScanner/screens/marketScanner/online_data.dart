import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/screens/marketScanner/scanner_header.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../sorting/shorting.dart';
import '../widget/container.dart';

class MarketScannerOnline extends StatefulWidget {
  const MarketScannerOnline({super.key});

  @override
  State<MarketScannerOnline> createState() => _MarketScannerOnlineState();
}

class _MarketScannerOnlineState extends State<MarketScannerOnline> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MarketScannerProvider provider = context.watch<MarketScannerProvider>();
    List<MarketScannerRes>? dataList = provider.dataList;
    if (dataList == null) {
      return SizedBox();
    }

    Utils().showLog('header ${provider.tableHeader.length}');
    Utils().showLog('data ${dataList.length}');

    return SingleChildScrollView(
      child: Column(
        children: [
          MarketScannerHeader(isOnline: true),
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
              child: IconButton(
                  onPressed: () {
                    scannerSorting(
                      sortByCallBack: (received) {
                        Utils()
                            .showLog('${received.type}, ${received.ascending}');
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
                        } else if (received.type == SortByEnums.dollarVolume) {
                          provider.applySorting('\$ Volume');
                        }

                        Navigator.pop(context);
                      },
                    );
                  },
                  icon: Icon(Icons.sort)),
            ),
          ),
          ScannerBaseContainer(dataList: dataList),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
// import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
// import 'package:stocks_news_new/stocksScanner/screens/marketScanner/scanner_header.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import '../widget/container.dart';

// class MarketScannerOnline extends StatefulWidget {
//   const MarketScannerOnline({super.key});

//   @override
//   State<MarketScannerOnline> createState() => _MarketScannerOnlineState();
// }

// class _MarketScannerOnlineState extends State<MarketScannerOnline> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {});
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     MarketScannerProvider provider = context.watch<MarketScannerProvider>();
//     List<MarketScannerRes>? dataList = provider.dataList;
//     if (dataList == null) {
//       return SizedBox();
//     }

//     Utils().showLog('header ${provider.tableHeader.length}');
//     Utils().showLog('data ${dataList.length}');

//     return Column(
//       children: [
//         MarketScannerHeader(isOnline: true),
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
//         ScannerBaseContainer(dataList: dataList),
//       ],
//     );
//   }
// }

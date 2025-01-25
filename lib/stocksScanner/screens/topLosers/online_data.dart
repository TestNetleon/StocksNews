import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/providers/top_loser_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/screens/topLosers/scanner_header.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../utils/utils.dart';
import '../sorting/shorting.dart';
import '../widget/container.dart';

class TopLosersOnline extends StatefulWidget {
  const TopLosersOnline({super.key});

  @override
  State<TopLosersOnline> createState() => _TopLosersOnlineState();
}

class _TopLosersOnlineState extends State<TopLosersOnline> {
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
    });
  }

  @override
  void dispose() {
    TopLoserScannerProvider provider =
        navigatorKey.currentContext!.read<TopLoserScannerProvider>();
    provider.stopListeningPorts();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TopLoserScannerProvider provider = context.watch<TopLoserScannerProvider>();
    List<MarketScannerRes>? dataList = provider.dataList;

    if (dataList == null) {
      return SizedBox();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          TopLoserScannerHeader(isOnline: true),
          // ScannerTopGainerFilter(
          //   onPercentClick: () {
          //     provider.applyFilter(2);
          //   },
          //   onVolumnClick: () {
          //     provider.applyFilter(3);
          //   },
          //   onRestartClick: () {
          //     MarketLosersStream().initializePorts();
          //     provider.clearFilter();
          //   },
          //   isPercent: provider.filterParams?.sortBy == 2,
          //   isVolume: provider.filterParams?.sortBy == 3,
          //   orderByAsc: provider.filterParams?.sortByAsc,
          // ),
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

          ScannerBaseContainer(dataList: dataList),
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

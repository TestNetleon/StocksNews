import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/stocksScanner/manager/losers_stream.dart';
import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/providers/top_loser_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/screens/topGainers/top_gainer_filter.dart';
import 'package:stocks_news_new/stocksScanner/screens/topLosers/scanner_header.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../utils/utils.dart';
import '../../providers/market_scanner_provider.dart';
import '../sorting/shorting.dart';
import '../widget/container.dart';

class TopLosersOnline extends StatefulWidget {
  const TopLosersOnline({super.key});

  @override
  State<TopLosersOnline> createState() => _TopLosersOnlineState();
}

class _TopLosersOnlineState extends State<TopLosersOnline> {
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
      // MarketScannerProvider provider = context.read<MarketScannerProvider>();
      // provider.startListeningPorts();
      // provider.getOfflineData();
      // TopLoserScannerProvider provider =
      //     navigatorKey.currentContext!.read<TopLoserScannerProvider>();
      // provider.resetLiveFilter();
      _setPrePost();
    });
  }

  @override
  void dispose() {
    TopLoserScannerProvider provider =
        navigatorKey.currentContext!.read<TopLoserScannerProvider>();
    provider.stopListeningPorts();
    super.dispose();
  }

  _setPrePost() {
    TopLoserScannerProvider provider = context.read<TopLoserScannerProvider>();
    provider.resetLiveFilter();

    // List<MarketScannerRes>? dataList = provider.dataList;
    // preMarket = dataList?.any(
    //       (element) {
    //         return element.extendedHoursType == 'PreMarket';
    //       },
    //     ) ==
    //     true;

    // postMarket = dataList?.any(
    //       (element) {
    //         return element.extendedHoursType == 'PostMarket';
    //       },
    //     ) ==
    //     true;
    MarketScannerProvider scannerProvider =
        context.read<MarketScannerProvider>();
    preMarket =
        scannerProvider.port?.port?.checkMarketOpenApi?.checkPreMarket ?? false;
    postMarket =
        scannerProvider.port?.port?.checkMarketOpenApi?.checkPostMarket ??
            false;

    text = preMarket
        ? 'Pre-Market'
        : postMarket
            ? 'Post-Market'
            : null;
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
          ScannerTopGainerFilter(
            onPercentClick: () {
              provider.applyFilter(2);
            },
            onVolumnClick: () {
              provider.applyFilter(3);
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
                          showPreMarket: !(preMarket || postMarket),
                          text: text,
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
    );
  }
}

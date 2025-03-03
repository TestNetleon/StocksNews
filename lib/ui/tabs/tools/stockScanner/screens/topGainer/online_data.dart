import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/managers/market_scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/managers/top_gainer_scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/sorting/shorting.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/topGainer/scanner_header.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/topGainer/top_gainer_filter.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/services/streams/gainers_stream.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../widget/container.dart';

class TopGainerOnline extends StatefulWidget {
  const TopGainerOnline({super.key});

  @override
  State<TopGainerOnline> createState() => _TopGainerOnlineState();
}

class _TopGainerOnlineState extends State<TopGainerOnline> {
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

  _setPrePost() {
    TopGainerScannerM provider =
        context.read<TopGainerScannerM>();

    provider.resetLiveFilter();

    MarketScannerM scannerProvider =
        context.read<MarketScannerM>();
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
  void dispose() {
    TopGainerScannerM provider =
        navigatorKey.currentContext!.read<TopGainerScannerM>();
    provider.stopListeningPorts();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TopGainerScannerM provider =
        context.watch<TopGainerScannerM>();
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

      ],
    );
  }

}


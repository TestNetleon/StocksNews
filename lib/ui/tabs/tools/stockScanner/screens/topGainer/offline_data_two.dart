import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/managers/market_scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/managers/top_gainer_scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/sorting/shorting.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/topGainer/scanner_header.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/topGainer/top_gainer_filter.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/services/streams/gainers_stream.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../widget/container.dart';

class TopGainerOfflineTwo extends StatefulWidget {
  const TopGainerOfflineTwo({super.key});

  @override
  State<TopGainerOfflineTwo> createState() => _TopGainerOfflineTwoState();
}

class _TopGainerOfflineTwoState extends State<TopGainerOfflineTwo> {
  bool preMarket = false;
  bool postMarket = false;
  String? text;


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
  Widget build(BuildContext context) {
    TopGainerScannerM provider =
        context.watch<TopGainerScannerM>();
    List<ScannerRes>? dataList = provider.offlineDataList;
    if (dataList == null) {
      return SizedBox();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          TopGainerScannerHeader(isOnline: false),
          ScannerTopGainerFilter(
            onPercentClick: () async {
              provider.applyFilter(2);
              showGlobalProgressDialog();
              await MarketGainersStream.instance.getOfflineData();
              closeGlobalProgressDialog();
            },
            onVolumnClick: () async {
              provider.applyFilter(3);
              showGlobalProgressDialog();
              await MarketGainersStream.instance.getOfflineData();
              closeGlobalProgressDialog();
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
                          showPreMarket: true,
                          text: text,
                          sortBy: provider.filterParams?.sortByAsc,
                          header: provider.filterParams?.sortByHeader,
                          sortByCallBack: (received) async {
                            Utils().showLog(
                                '${received.type}, ${received.ascending} ');

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

}


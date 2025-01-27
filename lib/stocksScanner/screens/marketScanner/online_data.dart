import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/screens/marketScanner/scanner_header.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
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
          // const SpacerVertical(height: 10),
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
                        'Total number of results: ${dataList.length}',
                        style: styleGeorgiaBold(),
                      ),
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        scannerSorting(
                          sortBy: provider.filterParams?.sortByAsc,
                          header: provider.filterParams?.sortBy,
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
    );
  }
}

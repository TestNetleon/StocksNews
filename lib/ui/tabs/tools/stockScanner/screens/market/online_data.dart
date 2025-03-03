import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/managers/market_scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/market/scanner_header.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/sorting/shorting.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/widget/container.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';


class MarketScannerOnline extends StatefulWidget {
  const MarketScannerOnline({super.key});

  @override
  State<MarketScannerOnline> createState() => _MarketScannerOnlineState();
}

class _MarketScannerOnlineState extends State<MarketScannerOnline> {
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

  _setPrePost() {
    MarketScannerM provider = context.read<MarketScannerM>();

    preMarket =
        provider.port?.port?.checkMarketOpenApi?.checkPreMarket ?? false;
    postMarket =
        provider.port?.port?.checkMarketOpenApi?.checkPostMarket ?? false;

    text = preMarket
        ? 'Pre-Market'
        : postMarket
            ? 'Post-Market'
            : null;
    Utils().showLog('---HI-- $text');
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MarketScannerM provider = context.watch<MarketScannerM>();
    List<MarketScannerRes>? dataList = provider.dataList;
    if (dataList == null) {
      return SizedBox();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          MarketScannerHeader(isOnline: true),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                          showPreMarket: !(preMarket || postMarket),
                          text: text,
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
                          Icon(Icons.sort,color: ThemeColors.primary),
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

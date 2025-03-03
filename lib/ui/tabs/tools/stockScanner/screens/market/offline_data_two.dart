import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/managers/market_scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/market/scanner_header.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/sorting/shorting.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/widget/container.dart';

import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';


class MarketScannerOfflineTwo extends StatefulWidget {
  const MarketScannerOfflineTwo({super.key});

  @override
  State<MarketScannerOfflineTwo> createState() =>
      _MarketScannerOfflineTwoState();
}

class _MarketScannerOfflineTwoState extends State<MarketScannerOfflineTwo> {
  bool preMarket = false;
  bool postMarket = false;
  String? text;
  @override
  void initState() {
    super.initState();

    _setPrePost();
  }

  @override
  void dispose() {
    super.dispose();
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
  }

  @override
  Widget build(BuildContext context) {
    MarketScannerM provider = context.watch<MarketScannerM>();
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
                        style: styleGeorgiaBold(fontSize: 14,color: ThemeColors.neutral80),
                      ),
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        scannerSorting(
                          showSector: false,
                          showPreMarket: true,
                          sortBy: provider.filterParams?.sortByAsc,
                          header: provider.filterParams?.sortBy,
                          text: text,
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
                            style: styleGeorgiaBold(fontSize: 14,color: ThemeColors.neutral80),
                          ),
                          Icon(Icons.sort,color: ThemeColors.neutral80,size: 18),
                        ],
                      ),
                    ),
                  ),
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

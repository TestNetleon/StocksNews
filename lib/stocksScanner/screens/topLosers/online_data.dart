import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/stocksScanner/apis/top_loser_scanner_manager.dart';
import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/providers/top_loser_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/screens/stockScanner/common_scanner_ui.dart';
import 'package:stocks_news_new/stocksScanner/screens/topGainers/top_gainer_filter.dart';
import 'package:stocks_news_new/stocksScanner/screens/topLosers/scanner_header.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/constants.dart';

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
          ScannerTopGainerFilter(
            onPercentClick: () {
              provider.applyFilter(2);
            },
            onVolumnClick: () {
              provider.applyFilter(3);
            },
            onRestartClick: () {
              TopLoserScannerDataManager().initializePorts();
              provider.clearFilter();
            },
            isPercent: provider.filterParams?.sortBy == 2,
            isVolume: provider.filterParams?.sortBy == 3,
            orderByAsc: provider.filterParams?.sortByAsc,
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            child: Row(
              children: [
                // Fixed column
                DataTable(
                  horizontalMargin: 10,
                  dataRowColor: WidgetStatePropertyAll(
                    ThemeColors.greyText.withValues(alpha: .4),
                  ),
                  headingRowColor: WidgetStatePropertyAll(
                    ThemeColors.greyText.withValues(alpha: .4),
                  ),
                  border: TableBorder.all(
                    color: ThemeColors.greyBorder,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    width: 0.9,
                  ),
                  columns: [
                    dataColumn(
                      text: 'Symbol',
                      onTap: () => provider.applySorting('Symbol'),
                      sortBy: provider.filterParams?.sortByHeader == 'Symbol'
                          ? provider.filterParams?.sortByAsc
                          : null,
                    ),
                  ],
                  rows: dataList.map(
                    (data) {
                      return DataRow(
                        cells: [
                          DataCell(
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                constraints: BoxConstraints(
                                  maxWidth: ScreenUtil().screenWidth * .3,
                                ),
                                // width: 100,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${data.identifier}",
                                        // company.symbol ?? "",
                                        style: styleGeorgiaBold(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
                // Scrollable columns
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      horizontalMargin: 10,
                      border: TableBorder(
                        top: BorderSide(
                          color: ThemeColors.greyBorder,
                          width: 0.5,
                        ),
                        bottom: BorderSide(
                          color: ThemeColors.greyBorder,
                          width: 0.5,
                        ),
                        horizontalInside: BorderSide(
                          color: ThemeColors.greyBorder,
                          width: 0.5,
                        ),
                      ),
                      columns: columnHeader.map(
                        (header) {
                          return dataColumn(
                            text: header,
                            onTap: () => provider.applySorting(header),
                            sortBy:
                                provider.filterParams?.sortByHeader == header
                                    ? provider.filterParams?.sortByAsc
                                    : null,
                          );
                        },
                      ).toList(),
                      rows: dataList.map(
                        (data) {
                          double lastTrade = (data.last ?? 0);
                          double netChange = (data.change ?? 0);
                          double perChange = data.percentChange ?? 0;
                          if (data.extendedHoursType == "PostMarket" ||
                              data.extendedHoursType == "PreMarket") {
                            netChange = data.extendedHoursChange ?? 0;
                            perChange = data.extendedHoursPercentChange ?? 0;
                          }

                          return DataRow(
                            cells: [
                              _dataCell(
                                text: "${data.security?.name}",
                              ), // "Company Name",
                              _dataCell(text: "${data.sector}"), // "Sector",
                              _dataCell(text: "\$$lastTrade"), // "Last Trade",
                              _dataCell(
                                text: "\$$netChange",
                                // text: "\$${data.change}",
                                change: true,
                                // value: data.change,
                                value: netChange,
                              ), // "Net Change",
                              _dataCell(
                                text: "$perChange", // "% Change",
                                // text: "${data.percentChange}", // "% Change",
                                change: true,
                                // value: data.percentChange,
                                value: perChange,
                              ),
                              _dataCell(
                                text: num.parse("${data.volume ?? 0}")
                                    .toRuppeeFormatWithoutFloating(),
                              ), // "Volume",
                              _dataCell(
                                text: num.parse(
                                        "${(data.volume ?? 0) * (data.last ?? 0)}")
                                    .toRuppees(), // "$ Volume"
                              ),
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ],
            ),
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/screens/marketScanner/scanner_header.dart';
import 'package:stocks_news_new/stocksScanner/screens/stockScanner/common_scanner_ui.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class MarketScannerOnline extends StatefulWidget {
  const MarketScannerOnline({super.key});

  @override
  State<MarketScannerOnline> createState() => _MarketScannerOnlineState();
}

class _MarketScannerOnlineState extends State<MarketScannerOnline> {
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
    // MarketScannerProvider provider =
    //     navigatorKey.currentContext!.read<MarketScannerProvider>();
    // provider.stopListeningPorts();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MarketScannerProvider provider = context.watch<MarketScannerProvider>();
    List<MarketScannerRes>? dataList = provider.dataList;
    if (dataList == null) {
      return SizedBox();
    }

    // String marketStatus = dataList[0].extendedHoursType ?? "";
    // // String lastUpdated = DateFormat("hh:mm:ss").format(DateTime.now());

    // if (!(dataList[0].extendedHoursType == "PostMarket" ||
    //     dataList[0].extendedHoursType == "PreMarket")) {
    //   marketStatus = "Live";
    // }

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
                      text: "Symbol",
                      onTap: () => provider.applySorting("Symbol"),
                      sortBy: provider.filterParams?.sortBy == "Symbol"
                          ? provider.filterParams?.sortByAsc
                          : null,
                    ),
                    // DataColumn(
                    //   label: ConstrainedBox(
                    //     constraints: BoxConstraints(
                    //       maxWidth: ScreenUtil().screenWidth * .3,
                    //     ),
                    //     child: GestureDetector(
                    //       onTap: () => provider.applySorting("Symbol"),
                    //       child: Text(
                    //         'Symbol',
                    //         style: styleGeorgiaBold(
                    //           fontSize: 14,
                    //           color: ThemeColors.greyText,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                  rows: dataList.map(
                    (data) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              constraints: BoxConstraints(
                                maxWidth: ScreenUtil().screenWidth * .3,
                              ),
                              child: Text(
                                "${data.identifier}",
                                style: styleGeorgiaBold(fontSize: 12),
                              ),
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child:
                              //       Text(
                              //         "${data.identifier}",
                              //         style: styleGeorgiaBold(fontSize: 12),
                              //       ),
                              //     ),
                              //   ],
                              // ),
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
                      columns: provider.tableHeader.map(
                        (header) {
                          return dataColumn(
                            text: header,
                            onTap: () => provider.applySorting(header),
                            sortBy: provider.filterParams?.sortBy == header
                                ? provider.filterParams?.sortByAsc
                                : null,
                          );
                          // return DataColumn(
                          //   label: GestureDetector(
                          //     onTap: () => provider.applySorting(header),
                          //     child: Container(
                          //       padding: EdgeInsets.symmetric(
                          //         horizontal: 10,
                          //         vertical: 10,
                          //       ),
                          //       child: Text(
                          //         header,
                          //         style: styleGeorgiaBold(
                          //           fontSize: 14,
                          //           color: ThemeColors.greyText,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // );
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
                            lastTrade = data.extendedHoursPrice ?? 0;
                          }

                          return DataRow(
                            cells: [
                              // "Company Name",
                              dataCell(text: "${data.security?.name}"),
                              dataCell(text: "${data.sector}"), // "Sector",
                              dataCell(text: "\$${data.bid}"), // "Bid",
                              dataCell(text: "\$${data.ask}"), // "Ask",
                              dataCell(
                                text: "\$$lastTrade",
                              ), // "Last Trade",

                              dataCell(
                                text: "\$$netChange",
                                change: true,
                                value: netChange,
                              ), // "Net Change",
                              dataCell(
                                text: "$perChange", // "% Change",
                                change: true,
                                value: perChange,
                              ),
                              dataCell(
                                text: num.parse("${data.volume ?? 0}")
                                    .toRuppeeFormatWithoutFloating(),
                              ), // "Volume",
                              dataCell(
                                text: num.parse(
                                        "${(data.volume ?? 0) * (data.last ?? 0)}")
                                    .toRuppees(), // "$Volume"
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

  // DataCell _dataCell({required String text, bool change = false, num? value}) {
  //   return DataCell(
  //     ConstrainedBox(
  //       constraints: BoxConstraints(
  //         maxWidth: ScreenUtil().screenWidth * .3,
  //       ),
  //       child: Text(
  //         // userPercent ? "$text%" : "$text",
  //         text,
  //         style: styleGeorgiaBold(
  //           fontSize: 12,
  //           // color: Colors.white,
  //           color: value != null
  //               ? (value >= 0 ? ThemeColors.accent : ThemeColors.sos)
  //               : Colors.white,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

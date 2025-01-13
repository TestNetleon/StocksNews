import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/providers/top_gainer_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/screens/stockScanner/common_scanner_ui.dart';
import 'package:stocks_news_new/stocksScanner/screens/topGainers/scanner_header.dart';
import 'package:stocks_news_new/stocksScanner/screens/topGainers/top_gainer_filter.dart';
// import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/constants.dart';

class TopGainerOffline extends StatefulWidget {
  const TopGainerOffline({super.key});

  @override
  State<TopGainerOffline> createState() => _TopGainerOfflineState();
}

class _TopGainerOfflineState extends State<TopGainerOffline> {
  List<String> columnHeader = [
    "Time",
    "Company Name",
    "Sector",
    "Bid",
    "Ask",
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
      // TopGainerScannerProvider provider =
      //     context.read<TopGainerScannerProvider>();
      // provider.startListeningPorts();
      // provider.getOfflineData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TopGainerScannerProvider provider =
        context.watch<TopGainerScannerProvider>();
    List<ScannerRes>? dataList = provider.offlineDataList;

    if (dataList == null) {
      return SizedBox();
    }

    return Column(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              TopGainerScannerHeader(isOnline: false),
              // const SpacerVertical(height: 10),
              ScannerTopGainerFilter(
                onPercentClick: () {
                  provider.applyFilter(2);
                },
                onVolumnClick: () {
                  provider.applyFilter(3);
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
                          sortBy:
                              provider.filterParams?.sortByHeader == 'Symbol'
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    constraints: BoxConstraints(
                                      maxWidth: ScreenUtil().screenWidth * .3,
                                    ),
                                    // width: 100,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            data.identifier,
                                            // company.symbol ?? "",
                                            style:
                                                styleGeorgiaBold(fontSize: 12),
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
                                sortBy: provider.filterParams?.sortByHeader ==
                                        header
                                    ? provider.filterParams?.sortByAsc
                                    : null,
                              );
                            },
                          ).toList(),
                          rows: dataList.map(
                            (data) {
                              return DataRow(
                                cells: [
                                  _dataCell(text: data.time), // "Time",
                                  // _dataCell(text: data.identifier), // "Symbol",
                                  _dataCell(text: data.name), // "Company Name",
                                  _dataCell(
                                      text: data.sector ?? ""), // "Sector",
                                  _dataCell(text: "\$${data.bid}"), // "Bid",
                                  _dataCell(text: "\$${data.ask}"), // "Ask",
                                  _dataCell(
                                      text: "\$${data.price}"), // "Last Trade",
                                  _dataCell(
                                    text: "\$${data.change}",
                                    change: true,
                                    value: data.change,
                                  ), // "Net Change",
                                  _dataCell(
                                    text:
                                        "${data.changesPercentage}", // "% Change",
                                    change: true,
                                    value: data.changesPercentage,
                                  ),
                                  _dataCell(
                                    text: (data.volume ?? 0)
                                        .toRuppeeFormatWithoutFloating(),
                                  ), // "Volume",
                                  _dataCell(
                                    text:
                                        num.parse("${data.volume * data.price}")
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
        ),
      ],
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

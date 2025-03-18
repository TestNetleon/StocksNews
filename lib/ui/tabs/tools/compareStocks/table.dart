import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/widgets/linear_bar.dart';

import '../../../../managers/tools.dart';
import '../../../../models/ticker.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/theme.dart';

class ToolsCompareTable extends StatelessWidget {
  const ToolsCompareTable({super.key});

  @override
  Widget build(BuildContext context) {
    ToolsManager manager = context.watch<ToolsManager>();
    List<BaseTickerRes>? data = manager.compareData?.data;
    if (data == null || data.isEmpty) {
      return SizedBox();
    }
    int columnCount = data.length;

    return Row(
      children: [
        // Static column
        DataTable(
          border: TableBorder(
            top: BorderSide(color: ThemeColors.neutral10, width: 0.5),
            bottom: BorderSide(color: ThemeColors.neutral10, width: 0.5),
          ),
          horizontalMargin: 16,
          columns: [
            DataColumn(
              label: Text(
                'Stock',
                style: styleBaseBold(
                  fontSize: 13,
                  color: ThemeColors.neutral40,
                ),
              ),
            ),
          ],
          rows: List.generate(
            manager.tableRow.length,
            (index) => DataRow(
              cells: [
                _cell(
                  manager.tableRow[index],
                ),
              ],
            ),
          ),
        ),

        // Scrollable columns
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              horizontalMargin: 16,
              border: TableBorder(
                top: BorderSide(color: ThemeColors.neutral10, width: 0.5),
                bottom: BorderSide(color: ThemeColors.neutral10, width: 0.5),
              ),
              columns: List.generate(columnCount, (index) {
                return DataColumn(
                  label: Text(
                    '${data[index].symbol}',
                    style: styleBaseBold(
                      fontSize: 13,
                      color: ThemeColors.black,
                    ),
                  ),
                );
              }),
              rows: List.generate(
                manager.tableRow.length,
                (rowIndex) {
                  return DataRow(
                    cells: List.generate(
                      columnCount,
                      (colIndex) {
                        BaseTickerRes? tickerData = data[colIndex];
                        String cellValue = _getCellValue(rowIndex, tickerData);

                        if (rowIndex == 0) {
                          return DataCell(
                            SizedBox(
                              width: 100,
                              child: LinearBarCommon(
                                value: num.parse(cellValue),
                              ),
                            ),
                          );
                        }
                        if (rowIndex == 1) {
                          return DataCell(
                            SizedBox(
                              width: 100,
                              child: LinearBarCommon(
                                value: num.parse(cellValue),
                              ),
                            ),
                          );
                        }
                        if (rowIndex == 2) {
                          return DataCell(
                            SizedBox(
                              width: 100,
                              child: LinearBarCommon(
                                value: num.parse(cellValue),
                              ),
                            ),
                          );
                        }
                        if (rowIndex == 3) {
                          return DataCell(
                            SizedBox(
                              width: 100,
                              child: LinearBarCommon(
                                value: num.parse(cellValue),
                              ),
                            ),
                          );
                        }
                        if (rowIndex == 4) {
                          return DataCell(
                            SizedBox(
                              width: 100,
                              child: LinearBarCommon(
                                value: num.parse(cellValue),
                              ),
                            ),
                          );
                        }
                        if (rowIndex == 5) {
                          return DataCell(
                            SizedBox(
                              width: 100,
                              child: LinearBarCommon(
                                value: num.parse(cellValue),
                              ),
                            ),
                          );
                        }
                        return _cell(
                          cellValue,
                          style: styleBaseRegular(
                            fontSize: 13,
                            color: ThemeColors.black,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  static DataCell _cell(String text, {TextStyle? style}) {
    return DataCell(
      Text(
        text,
        style: style ??
            styleBaseRegular(
              fontSize: 13,
              color: ThemeColors.neutral40,
            ),
      ),
    );
  }

  String _getCellValue(int rowIndex, BaseTickerRes? ticker) {
    if (ticker == null) return '-';

    switch (rowIndex) {
      case 0:
        return '${ticker.overallPercent ?? '-'}';
      case 1:
        return '${ticker.fundamentalPercent ?? '-'}';
      case 2:
        return '${ticker.shortTermPercent ?? '-'}';
      case 3:
        return '${ticker.longTermPercent ?? '-'}';
      case 4:
        return '${ticker.analystRankingPercent ?? '-'}';
      case 5:
        return '${ticker.valuationPercent ?? '-'}';
      case 6:
        return ticker.displayPrice ?? '-';
      case 7:
        return ticker.displayChange ?? '-';
      case 8:
        return '${ticker.changesPercentage ?? '-'}';
      case 9:
        return ticker.dayLow ?? '-';
      case 10:
        return ticker.dayHigh ?? '-';
      case 11:
        return ticker.yearLow ?? '-';
      case 12:
        return ticker.yearHigh ?? '-';
      case 13:
        return ticker.mktCap ?? '-';
      case 14:
        return ticker.priceAvg50 ?? '-';
      case 15:
        return ticker.priceAvg200 ?? '-';
      case 16:
        return ticker.exchange ?? '-';
      case 17:
        return ticker.volume ?? '-';
      case 18:
        return ticker.avgVolume ?? '-';
      case 19:
        return ticker.open ?? '-';
      case 20:
        return ticker.previousClose ?? '-';
      case 21:
        return ticker.eps ?? '-';
      case 22:
        return '${ticker.pe ?? '-'}';
      case 23:
        return ticker.earningsAnnouncement ?? '-';
      default:
        return '-';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/financial.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class FinancialTableItem extends StatelessWidget {
  const FinancialTableItem({required this.index, super.key});
  final int index;

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();

    List<FinanceStatement>? financeStatements =
        provider.sdFinancialChartRes?.financeStatement;
    Map<String, dynamic>? data = provider.sdFinancialArray?[index];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 2000,
        child: financeStatements == null
            ? Center(
                child: Text(
                  'No Data Available',
                  style: stylePTSansBold(fontSize: 16),
                ),
              )
            : Table(
                border: TableBorder.all(
                  color: ThemeColors.greyBorder,
                  width: 2,
                ),
                children: [
                  ...financeStatements.map((statement) {
                    return TableRow(
                      children: data!.entries
                          .map((entry) => TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "${entry.value ?? 'N/A'}",
                                      style: stylePTSansRegular(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    );
                  }).toList(),
                ],
              ),
      ),
    );
  }
}

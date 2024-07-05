import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class FinancialTableItem extends StatefulWidget {
  const FinancialTableItem({super.key});

  @override
  State<FinancialTableItem> createState() => _FinancialTableItemState();
}

class _FinancialTableItemState extends State<FinancialTableItem> {
  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();

    if (provider.sdFinancialArray == null ||
        provider.sdFinancialArray!.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: stylePTSansRegular(),
        ),
      );
    }

    return ListView.separated(
        padding: const EdgeInsets.only(top: 0, bottom: 15),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          Map<String, dynamic>? data = provider.sdFinancialArray?[index];

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ThemeColors.greyBorder.withOpacity(0.3),
              ),
              child: DataTable(
                border: TableBorder.all(color: Colors.white),
                columns: _createColumns(data),
                rows: _createRows(data),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SpacerVertical(height: 0);
        },
        itemCount: provider.sdFinancialArray?.length ?? 0);
  }

  List<DataColumn> _createColumns(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return [];

    return data.keys.map((key) {
      return DataColumn(
        label: Text(
          "$key",
          style: stylePTSansRegular(),
        ),
      );
    }).toList();
  }

  List<DataRow> _createRows(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return [];

    return [
      DataRow(
        cells: data.values.map((value) {
          return DataCell(
            Text(
              "$value",
              style: stylePTSansRegular(),
            ),
          );
        }).toList(),
      ),
    ];
  }
}

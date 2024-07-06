import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/theme.dart'; // Adjust based on your actual import path

class FinancialTableItem extends StatelessWidget {
  const FinancialTableItem({super.key});

  @override
  Widget build(BuildContext context) {
    final financialData =
        Provider.of<StockDetailProviderNew>(context).sdFinancialArray;

    return financialData != null
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              border: TableBorder.all(color: Colors.white),
              columnSpacing: 20,
              columns: _createColumns(financialData.first),
              rows: financialData.map((data) => _createRows(data)).toList(),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }

  List<DataColumn> _createColumns(Map<String, dynamic> data) {
    return data.keys.map((key) {
      return DataColumn(
        label: Text(
          key,
          style: stylePTSansRegular(),
        ),
      );
    }).toList();
  }

  DataRow _createRows(Map<String, dynamic> data) {
    return DataRow(
      cells: data.values.map((value) {
        return DataCell(
          Text(
            value.toString(),
            style: stylePTSansRegular(),
          ),
        );
      }).toList(),
    );
  }

  TextStyle stylePTSansRegular() {
    return stylePTSansBold(); // Example style
  }
}

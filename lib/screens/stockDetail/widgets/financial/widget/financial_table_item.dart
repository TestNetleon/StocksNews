import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/theme.dart'; // Adjust based on your actual import path

class FinancialTableItem extends StatefulWidget {
  const FinancialTableItem({Key? key}) : super(key: key);

  @override
  _FinancialTableItemState createState() => _FinancialTableItemState();
}

class _FinancialTableItemState extends State<FinancialTableItem> {
  List<DataColumn> _columns = [];
  List<DataRow> _rows = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    final financialData =
        Provider.of<StockDetailProviderNew>(context, listen: false)
            .sdFinancialArray;

    if (financialData != null && financialData.isNotEmpty) {
      _columns = _createColumns(financialData.first);
      _rows = financialData.map((data) => _createRows(data)).toList();
    }
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

  @override
  Widget build(BuildContext context) {
    return Consumer<StockDetailProviderNew>(
      builder: (context, provider, _) {
        final financialData = provider.sdFinancialArray;

        return financialData != null && financialData.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder.all(color: Colors.white),
                  columnSpacing: 20,
                  columns: _columns,
                  rows: _rows,
                ),
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  TextStyle stylePTSansRegular() {
    return stylePTSansBold(); // Example style
  }
}

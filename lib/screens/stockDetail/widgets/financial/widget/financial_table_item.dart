import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';

class FinancialTableItem extends StatelessWidget {
  const FinancialTableItem({super.key});

  @override
  Widget build(BuildContext context) {
    final financialData =
        Provider.of<StockDetailProviderNew>(context).sdFinancialArray;

    if (financialData == null || financialData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<Map<String, dynamic>> typedFinancialData =
        List<Map<String, dynamic>>.from(financialData);

    final transformedData = _transformData(typedFinancialData);

    return Row(
      children: [
        DataTable(
          border: TableBorder.all(
            color: ThemeColors.greyBorder,
          ),
          columns: [
            DataColumn(
              label: Text(
                "Key",
                style: stylePTSansRegular(),
              ),
            ),
          ],
          rows: transformedData.map((data) {
            return DataRow(
              cells: [
                DataCell(
                  SizedBox(
                    width: 100,
                    child: Text(
                      data['Key'].toString(),
                      style: stylePTSansRegular(),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              border: TableBorder.all(
                color: ThemeColors.greyBorder,
              ),
              columnSpacing: 20,
              columns: _createColumns(transformedData.first),
              rows: transformedData
                  .map((data) => _createValuesRows(context, data))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  List<DataColumn> _createColumns(Map<String, dynamic> data) {
    return data.keys.where((key) => key != 'Key').map((key) {
      return DataColumn(
        label: Text(
          key,
          style: stylePTSansRegular(),
        ),
      );
    }).toList();
  }

  DataRow _createValuesRows(BuildContext context, Map<String, dynamic> data) {
    return DataRow(
      cells: data.entries.where((entry) => entry.key != 'Key').map((entry) {
        final value = entry.value;
        final isLink =
            value is String && Uri.tryParse(value)?.hasAbsolutePath == true;

        return DataCell(
          isLink
              ? InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    openUrl(entry.value);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.info_rounded,
                      color: ThemeColors.accent,
                      size: 20,
                    ),
                  ),
                )
              : SizedBox(
                  child: Text(
                    value.toString(),
                    style: stylePTSansRegular(),
                  ),
                ),
        );
      }).toList(),
    );
  }

  List<Map<String, dynamic>> _transformData(
      List<Map<String, dynamic>> originalData) {
    if (originalData.isEmpty) return [];

    final keys = originalData.first.keys.toList();
    final transformedData = <Map<String, dynamic>>[];

    for (var key in keys) {
      final row = <String, dynamic>{'Key': key};
      for (var i = 0; i < originalData.length; i++) {
        row['Value $i'] = originalData[i][key];
      }
      transformedData.add(row);
    }

    return transformedData;
  }

  TextStyle stylePTSansRegular() {
    return stylePTSansBold(fontSize: 12); // Example style
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SDFinancials extends StatelessWidget {
  const SDFinancials({super.key});

  void openUrl(String? url) async {
    if (url != null && url.isNotEmpty) {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Could not launch $url");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SDManager>(
      builder: (context, manager, child) {
        final financialData = manager.dataFinancials ?? [];
        final bool hasData = financialData.isNotEmpty;
        final labels = hasData ? financialData.first.keys.toList() : [];

        return hasData
            ? BaseScroll(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Fixed width column for labels
                        SizedBox(
                          width: 140,
                          child: DataTable(
                            headingRowColor: WidgetStatePropertyAll(
                                ThemeColors.greyText.withOpacity(0.4)),
                            border: TableBorder.all(
                                color: ThemeColors.greyBorder, width: 0.9),
                            columns: [
                              DataColumn(
                                label: Text(
                                  'Period',
                                  style: styleGeorgiaBold(
                                      fontSize: 12,
                                      color: ThemeColors.greyText),
                                ),
                              ),
                            ],
                            rows: labels
                                .where((label) => label != "Period")
                                .map((label) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    IntrinsicHeight(
                                      // Adjusts height dynamically
                                      child: Text(
                                        label,
                                        style: styleGeorgiaBold(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),

                        // Scrollable financial data columns
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 16.0,
                              border: TableBorder.all(
                                  color: ThemeColors.greyBorder, width: 0.5),
                              columns: financialData.map((row) {
                                return DataColumn(
                                  label: Text(
                                    row["Period"]?.toString() ?? "N/A",
                                    style: styleGeorgiaBold(
                                        fontSize: 12,
                                        color: ThemeColors.greyText),
                                  ),
                                );
                              }).toList(),
                              rows: labels
                                  .where((label) => label != "Period")
                                  .map((label) {
                                return DataRow(
                                  cells: financialData.map((row) {
                                    return DataCell(
                                      label == "Link"
                                          ? GestureDetector(
                                              onTap: () => openUrl(
                                                  row[label]?.toString()),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "View",
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                                  ),
                                                  Icon(Icons.info_outline,
                                                      color: Colors.blue,
                                                      size: 16),
                                                ],
                                              ),
                                            )
                                          : Text(row[label]?.toString() ?? "-"),
                                    );
                                  }).toList(),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Center(child: Text("No financial data available"));
      },
    );
  }
}

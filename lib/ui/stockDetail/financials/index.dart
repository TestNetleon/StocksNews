import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../../../widgets/error_display_widget.dart';

class SDFinancials extends StatelessWidget {
  const SDFinancials({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SDManager>(
      builder: (context, manager, child) {
        final financialData = manager.dataFinancials ?? [];
        final bool hasData = financialData.isNotEmpty;
        final labels = hasData ? financialData.first.keys.toList() : [];

        return hasData
            ? BaseScroll(
                onRefresh: manager.onSelectedTabRefresh,
                margin: EdgeInsets.zero,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.46,
                          child: DataTable(
                            decoration:
                                BoxDecoration(color: ThemeColors.neutral5),
                            border:
                                TableBorder.all(color: ThemeColors.neutral5),
                            columns: [
                              DataColumn(
                                label: Text(
                                  maxLines: 2,
                                  'Period',
                                  style: styleBaseBold(fontSize: 13),
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
                                      child: Text(
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        label,
                                        style: styleBaseBold(fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 30,
                              border: TableBorder(
                                top: BorderSide(
                                  color: ThemeColors.neutral10,
                                  width: 0.5,
                                ),
                                bottom: BorderSide(
                                  color: ThemeColors.neutral10,
                                  width: 0.5,
                                ),
                                left: BorderSide(
                                  color: ThemeColors.neutral10,
                                  width: 0.5,
                                ),
                              ),
                              columns: financialData.map((row) {
                                return DataColumn(
                                  label: Text(
                                    row["Period"]?.toString() ?? "N/A",
                                    style: styleBaseRegular(fontSize: 13),
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
                                              child: Text(
                                                "View Detail",
                                                style: styleBaseRegular(
                                                    fontSize: 13,
                                                    color: ThemeColors
                                                        .secondary120),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Text(
                                                row[label]?.toString() ?? "-",
                                                style: styleBaseRegular(
                                                    fontSize: 13),
                                              ),
                                            ),
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
            : manager.isLoadingFinancial
                ? Loading()
                : ErrorDisplayNewWidget(
                    error: manager.error ?? Const.errNoRecord,
                    onRefresh: manager.onSelectedTabRefresh,
                  );
      },
    );
  }
}

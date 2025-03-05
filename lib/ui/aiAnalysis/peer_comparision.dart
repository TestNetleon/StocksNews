import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../../widgets/cache_network_image.dart';
import '../../managers/aiAnalysis/ai.dart';
import '../../models/ai_analysis.dart';

class AIPeerComparison extends StatefulWidget {
  const AIPeerComparison({super.key});

  @override
  State<AIPeerComparison> createState() => _AIPeerComparisonState();
}

class _AIPeerComparisonState extends State<AIPeerComparison> {
  @override
  Widget build(BuildContext context) {
    AIManager manager = context.watch<AIManager>();
    AIPeerComparisonRes? peerComparison = manager.data?.peerComparison;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseHeading(
          title: peerComparison?.title,
          margin:
              EdgeInsets.symmetric(horizontal: Pad.pad16, vertical: Pad.pad10),
        ),
        Row(
          children: [
            // Fixed column
            DataTable(
              horizontalMargin: 10,
              decoration: BoxDecoration(color: ThemeColors.neutral5),
              // dataRowColor: WidgetStatePropertyAll(
              //   ThemeColors.greyText.withOpacity(0.4),
              // ),
              // headingRowColor: WidgetStatePropertyAll(
              //   ThemeColors.greyText.withOpacity(0.4),
              // ),
              border: TableBorder(
                right: BorderSide(
                  color: ThemeColors.neutral10,
                ),
              ),
              columns: [
                DataColumn(
                  label: Text(
                    'Company',
                    style: styleBaseBold(fontSize: 13),
                  ),
                ),
              ],
              rows: peerComparison?.peerComparison?.map((company) {
                    return DataRow(
                      cells: [
                        DataCell(
                          GestureDetector(
                            // onTap: () {
                            //   Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => StockDetail(
                            //         symbol: company.symbol ?? "",
                            //       ),
                            //     ),
                            //   );
                            // },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              // width: 100,
                              child: Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      // color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: CachedNetworkImagesWidget(
                                      company.image ?? "",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SpacerHorizontal(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      company.symbol ?? "",
                                      style: styleBaseBold(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList() ??
                  [],
            ),

            // Scrollable columns
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  horizontalMargin: 10,
                  columns: peerComparison?.headers?.map((header) {
                        return DataColumn(
                          label: Text(
                            header,
                            style: styleBaseBold(fontSize: 13),
                          ),
                        );
                      }).toList() ??
                      [],
                  rows: peerComparison?.peerComparison?.map((company) {
                        return DataRow(
                          cells: [
                            _dataCell(
                              text: company.peRatio ?? 0,
                              userPercent: false,
                            ),
                            _dataCell(text: company.returns ?? 0),
                            _dataCell(text: company.salesGrowth ?? 0),
                            _dataCell(text: company.profitGrowth ?? 0),
                            _dataCell(text: company.roe ?? 0),
                          ],
                        );
                      }).toList() ??
                      [],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  DataCell _dataCell({required num text, bool userPercent = true}) {
    return DataCell(
      Center(
        child: Text(
          userPercent ? "$text%" : "$text",
          style: styleGeorgiaBold(
              fontSize: 13,
              color: text >= 0 ? ThemeColors.accent : ThemeColors.sos),
        ),
      ),
    );
  }
}

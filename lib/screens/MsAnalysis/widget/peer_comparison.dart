import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../../modals/msAnalysis/complete.dart';
import '../../../widgets/cache_network_image.dart';
import 'title_tag.dart';

class MsPeerComparison extends StatefulWidget {
  const MsPeerComparison({super.key});

  @override
  State<MsPeerComparison> createState() => _MsPeerComparisonState();
}

class _MsPeerComparisonState extends State<MsPeerComparison> {
  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    MsTextRes? text = provider.completeData?.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MsTitle(
          title: text?.peer?.title,
          subtitle: text?.peer?.subTitle,
        ),
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
          child: Row(
            children: [
              // Fixed column
              DataTable(
                horizontalMargin: 10,
                dataRowColor: WidgetStatePropertyAll(
                  ThemeColors.greyText.withOpacity(0.4),
                ),
                headingRowColor: WidgetStatePropertyAll(
                  ThemeColors.greyText.withOpacity(0.4),
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
                  DataColumn(
                    label: Text(
                      'Company',
                      style: styleGeorgiaBold(
                        fontSize: 12,
                        color: ThemeColors.greyText,
                      ),
                    ),
                  ),
                ],
                rows: provider.completeData?.peerComparison?.peerComparison
                        ?.map((company) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Container(
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
                                      style: styleGeorgiaBold(fontSize: 12),
                                    ),
                                  ),
                                ],
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
                    // border: TableBorder.all(
                    //   color: ThemeColors.greyBorder,
                    //   // borderRadius: BorderRadius.circular(10.0),
                    //   borderRadius: BorderRadius.only(
                    //     topRight: Radius.circular(10),
                    //     bottomRight: Radius.circular(10),
                    //   ),
                    //   width: 0.9,
                    // ),
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
                    columns: provider.completeData?.peerComparison?.headers
                            ?.map((header) {
                          return DataColumn(
                            label: Text(
                              header,
                              style: styleGeorgiaBold(
                                fontSize: 12,
                                color: ThemeColors.greyText,
                              ),
                            ),
                          );
                        }).toList() ??
                        [],
                    rows: provider.completeData?.peerComparison?.peerComparison
                            ?.map((company) {
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
              fontSize: 12,
              color: text >= 0 ? ThemeColors.accent : ThemeColors.sos),
        ),
      ),
    );
  }
}

// class Company {
//   String? image;
//   String? companyName;
//   CompanyDetails companyDetails;

//   Company(
//       {required this.image,
//       required this.companyName,
//       required this.companyDetails});
// }

// class CompanyDetails {
//   String? peRatio;
//   String? returns;
//   String? salesGrowth;
//   String? profitGrowth;
//   String? roe;

//   CompanyDetails(
//       {required this.peRatio,
//       required this.returns,
//       required this.salesGrowth,
//       required this.profitGrowth,
//       required this.roe});
// }

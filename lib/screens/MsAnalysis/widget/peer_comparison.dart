import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import 'title_tag.dart';

class MsPeerComparison extends StatefulWidget {
  const MsPeerComparison({super.key});

  @override
  State<MsPeerComparison> createState() => _MsPeerComparisonState();
}

class _MsPeerComparisonState extends State<MsPeerComparison> {
  final List<Company>? companies = [
    Company(image: Images.amazon, companyName: 'Amazon', companyDetails: [
      CompanyDetails(
          peRatio: '20.0%',
          returns: '12.40%',
          salesGrowth: '8.90%',
          profitGrowth: '0.5%',
          roe: '0.2%')
    ]),
    Company(image: Images.netflix, companyName: 'Netflix', companyDetails: [
      CompanyDetails(
          peRatio: '20.0%',
          returns: '12.40%',
          salesGrowth: '8.90%',
          profitGrowth: '0.5%',
          roe: '0.2%')
    ]),
    Company(image: Images.microsoft, companyName: 'Microsoft', companyDetails: [
      CompanyDetails(
          peRatio: '20.0%',
          returns: '12.40%',
          salesGrowth: '8.90%',
          profitGrowth: '0.5%',
          roe: '0.2%')
    ]),
    Company(image: Images.telegram, companyName: 'Telegram', companyDetails: [
      CompanyDetails(
          peRatio: '20.0%',
          returns: '12.40%',
          salesGrowth: '8.90%',
          profitGrowth: '0.5%',
          roe: '0.2%')
    ]),
    Company(image: Images.twitter, companyName: 'Twitter', companyDetails: [
      CompanyDetails(
          peRatio: '20.0%',
          returns: '12.40%',
          salesGrowth: '8.90%',
          profitGrowth: '0.5%',
          roe: '0.2%')
    ]),
    Company(image: Images.spotify, companyName: 'Spotify', companyDetails: [
      CompanyDetails(
          peRatio: '20.0%',
          returns: '12.40%',
          salesGrowth: '8.90%',
          profitGrowth: '0.5%',
          roe: '0.2%')
    ]),
  ];

  List<String> headers = [
    'P/E Ratio',
    '3M returns',
    '3Yr sales growth',
    '3Yr profit growth',
    '3Yr ROE'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MsTitle(title: "Peer Comparison"),
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
                      style: stylePTSansRegular(fontSize: 12),
                    ),
                  ),
                ],
                rows: companies?.map((company) {
                      return DataRow(cells: [
                        DataCell(
                          SizedBox(
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
                                  child: Image.asset(
                                    company.image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SpacerHorizontal(width: 8.0),
                                Expanded(
                                  child: Text(
                                    company.companyName!,
                                    style: stylePTSansRegular(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]);
                    }).toList() ??
                    [],
              ),

              // Scrollable columns
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    horizontalMargin: 10,
                    border: TableBorder.all(
                      color: ThemeColors.greyBorder,
                      // borderRadius: BorderRadius.circular(10.0),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      width: 0.9,
                    ),
                    columns: headers.map((header) {
                      return DataColumn(
                        label: Text(
                          header,
                          style: stylePTSansRegular(fontSize: 12),
                        ),
                      );
                    }).toList(),
                    rows: companies?.map((company) {
                          return DataRow(cells: [
                            DataCell(
                              Text(
                                "${company.companyDetails[0].peRatio}",
                                style: stylePTSansRegular(fontSize: 12),
                              ),
                            ),
                            DataCell(
                              Text(
                                company.companyDetails[0].returns ?? "",
                                style: stylePTSansRegular(
                                    fontSize: 12, color: Colors.green),
                              ),
                            ),
                            DataCell(
                              Text(
                                company.companyDetails[0].salesGrowth ?? "",
                                style: stylePTSansRegular(
                                    fontSize: 12, color: Colors.green),
                              ),
                            ),
                            DataCell(
                              Text(
                                company.companyDetails[0].profitGrowth ?? "",
                                style: stylePTSansRegular(
                                    fontSize: 12, color: Colors.green),
                              ),
                            ),
                            DataCell(
                              Text(
                                company.companyDetails[0].roe ?? "",
                                style: stylePTSansRegular(
                                    fontSize: 12, color: Colors.green),
                              ),
                            ),
                          ]);
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
}

class Company {
  String? image;
  String? companyName;
  List<CompanyDetails> companyDetails;

  Company(
      {required this.image,
      required this.companyName,
      required this.companyDetails});
}

class CompanyDetails {
  String? peRatio;
  String? returns;
  String? salesGrowth;
  String? profitGrowth;
  String? roe;

  CompanyDetails(
      {required this.peRatio,
      required this.returns,
      required this.salesGrowth,
      required this.profitGrowth,
      required this.roe});
}

// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// class PeerComparison extends StatefulWidget {
//   const PeerComparison({super.key});

//   @override
//   State<PeerComparison> createState() => _PeerComparisonState();
// }

// class _PeerComparisonState extends State<PeerComparison> {
//   final List<Company> companies = [
//     Company(image: Images.amazon, companyName: 'Amazon', comapanyDetails: [
//       Companydetails(
//           peRatio: '20.0%',
//           returns: '12.40%',
//           salesGrowth: '8.90%',
//           profitGrowth: '0.5%',
//           roe: '0.2%')
//     ]),
//     Company(image: Images.netflix, companyName: 'Netflix', comapanyDetails: [
//       Companydetails(
//           peRatio: '20.0%',
//           returns: '12.40%',
//           salesGrowth: '8.90%',
//           profitGrowth: '0.5%',
//           roe: '0.2%')
//     ]),
//     Company(
//         image: Images.microsoft,
//         companyName: 'Microsoft',
//         comapanyDetails: [
//           Companydetails(
//               peRatio: '20.0%',
//               returns: '12.40%',
//               salesGrowth: '8.90%',
//               profitGrowth: '0.5%',
//               roe: '0.2%')
//         ]),
//     Company(image: Images.telegram, companyName: 'Telegram', comapanyDetails: [
//       Companydetails(
//           peRatio: '20.0%',
//           returns: '12.40%',
//           salesGrowth: '8.90%',
//           profitGrowth: '0.5%',
//           roe: '0.2%')
//     ]),
//     Company(image: Images.twitter, companyName: 'Twitter', comapanyDetails: [
//       Companydetails(
//           peRatio: '20.0%',
//           returns: '12.40%',
//           salesGrowth: '8.90%',
//           profitGrowth: '0.5%',
//           roe: '0.2%')
//     ]),
//     Company(image: Images.spotify, companyName: 'Spotify', comapanyDetails: [
//       Companydetails(
//           peRatio: '20.0%',
//           returns: '12.40%',
//           salesGrowth: '8.90%',
//           profitGrowth: '0.5%',
//           roe: '0.2%')
//     ]),
//     Company(image: Images.spotify, companyName: 'Spotify', comapanyDetails: [
//       Companydetails(
//           peRatio: '20.0%',
//           returns: '12.40%',
//           salesGrowth: '8.90%',
//           profitGrowth: '0.5%',
//           roe: '0.2%')
//     ]),
//     Company(
//         image: Images.microsoft,
//         companyName: 'Microsoft',
//         comapanyDetails: [
//           Companydetails(
//               peRatio: '20.0%',
//               returns: '12.40%',
//               salesGrowth: '8.90%',
//               profitGrowth: '0.5%',
//               roe: '0.2%')
//         ]),
//   ];

//   List<String>? headers = [
//     // 'Company',
//     'P/E Ratio',
//     '3M returns',
//     '3Yr sales growth',
//     '3Yr profit growth',
//     '3Yr ROE'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Peer Comparison',
//             style: stylePTSansBold(fontSize: 16.0, color: Colors.white)),
//         SpacerVertical(
//           height: 10,
//         ),
//         Row(
//           children: [
//             Container(
//               // height: MediaQuery.of(context).size.height * 0.45,
//               decoration: BoxDecoration(
//                   color: ThemeColors.tableBorderColor,
//                   borderRadius: BorderRadius.circular(10.0)),
//               child: DataTable(
//                 // ignore: deprecated_member_use
//                 // dataRowHeight: 53,
//                 // headingRowHeight: 55,
//                 horizontalMargin: 10,
//                 border: TableBorder.all(
//                     color: ThemeColors.greyBorder,
//                     borderRadius: BorderRadius.circular(10.0),
//                     width: 0.9),
//                 columns: [
//                   DataColumn(
//                     label: Text(
//                       // headers![0],
//                       'Company',
//                       style: stylePTSansRegular(fontSize: 12),
//                     ),
//                   ),
//                 ],
//                 rows: companies.map((data) {
//                   return DataRow(
//                     cells: [
//                       DataCell(
//                         SizedBox(
//                           width: 100,
//                           child: Row(
//                             children: [
//                               Container(
//                                 height: 30,
//                                 width: 30,
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     shape: BoxShape.circle),
//                                 // padding: EdgeInsets.all(10.0),
//                                 child: Image.asset(data.image.toString()),
//                               ),
//                               SpacerHorizontal(
//                                 width: 8.0,
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   data.companyName.toString(),
//                                   style: stylePTSansRegular(fontSize: 12),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: const Color.fromARGB(255, 27, 27, 27),
//                       borderRadius: BorderRadius.circular(10.0)),
//                   child: DataTable(
//                     // dataRowHeight: 46,
//                     // horizontalMargin: 10,
//                     border: TableBorder.all(
//                         color: ThemeColors.greyBorder,
//                         borderRadius: BorderRadius.circular(10.0),
//                         width: 0.9),
//                     columnSpacing: 15,
//                     columns: headers!.skip(1).map((header) {
//                       return DataColumn(
//                           label: Text(
//                         header,
//                         style: stylePTSansRegular(fontSize: 12),
//                       ));
//                     }).toList(),
//                     rows: companies.map((company) {
//                       return DataRow(cells: [
//                         DataCell(
//                           Text(
//                             "${company.comapanyDetails?[0].peRatio}",
//                             style: stylePTSansRegular(fontSize: 12),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             company.comapanyDetails?[0].returns,
//                             style: stylePTSansRegular(
//                                 fontSize: 12, color: Colors.green),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             company.comapanyDetails?[0].salesGrowth,
//                             style: stylePTSansRegular(
//                                 fontSize: 12, color: Colors.green),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             company.comapanyDetails?[0].profitGrowth,
//                             style: stylePTSansRegular(
//                                 fontSize: 12, color: Colors.green),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             company.comapanyDetails?[0].roe,
//                             style: stylePTSansRegular(
//                                 fontSize: 12, color: Colors.green),
//                           ),
//                         ),
//                       ]);
//                     }).toList(),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ],
//     );
//   }
// }

// class Company {
//   String? image;
//   String? companyName;
//   List? comapanyDetails;

//   Company(
//       {required this.image,
//       required this.companyName,
//       required this.comapanyDetails});
// }

// class Companydetails {
//   String? peRatio;
//   String? returns;
//   String? salesGrowth;
//   String? profitGrowth;
//   String? roe;

//   Companydetails(
//       {required this.peRatio,
//       required this.returns,
//       required this.salesGrowth,
//       required this.profitGrowth,
//       required this.roe});
// }

import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class PeerComparison extends StatefulWidget {
  const PeerComparison({super.key});

  @override
  State<PeerComparison> createState() => _PeerComparisonState();
}

class _PeerComparisonState extends State<PeerComparison> {
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
    'Company',
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
        Text('Peer Comparison',
            style: stylePTSansBold(fontSize: 16.0, color: Colors.white)),
        SpacerVertical(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 27, 27, 27),
                borderRadius: BorderRadius.circular(10.0)),
            child: DataTable(
              horizontalMargin: 10,
              border: TableBorder.all(
                  color: ThemeColors.greyBorder,
                  borderRadius: BorderRadius.circular(10.0),
                  width: 0.9),
              columns: headers.map((header) {
                return DataColumn(
                    label: Text(
                  header,
                  style: stylePTSansRegular(fontSize: 12),
                ));
              }).toList(),
              rows: companies?.map((company) {
                    return DataRow(cells: [
                      DataCell(
                        SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                child: Image.asset(company.image!),
                              ),
                              SpacerHorizontal(
                                width: 8.0,
                              ),
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

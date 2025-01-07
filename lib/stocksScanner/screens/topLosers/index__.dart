// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
// import 'package:stocks_news_new/stocksScanner/providers/top_loser_scanner_provider.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/constants.dart';

// class ScannerTopLosers extends StatefulWidget {
//   const ScannerTopLosers({super.key});

//   @override
//   State<ScannerTopLosers> createState() => _ScannerTopLosersState();
// }

// class _ScannerTopLosersState extends State<ScannerTopLosers> {
//   List<String> columnHeader = [
//     "Time",
//     // "Symbol",
//     "Company Name",
//     "Sector",
//     "Bid",
//     "Ask",
//     "Last Trade",
//     "Net Change",
//     "% Change",
//     "Volume",
//     "\$ Volume"
//   ];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       TopLoserScannerProvider provider =
//           context.read<TopLoserScannerProvider>();
//       provider.startListeningPost();
//       provider.getOfflineData();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     TopLoserScannerProvider provider = context.watch<TopLoserScannerProvider>();
//     List<ScannerRes>? dataList = provider.dataList;

//     if (dataList == null) {
//       return SizedBox();
//     }

//     return SingleChildScrollView(
//       child: ClipRRect(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(8),
//           bottomLeft: Radius.circular(8),
//         ),
//         child: Row(
//           children: [
//             // Fixed column
//             DataTable(
//               horizontalMargin: 10,
//               dataRowColor: WidgetStatePropertyAll(
//                 ThemeColors.greyText.withValues(alpha: .4),
//               ),
//               headingRowColor: WidgetStatePropertyAll(
//                 ThemeColors.greyText.withValues(alpha: .4),
//               ),
//               border: TableBorder.all(
//                 color: ThemeColors.greyBorder,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(10),
//                   bottomLeft: Radius.circular(10),
//                 ),
//                 width: 0.9,
//               ),
//               columns: [
//                 DataColumn(
//                   label: ConstrainedBox(
//                     constraints: BoxConstraints(
//                       maxWidth: ScreenUtil().screenWidth * .3,
//                     ),
//                     child: Text(
//                       'Symbol',
//                       style: styleGeorgiaBold(
//                         fontSize: 12,
//                         color: ThemeColors.greyText,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//               rows: dataList.map((data) {
//                 return DataRow(
//                   cells: [
//                     DataCell(
//                       GestureDetector(
//                         child: Container(
//                           padding: EdgeInsets.symmetric(horizontal: 10),
//                           constraints: BoxConstraints(
//                             maxWidth: ScreenUtil().screenWidth * .3,
//                           ),
//                           // width: 100,
//                           child: Row(
//                             children: [
//                               // Container(
//                               //   height: 30,
//                               //   width: 30,
//                               //   decoration: BoxDecoration(
//                               //     // color: Colors.white,
//                               //     shape: BoxShape.circle,
//                               //   ),
//                               //   child: CachedNetworkImagesWidget(
//                               //     "",
//                               //     // company.image ?? "",
//                               //     fit: BoxFit.cover,
//                               //   ),
//                               // ),
//                               // SpacerHorizontal(width: 8.0),
//                               Expanded(
//                                 child: Text(
//                                   data.identifier,
//                                   // company.symbol ?? "",
//                                   style: styleGeorgiaBold(fontSize: 12),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }).toList(),
//             ),
//             // Scrollable columns
//             Expanded(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                   horizontalMargin: 10,
//                   // border: TableBorder.all(
//                   //   color: ThemeColors.greyBorder,
//                   //   // borderRadius: BorderRadius.circular(10.0),
//                   //   borderRadius: BorderRadius.only(
//                   //     topRight: Radius.circular(10),
//                   //     bottomRight: Radius.circular(10),
//                   //   ),
//                   //   width: 0.9,
//                   // ),
//                   border: TableBorder(
//                     top: BorderSide(
//                       color: ThemeColors.greyBorder,
//                       width: 0.5,
//                     ),
//                     bottom: BorderSide(
//                       color: ThemeColors.greyBorder,
//                       width: 0.5,
//                     ),
//                     horizontalInside: BorderSide(
//                       color: ThemeColors.greyBorder,
//                       width: 0.5,
//                     ),
//                   ),
//                   columns: columnHeader.map((header) {
//                     return DataColumn(
//                       label: Text(
//                         header,
//                         style: styleGeorgiaBold(
//                           fontSize: 12,
//                           color: ThemeColors.greyText,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                   rows: dataList.map(
//                     (data) {
//                       return DataRow(
//                         cells: [
//                           _dataCell(text: data.time), // "Time",
//                           // _dataCell(text: data.identifier), // "Symbol",
//                           _dataCell(text: data.name), // "Company Name",
//                           _dataCell(text: data.sector), // "Sector",
//                           _dataCell(text: "\$${data.bid}"), // "Bid",
//                           _dataCell(text: "\$${data.ask}"), // "Ask",
//                           _dataCell(text: "\$${data.price}"), // "Last Trade",
//                           _dataCell(
//                             text: "\$${data.change}",
//                             change: true,
//                             value: data.change,
//                           ), // "Net Change",
//                           _dataCell(
//                             text: "${data.changesPercentage}", // "% Change",
//                             change: true,
//                             value: data.changesPercentage,
//                           ),
//                           _dataCell(text: "${data.volume}"), // "Volume",
//                           _dataCell(
//                             text: num.parse("${data.volume * data.price}")
//                                 .toRuppees(), // "$Volume"
//                           ),
//                         ],
//                       );
//                     },
//                   ).toList(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   DataCell _dataCell({
//     required String text,
//     bool change = false,
//     num? value,
//   }) {
//     return DataCell(
//       ConstrainedBox(
//         constraints: BoxConstraints(
//           maxWidth: ScreenUtil().screenWidth * .3,
//         ),
//         child: Text(
//           // userPercent ? "$text%" : "$text",
//           text,
//           style: styleGeorgiaBold(
//             fontSize: 12,
//             // color: Colors.white,
//             color: value != null
//                 ? (value >= 0 ? ThemeColors.accent : ThemeColors.sos)
//                 : Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }

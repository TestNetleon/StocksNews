// import 'package:flutter/material.dart';
// // import 'package:stocks_news_new/screens/prediction/Widget/linechart.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

// class MsTechnicalAnalysis extends StatefulWidget {
//   const MsTechnicalAnalysis({super.key});

//   @override
//   State<MsTechnicalAnalysis> createState() => _MsTechnicalAnalysisState();
// }

// class _MsTechnicalAnalysisState extends State<MsTechnicalAnalysis>
//     with SingleTickerProviderStateMixin {
//   late TabController controller;

//   @override
//   void initState() {
//     super.initState();

//     controller = TabController(vsync: this, length: 2);
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   // ignore: non_constant_identifier_names
//   List<Map<String, dynamic>> Technical = [
//     {
//       "title": "Moving Averages (MA)",
//       "amount": "50.91M",
//     },
//     {
//       "title": "Relative Strength Index (RSI)",
//       "amount": "40.61M",
//     },
//     {"title": "Bollinger Bands", "amount": "20.16M"},
//     {
//       "title": "MACD (Moving Average Convergence Divergence)",
//       "amount": "80.12M"
//     },
//   ];

//   List colors = [Colors.green, Colors.red, Colors.red, Colors.green];

//   List<bool> isSelectedList = List.generate(4, (_) => false);
//   int selectedIndex = -1;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Technical Analysis Metrics',
//             style: stylePTSansBold(fontSize: 18)),
//         const SizedBox(
//           height: 8.0,
//         ),
//         ListView.builder(
//           itemCount: Technical.length,
//           scrollDirection: Axis.vertical,
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemBuilder: (BuildContext context, int index) {
//             // var theme = Theme.of(context);
//             return GestureDetector(
//               onTap: () {
//                 setState(() {
//                   isSelectedList[index] = !isSelectedList[index];
//                 });
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10.0),
//                   color: Colors.white,
//                 ),
//                 padding: const EdgeInsets.all(10.0),
//                 margin: const EdgeInsets.only(bottom: 8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                   Technical[index]['title']
//                                       .toString(), // Display the overall value here
//                                   style: stylePTSansBold(color: Colors.black)),
//                               const SizedBox(
//                                 height: 10,
//                               ),
//                               Text(
//                                   'Total Contract value of bookings on a quartely basis', // Display the overall value here
//                                   style: stylePTSansRegular(
//                                       fontSize: 12, color: Colors.black)),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 20,
//                         ),
//                         Image.asset(
//                           Images.download,
//                           height: 20,
//                         ),
//                         const SizedBox(
//                           width: 8,
//                         ),
//                         Image.asset(
//                           Images.edit,
//                           height: 20,
//                         ),
//                         const SizedBox(
//                           width: 8,
//                         ),
//                         const Icon(
//                           Icons.arrow_outward,
//                           color: Colors.black,
//                         )
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 30.0,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                                 'Total Revenue of 2024', // Display the overall value here
//                                 style: stylePTSansBold(
//                                     fontSize: 14, color: colors[index])),
//                             Row(
//                               children: [
//                                 Text(
//                                     Technical[index]['amount']
//                                         .toString(), // Display the overall value here
//                                     style: stylePTSansBold(
//                                         color: colors[index], fontSize: 30)),
//                                 Icon(
//                                   colors[index] == "red"
//                                       ? Icons.arrow_downward
//                                       : Icons.arrow_upward,
//                                   color: colors[index],
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                         const SpacerHorizontal(width: 20),
//                         Expanded(
//                           child: SizedBox(
//                             height: 50,
//                             child: Image.asset(
//                               Images.graphBG3,
//                               fit: BoxFit.cover,
//                               color: Colors.green,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 10.0,
//                     ),
//                     Visibility(
//                       visible: isSelectedList[index],
//                       child: Column(
//                         children: [
//                           DefaultTabController(
//                             length: 2,
//                             initialIndex: 1,
//                             child: TabBar(
//                               dividerColor: Colors.transparent,
//                               indicator: BoxDecoration(
//                                   color: const Color.fromARGB(255, 6, 185, 6),
//                                   borderRadius: BorderRadius.circular(10)),
//                               labelStyle: const TextStyle(color: Colors.white),
//                               unselectedLabelColor: Colors.grey,
//                               controller: controller,
//                               indicatorWeight: 0,
//                               indicatorSize: TabBarIndicatorSize.tab,
//                               labelPadding: EdgeInsets.all(0),
//                               tabs: const [
//                                 Tab(
//                                   text: 'Summary',
//                                 ),
//                                 Tab(
//                                   text: 'Details',
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 300.0,
//                             child: TabBarView(
//                               controller: controller,
//                               children: <Widget>[
//                                 Container(
//                                   decoration: const BoxDecoration(
//                                     color: Colors.white,
//                                   ),
//                                   // padding: const EdgeInsets.all(10.0),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       //graph
//                                       // const SizedBox(
//                                       //   height: 180,
//                                       //   child: LineChartSample2(),
//                                       // ),

//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 6.0, right: 8.0),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                                 'open', // Display the overall value here
//                                                 style: stylePTSansBold(
//                                                   color: const Color.fromARGB(
//                                                       255, 102, 105, 102),
//                                                 )),
//                                             Text(
//                                                 'High', // Display the overall value here
//                                                 style: stylePTSansBold(
//                                                   color: const Color.fromARGB(
//                                                       255, 102, 105, 102),
//                                                 )),
//                                             Text(
//                                                 'Low', // Display the overall value here
//                                                 style: stylePTSansBold(
//                                                   color: const Color.fromARGB(
//                                                       255, 102, 105, 102),
//                                                 )),
//                                           ],
//                                         ),
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                               '224.06', // Display the overall value here
//                                               style: stylePTSansBold(
//                                                   color: Colors.green)),
//                                           Text(
//                                               '105.41', // Display the overall value here
//                                               style: stylePTSansBold(
//                                                   color: Colors.red)),
//                                           Text(
//                                               '96.0374', // Display the overall value here
//                                               style: stylePTSansBold(
//                                                   color: Colors.red)),
//                                         ],
//                                       ),
//                                       const SizedBox(
//                                         height: 10.0,
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                               'Volume', // Display the overall value here
//                                               style: stylePTSansBold(
//                                                 color: const Color.fromARGB(
//                                                     255, 102, 105, 102),
//                                               )),
//                                           Text(
//                                               'Avg. Volume', // Display the overall value here
//                                               style: stylePTSansBold(
//                                                 color: const Color.fromARGB(
//                                                     255, 102, 105, 102),
//                                               )),
//                                           Text(
//                                               'Market Cap', // Display the overall value here
//                                               style: stylePTSansBold(
//                                                 color: const Color.fromARGB(
//                                                     255, 102, 105, 102),
//                                               )),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                               '63,6334', // Display the overall value here
//                                               style: stylePTSansBold(
//                                                   color: Colors.green)),
//                                           Text(
//                                               '78,323', // Display the overall value here
//                                               style: stylePTSansBold(
//                                                   color: Colors.red)),
//                                           Text(
//                                               '13,7435', // Display the overall value here
//                                               style: stylePTSansBold(
//                                                   color: Colors.red)),
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   decoration: const BoxDecoration(
//                                     color: Colors.white,
//                                   ),
//                                   // padding: const EdgeInsets.all(10.0),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       //graph
//                                       // const SizedBox(
//                                       //   height: 180,
//                                       //   child: LineChartSample2(),
//                                       // ),

//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 6.0, right: 8.0),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                                 'open', // Display the overall value here
//                                                 style: stylePTSansBold(
//                                                   color: const Color.fromARGB(
//                                                       255, 102, 105, 102),
//                                                 )),
//                                             Text(
//                                                 'High', // Display the overall value here
//                                                 style: stylePTSansBold(
//                                                   color: const Color.fromARGB(
//                                                       255, 102, 105, 102),
//                                                 )),
//                                             Text(
//                                                 'Low', // Display the overall value here
//                                                 style: stylePTSansBold(
//                                                   color: const Color.fromARGB(
//                                                       255, 102, 105, 102),
//                                                 )),
//                                           ],
//                                         ),
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                               '224.06', // Display the overall value here
//                                               style: stylePTSansBold(
//                                                   color: Colors.green)),
//                                           Text(
//                                               '105.41', // Display the overall value here
//                                               style: stylePTSansBold(
//                                                   color: Colors.red)),
//                                           Text(
//                                               '96.0374', // Display the overall value here
//                                               style: stylePTSansBold(
//                                                   color: Colors.red)),
//                                         ],
//                                       ),
//                                       const SizedBox(
//                                         height: 10.0,
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                               'Volume', // Display the overall value here
//                                               style: stylePTSansBold(
//                                                 color: const Color.fromARGB(
//                                                     255, 102, 105, 102),
//                                               )),
//                                           Text(
//                                               'Avg. Volume', // Display the overall value here
//                                               style: stylePTSansBold(
//                                                 color: const Color.fromARGB(
//                                                     255, 102, 105, 102),
//                                               )),
//                                           Text(
//                                               'Market Cap', // Display the overall value here
//                                               style: stylePTSansBold(
//                                                 color: const Color.fromARGB(
//                                                     255, 102, 105, 102),
//                                               )),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                               '63,6334', // Display the overall value here
//                                               style: stylePTSansBold(
//                                                   color: Colors.green)),
//                                           Text(
//                                               '78,323', // Display the overall value here
//                                               style: stylePTSansBold(
//                                                   color: Colors.red)),
//                                           Text(
//                                               '13,7435', // Display the overall value here
//                                               style: stylePTSansBold(
//                                                   color: Colors.red)),
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/screens/MsAnalysis/technicalAnalysis/item.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../widget/title_tag.dart';

class MsTechnicalAnalysis extends StatelessWidget {
  const MsTechnicalAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MsTitle(title: "Technical Analysis Metrics"),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            TechAnalysisMetricsRes? metrics = provider.metrics?[index];
            return MsTechnicalAnalysisItem(
              metrics: metrics,
            );
          },
          separatorBuilder: (context, index) {
            return SpacerVertical(height: 12);
          },
          itemCount: 4,
        ),
      ],
    );
  }
}

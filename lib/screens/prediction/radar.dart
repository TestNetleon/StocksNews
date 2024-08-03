// import 'package:flutter/material.dart';
// import 'package:multi_charts/multi_charts.dart';
// import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
// import 'package:stocks_news_new/screens/prediction/Widget/faq.dart';
// import 'package:stocks_news_new/screens/prediction/Widget/forecast_chart.dart';
// import 'package:stocks_news_new/screens/prediction/Widget/fundamental.dart';
// import 'package:stocks_news_new/screens/prediction/Widget/header.dart';
// import 'package:stocks_news_new/screens/prediction/Widget/stocks_list.dart';
// import 'package:stocks_news_new/screens/prediction/Widget/technical.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';

// // ignore: camel_case_types
// class radar extends StatefulWidget {
//   const radar({super.key});

//   @override
//   State<radar> createState() => _radarState();
// }

// class _radarState extends State<radar> {
//   List<String> Qualitative = [
//     "Qualitative0",
//     "Economic Indicators",
//     "Industry Trends"
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return BaseContainer(
//       drawer: const BaseDrawer(resetIndex: true),
//       appBar: const AppBarHome(isPopback: true),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(14.0),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 const PreditionHeader(),
//                 SizedBox(
//                   width: 450,
//                   height: 320,
//                   //Radar Chart
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                         left: 10.0, right: 10.0, top: 20.0),
//                     child: RadarChart(
//                       labelColor: Colors.white,
//                       fillColor: Colors.greenAccent,
//                       curve: Curves.linear,
//                       animate: true,
//                       textScaleFactor: 0.03,
//                       strokeColor: Colors.white,
//                       values: const [40, 35, 54, 27, 12],
//                       labels: const [
//                         "Price-to-Earnings Ratio (P/E Ratio)",
//                         "Price-to-Earnings Growth Ratio (PEG Ratio)"
//                             "Price-to-Book Ratio (P/B Ratio)",
//                         "Dividend Yield",
//                         "Return on Equity (ROE)",
//                         "Debt-to-Equity Ratio",
//                       ],
//                       maxValue: 54,
//                       chartRadiusFactor: 0.6,
//                     ),
//                   ),
//                 ),
//                 const StocksList(),
//                 const SizedBox(
//                   height: 20.0,
//                 ),
//                 const FundamentalAnalaysis(),
//                 const SizedBox(
//                   height: 10.0,
//                 ),
//                 const TechnicalAnalaysis(),
//                 const ForcastingChart(),
//                 const SizedBox(
//                   height: 10.0,
//                 ),
//                 const Faq(),
//                 const SizedBox(
//                   height: 10.0,
//                 ),
//               ]),
//         ),
//       ),
//     );
//   }
// }

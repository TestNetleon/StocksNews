// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/stock_details_res.dart';
// import 'package:stocks_news_new/providers/stock_detail_new.dart';
// import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';
// import 'Widget/fundamental.dart';
// import 'Widget/technical.dart';

// class RadarIndex extends StatefulWidget {
//   const RadarIndex({super.key});

//   @override
//   State<RadarIndex> createState() => _RadarIndexState();
// }

// class _RadarIndexState extends State<RadarIndex> {
//   List<String> Qualitative = [
//     "Qualitative0",
//     "Economic Indicators",
//     "Industry Trends"
//   ];

//   @override
//   Widget build(BuildContext context) {
//     StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
//     KeyStats? keyStats = provider.tabRes?.keyStats;

//     return BaseContainer(
//       drawer: const BaseDrawer(resetIndex: true),
//       appBar: AppBarHome(
//         isPopback: true,
//         showTrailing: false,
//         canSearch: false,
//         title: keyStats?.name ?? "N/A",
//         subTitle: "",
//         // widget: keyStats == null ? null : const PredictionAppBar(),
//       ),
//       body: const SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(14.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               // SdTopWidgetDetail(),
//               // SizedBox(
//               //   width: 450,
//               //   height: 320,
//               //   //Radar Chart
//               //   child: Padding(
//               //     padding: const EdgeInsets.only(
//               //         left: 10.0, right: 10.0, top: 20.0),
//               //     child: RadarChart(
//               //       labelColor: Colors.white,
//               //       fillColor: Colors.greenAccent,
//               //       curve: Curves.linear,
//               //       animate: true,
//               //       textScaleFactor: 0.03,
//               //       strokeColor: Colors.white,
//               //       values: const [40, 40, 40, 40, 40],
//               //       labels: const [
//               //         "Price-to-Earnings Ratio (P/E Ratio)",
//               //         "Price-to-Earnings Growth Ratio (PEG Ratio)"
//               //             "Price-to-Book Ratio (P/B Ratio)",
//               //         "Dividend Yield",
//               //         "Return on Equity (ROE)",
//               //         "Debt-to-Equity Ratio",
//               //       ],
//               //       maxValue: 54,
//               //       chartRadiusFactor: 0.6,
//               //     ),
//               //   ),
//               // ),
//               // PredictionRadarGraph(),
//               // PredictionOtherStocks(),
//               // Padding(
//               //   padding: EdgeInsets.only(top: Dimen.padding),
//               //   child: PredictionOurTake(),
//               // ),
//               Padding(
//                 padding: EdgeInsets.only(top: Dimen.padding),
//                 child: FundamentalAnalysis(),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: Dimen.padding),
//                 child: TechnicalAnalysis(),
//               ),
//               // ForecastingChart(),
//               // SizedBox(
//               //   height: 300,
//               //   child: PredictionForecastChart(),
//               // ),
//               // Padding(
//               //   padding: EdgeInsets.only(top: Dimen.padding),
//               //   child: Faq(),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';

// class RadarChart extends StatefulWidget {
//   const RadarChart({super.key});

//   @override
//   State<RadarChart> createState() => _RadarChartState();
// }

// class _RadarChartState extends State<RadarChart> {
//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       children: [
//         SizedBox(
//           width: 450,
//           height: 300,
//           //Radar Chart
//           child: Padding(
//             padding: EdgeInsets.only(left: 10.0, right: 10.0),
//             child: RadarChart(
//               labelColor: Colors.white,
//               fillColor: Colors.greenAccent,
//               curve: Curves.linear,
//               animate: true,
//               textScaleFactor: 0.03,
//               strokeColor: Colors.white,
//               values: [40, 35, 54, 27, 12],
//               labels: [
//                 "Price-to-Earnings Ratio (P/E Ratio)",
//                 "Price-to-Earnings Growth Ratio (PEG Ratio)"
//                     "Price-to-Book Ratio (P/B Ratio)",
//                 "Dividend Yield",
//                 "Return on Equity (ROE)",
//                 "Debt-to-Equity Ratio",
//               ],
//               maxValue: 54,
//               chartRadiusFactor: 0.7,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

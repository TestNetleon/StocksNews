// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart' as fl;
// import '../../../utils/colors.dart';
// import '../../../utils/theme.dart';

// class PredictionRadarGraph extends StatefulWidget {
//   const PredictionRadarGraph({super.key});

//   @override
//   State<PredictionRadarGraph> createState() => _PredictionRadarGraphState();
// }

// class _PredictionRadarGraphState extends State<PredictionRadarGraph> {
//   List<String> radarNames = [
//     'VALUE',
//     'FUTURE',
//     'PAST',
//     'HEALTH',
//     'DIVIDEND',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 400,
//           child: fl.RadarChart(
//             fl.RadarChartData(
//               radarTouchData: fl.RadarTouchData(enabled: false),
//               titlePositionPercentageOffset: 0.05,
//               getTitle: (index, angle) {
//                 final labelAngle = angle - (90 * (3.1415926535897932 / 180));
//                 return fl.RadarChartTitle(
//                   text: radarNames[index],
//                   angle: labelAngle + 2,
//                 );
//               },
//               titleTextStyle: styleSansBold(color: ThemeColors.white),
//               dataSets: [
//                 fl.RadarDataSet(
//                   fillColor: Colors.orange.withOpacity(0.8),
//                   borderColor: Colors.orange,
//                   borderWidth: 3,
//                   entryRadius: 0,
//                   // dataEntries: List.generate(
//                   //   radarNames.length,
//                   //   (index) {
//                   //     return fl.RadarEntry(value: index.toDouble());
//                   //   },
//                   // ),
//                   dataEntries: [
//                     fl.RadarEntry(value: 0.9),
//                     fl.RadarEntry(value: 0.7),
//                     fl.RadarEntry(value: 0.4),
//                     fl.RadarEntry(value: 0.8),
//                     fl.RadarEntry(value: 0.7),
//                   ],
//                 ),
//               ],
//               radarBackgroundColor: Colors.transparent,
//               borderData: fl.FlBorderData(show: false),
//               radarBorderData: const BorderSide(
//                 color: ThemeColors.greyBorder,
//               ),
//               tickCount: 2,
//               tickBorderData: BorderSide(
//                 color: ThemeColors.greyBorder.withOpacity(0.5),
//                 width: 30,
//                 style: BorderStyle.solid,
//               ),
//               ticksTextStyle: const TextStyle(color: Colors.transparent),
//               gridBorderData: BorderSide(
//                 color: ThemeColors.greyBorder.withOpacity(0.5),
//                 width: 2,
//               ),
//             ),
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(8),
//                     bottomLeft: Radius.circular(8)),
//                 gradient: const LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   stops: [0.0, 0.3],
//                   colors: [
//                     Color.fromARGB(255, 154, 154, 154),
//                     Color.fromARGB(255, 69, 69, 69),
//                   ],
//                 ),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Our',
//                     style: stylePTSansRegular(
//                       fontSize: 25,
//                     ),
//                   ),
//                   Text(
//                     'Verdict',
//                     style: stylePTSansBold(fontSize: 30),
//                   ),
//                 ],
//               ),
//             ),
//             Flexible(
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8.0),
//                   gradient: const LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     stops: [0.0, 0.3],
//                     colors: [Color.fromARGB(255, 32, 240, 139), Colors.green],
//                   ),
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Overall',
//                       style: stylePTSansRegular(
//                         fontSize: 25,
//                       ),
//                     ),
//                     Text(
//                       'Wait',
//                       style: stylePTSansBold(fontSize: 30),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

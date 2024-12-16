import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';

import '../../modals/home_alert_res.dart';
import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../../widgets/spacer_horizontal.dart';
import '../../widgets/spacer_vertical.dart';
import '../../widgets/theme_image_view.dart';
import '../stockDetail/index.dart';

class AllFeaturedItem extends StatelessWidget {
  final HomeAlertsRes data;
  const AllFeaturedItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => StockDetail(symbol: data.symbol)),
        );
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(0.sp),
            child: Container(
              padding: const EdgeInsets.all(5),
              width: 43,
              height: 43,
              child: ThemeImageView(url: data.image),
            ),
          ),
          const SpacerHorizontal(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.symbol,
                  style: styleGeorgiaBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVertical(height: 5),
                Text(
                  data.name,
                  style: styleGeorgiaRegular(
                    color: ThemeColors.greyText,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(right: 8.sp, left: 8.sp),
          //   width: 80.sp,
          //   height: 26.sp,
          //   child: LineChart(_avgData()),
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(data.price, style: stylePTSansBold(fontSize: 15)),
              const SpacerVertical(height: 2),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "${data.change} (${data.changesPercentage.toCurrency()}%)",
                      style: stylePTSansRegular(
                        fontSize: 11,
                        color: data.changesPercentage > 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // LineChartData _avgData() {
  //   List<Chart> reversedData = data.chart.reversed.toList();

  //   List<FlSpot> spots = [];

  //   for (int i = 0; i < reversedData.length; i++) {
  //     spots.add(FlSpot(i.toDouble(), reversedData[i].close));
  //   }

  //   return LineChartData(
  //     // lineTouchData: LineTouchData(
  //     //   getTouchLineEnd: (barData, spotIndex) {
  //     //     return double.infinity;
  //     //   },
  //     //   getTouchLineStart: (barData, spotIndex) {
  //     //     return 0.0;
  //     //   },
  //     //   getTouchedSpotIndicator: (barData, spotIndexes) {
  //     //     return spotIndexes.map((spotIndex) {
  //     //       return TouchedSpotIndicatorData(
  //     //         FlLine(
  //     //           color: Colors.grey[400],
  //     //           strokeWidth: 1,
  //     //           dashArray: [5, 5],
  //     //         ),
  //     //         FlDotData(
  //     //           show: true,
  //     //           checkToShowDot: (spot, barData) {
  //     //             return true;
  //     //           },
  //     //         ),
  //     //       );
  //     //     }).toList();
  //     //   },
  //     //   enabled: true,
  //     //   touchTooltipData: LineTouchTooltipData(
  //     //     tooltipHorizontalOffset: 10,
  //     //     tooltipRoundedRadius: 10.0,
  //     //     showOnTopOfTheChartBoxArea: true,
  //     //     fitInsideHorizontally: true,
  //     //     fitInsideVertically: true,
  //     //     maxContentWidth: 300,
  //     //     tooltipPadding:
  //     //         EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
  //     //     tooltipMargin: 1,
  //     //     getTooltipItems: (touchedSpots) {
  //     //       return touchedSpots.map(
  //     //         (LineBarSpot touchedSpot) {
  //     //           return LineTooltipItem(
  //     //             '\$${touchedSpot.y.toStringAsFixed(2)} | ${DateFormat('dd MMM').format(reversedData[touchedSpot.x.toInt()].date)}, ${DateFormat('h:mm a').format(reversedData[touchedSpot.x.toInt()].date)}',
  //     //             stylePTSansBold(color: ThemeColors.white, fontSize: 10),
  //     //           );
  //     //         },
  //     //       ).toList();
  //     //     },
  //     //     getTooltipColor: (touchedSpot) {
  //     //       return Colors.transparent;
  //     //     },
  //     //   ),
  //     // ),

  //     lineTouchData: const LineTouchData(enabled: false),
  //     gridData: FlGridData(
  //       show: false,
  //       drawHorizontalLine: false,
  //       getDrawingVerticalLine: (value) {
  //         return const FlLine(
  //           color: ThemeColors.transparent,
  //           strokeWidth: 1,
  //         );
  //       },
  //     ),
  //     borderData: FlBorderData(show: false),
  //     titlesData: const FlTitlesData(show: false),
  //     minX: 0,
  //     maxX: reversedData.length.toDouble() - 1,
  //     minY: reversedData
  //         .map((data) => data.close)
  //         .reduce((a, b) => a < b ? a : b)
  //         .toDouble(),
  //     maxY: reversedData
  //         .map((data) => data.close)
  //         .reduce((a, b) => a > b ? a : b)
  //         .toDouble(),
  //     lineBarsData: [
  //       LineChartBarData(
  //         show: true,
  //         spots: spots,
  //         color: data.previousClose > data.chart.first.close
  //             ? ThemeColors.sos
  //             : ThemeColors.accent,
  //         isCurved: true,
  //         barWidth: 1,
  //         isStrokeCapRound: false,
  //         dotData: const FlDotData(
  //           show: false, // hide dots
  //         ),
  //         // belowBarData: BarAreaData(
  //         //   show: true,
  //         //   gradient: LinearGradient(
  //         //     begin: Alignment.topCenter,
  //         //     end: Alignment.bottomCenter,
  //         //     colors: [
  //         //       data.previousClose > data.chart.first.close
  //         //           ? ThemeColors.sos.withOpacity(0.1)
  //         //           : ThemeColors.accent.withOpacity(0.1),
  //         //       ThemeColors.background,
  //         //     ],
  //         //   ),
  //         // ),
  //       ),
  //     ],
  //   );
  // }

  // Widget bigWidget() {
  //   return InkWell(
  //     onTap: () {
  //       Navigator.push(navigatorKey.currentContext!, StockDetails.path,
  //           arguments: data.symbol);
  //     },
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             ClipRRect(
  //               borderRadius: BorderRadius.circular(0.sp),
  //               child: Container(
  //                 padding: EdgeInsets.all(5.sp),
  //                 width: 43.sp,
  //                 height: 43.sp,
  //                 child: ThemeImageView(url: data.image),
  //               ),
  //             ),
  //             const SpacerHorizontal(width: 12),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     data.symbol,
  //                     style: styleGeorgiaBold(fontSize: 14),
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                   const SpacerVertical(height: 5),
  //                   Text(
  //                     data.name,
  //                     style: styleGeorgiaRegular(
  //                       color: ThemeColors.greyText,
  //                       fontSize: 12,
  //                     ),
  //                     maxLines: 2,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               children: [
  //                 Text(data.price, style: stylePTSansBold(fontSize: 14)),
  //                 const SpacerVertical(height: 2),
  //                 RichText(
  //                   text: TextSpan(
  //                     children: [
  //                       TextSpan(
  //                         text: data.change,
  //                         style: stylePTSansRegular(
  //                           fontSize: 12,
  //                           color: data.changesPercentage > 0
  //                               ? Colors.green
  //                               : Colors.red,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             )
  //           ],
  //         ),
  //         SizedBox(
  //           // width: 90.sp,
  //           height: 100.sp,
  //           child: LineChart(_avgData()),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

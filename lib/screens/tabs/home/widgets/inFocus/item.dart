import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/deepLinkScreen/webscreen.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../../modals/home_alert_res.dart';
import '../../../../../modals/stock_infocus.dart';
import '../../../../../providers/home_provider.dart';
import '../../../../../widgets/cache_network_image.dart';
import '../../../../../widgets/spacer_horizontal.dart';

class StocksInFocusItem extends StatelessWidget {
  const StocksInFocusItem({super.key});

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    StockInFocusRes? focusRes = provider.focusRes;
    return InkWell(
      borderRadius: BorderRadius.circular(10.sp),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebviewLink(
                stringURL: focusRes?.lpUrl,
              ),
            ));
      },
      child: Ink(
        width: double.infinity,
        decoration: BoxDecoration(
          // color: const Color.fromARGB(255, 48, 48, 48),
          // color: ThemeColors.greyBorder,
          borderRadius: BorderRadius.circular(10.sp),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 23, 23, 23),
              // ThemeColors.greyBorder,
              Color.fromARGB(255, 48, 48, 48),
            ],
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CachedNetworkImagesWidget(
                  focusRes?.image,
                  height: 40.sp,
                  width: 40.sp,
                ),
                const SpacerHorizontal(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        focusRes?.symbol ?? "",
                        style: styleGeorgiaBold(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SpacerVertical(height: 5),
                      Text(
                        focusRes?.name ?? "",
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
                const SpacerHorizontal(width: 8),
                focusRes?.chart == null || focusRes?.chart?.isEmpty == true
                    ? const SizedBox()
                    : ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.sp),
                          bottomRight: Radius.circular(10.sp),
                        ),
                        child: Container(
                          padding: EdgeInsets.only(top: 10.sp, bottom: 15.sp),
                          height: 50.sp,
                          width: 70.sp,
                          child: LineChart(
                            avgData(focusRes),
                          ),
                        ),
                      ),
                const SpacerHorizontal(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      focusRes?.price ?? "",
                      style: stylePTSansBold(fontSize: 20),
                    ),
                    Row(
                      children: [
                        Text(
                          focusRes?.change ?? "",
                          style: stylePTSansBold(
                              fontSize: 13,
                              color: (focusRes?.changesPercentage ?? 0) > 0
                                  ? ThemeColors.accent
                                  : focusRes?.changesPercentage == 0
                                      ? ThemeColors.white
                                      : ThemeColors.sos),
                        ),
                        // Text(
                        //   " (-1.27)%",
                        //   style: stylePTSansBold(
                        //       fontSize: 13, color: ThemeColors.sos),
                        // ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartData avgData(StockInFocusRes? focusRes) {
    List<Chart> reversedData = focusRes?.chart?.reversed.toList() ?? [];

    List<FlSpot> spots = [];

    // Extracting data for X and Y axes
    for (int i = 0; i < reversedData.length; i++) {
      spots.add(FlSpot(i.toDouble(), reversedData[i].close));
    }

    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: false,
        drawHorizontalLine: false,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: ThemeColors.transparent,
            strokeWidth: 1,
          );
        },
      ),
      borderData: FlBorderData(show: false),
      titlesData: const FlTitlesData(show: false),
      minX: 0,
      maxX: reversedData.length.toDouble() - 1,
      minY: reversedData
          .map((data) => data.close)
          .reduce((a, b) => a < b ? a : b)
          .toDouble(),
      maxY: reversedData
          .map((data) => data.close)
          .reduce((a, b) => a > b ? a : b)
          .toDouble(),
      lineBarsData: [
        LineChartBarData(
          show: true,
          spots: spots,
          color: (focusRes?.previousClose ?? 0) >
                  (focusRes?.chart?.first.close ?? 0)
              ? ThemeColors.sos
              : ThemeColors.accent,
          isCurved: true,
          barWidth: 2,
          isStrokeCapRound: false,
          dotData: const FlDotData(
            show: false, // hide dots
          ),
          belowBarData: BarAreaData(
            show: false,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                (focusRes?.previousClose ?? 0) >
                        (focusRes?.chart?.first.close ?? 0)
                    ? ThemeColors.sos.withOpacity(0.1)
                    : ThemeColors.accent.withOpacity(0.1),
                const Color.fromARGB(255, 48, 48, 48),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

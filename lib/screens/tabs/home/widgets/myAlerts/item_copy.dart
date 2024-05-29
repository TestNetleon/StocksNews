import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/home_alert_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HomeMyAlertItem extends StatelessWidget {
  final HomeAlertsRes data;
  const HomeMyAlertItem({super.key, required this.data});

  LineChartData avgData() {
    List<Chart> reversedData = data.chart?.reversed.toList() ?? [];

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
          color: data.previousClose > (data.chart?.first.close ?? 0)
              ? ThemeColors.sos
              : ThemeColors.accent,
          isCurved: true,
          barWidth: 2,
          isStrokeCapRound: false,
          dotData: const FlDotData(
            show: false, // hide dots
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                data.previousClose > (data.chart?.first.close ?? 0)
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 23, 23, 23),
            Color.fromARGB(255, 48, 48, 48),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CachedNetworkImagesWidget(
                      data.image,
                      height: 40,
                      width: 40,
                    ),
                    const SpacerHorizontal(width: 8),
                    Flexible(
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
                  ],
                ),
                const SpacerVertical(height: 5),
                Text(
                  data.price,
                  style: stylePTSansBold(fontSize: 20),
                ),
                Row(
                  children: [
                    Text(
                      data.change,
                      style: stylePTSansBold(
                          fontSize: 13,
                          color: data.changesPercentage > 0
                              ? ThemeColors.accent
                              : data.changesPercentage == 0
                                  ? ThemeColors.white
                                  : ThemeColors.sos),
                    ),
                    Text(
                      "  (${data.changesPercentage.toCurrency()})%",
                      style: stylePTSansBold(
                          fontSize: 13,
                          color: data.changesPercentage > 0
                              ? ThemeColors.accent
                              : data.changesPercentage == 0
                                  ? ThemeColors.white
                                  : ThemeColors.sos),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: data.chart == null || data.chart?.isEmpty == true
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(14),
                    ),
                    child: Container(
                      width: 220,
                      // color: const Color.fromARGB(255, 35, 35, 35),
                      constraints: const BoxConstraints(
                        maxHeight: 88,
                        minHeight: 30,
                      ),
                      child: Image.asset(
                        Images.graphHolder,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.sp),
                      bottomRight: Radius.circular(10.sp),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 15),
                      height: 88,
                      child: LineChart(avgData()),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeMyAlertItem extends StatefulWidget {
  const HomeMyAlertItem({super.key});

  @override
  State<HomeMyAlertItem> createState() => _HomeMyAlertItemState();
}

class _HomeMyAlertItemState extends State<HomeMyAlertItem> {
  List<Map<String, dynamic>> chartData = [
    {
      "date": "2024-05-03 15:55:00",
      "open": 183.485,
      "low": 183.05,
      "high": 183.485,
      "close": 183.39,
      "volume": 5429232
    },
    {
      "date": "2024-05-03 15:50:00",
      "open": 184,
      "low": 183.44,
      "high": 184.15,
      "close": 183.49,
      "volume": 3047110
    },
    {
      "date": "2024-05-03 15:45:00",
      "open": 184.245,
      "low": 183.9,
      "high": 184.26,
      "close": 183.995,
      "volume": 2281059
    },
    {
      "date": "2024-05-03 15:40:00",
      "open": 184.635,
      "low": 184.21,
      "high": 184.64,
      "close": 184.245,
      "volume": 1267832
    },
    {
      "date": "2024-05-03 15:35:00",
      "open": 184.71,
      "low": 184.43,
      "high": 184.7299,
      "close": 184.64,
      "volume": 1447898
    },
    {
      "date": "2024-05-03 15:30:00",
      "open": 185,
      "low": 184.7,
      "high": 185.01,
      "close": 184.7199,
      "volume": 1413845
    },
    {
      "date": "2024-05-03 15:25:00",
      "open": 184.68,
      "low": 184.67,
      "high": 185.02,
      "close": 184.995,
      "volume": 1427314
    },
    {
      "date": "2024-05-03 15:20:00",
      "open": 184.6399,
      "low": 184.26,
      "high": 184.82,
      "close": 184.69,
      "volume": 1890735
    },
    {
      "date": "2024-05-03 15:15:00",
      "open": 184.86,
      "low": 184.63,
      "high": 185.015,
      "close": 184.64,
      "volume": 1214182
    },
    {
      "date": "2024-05-03 15:10:00",
      "open": 184.975,
      "low": 184.79,
      "high": 185.09,
      "close": 184.87,
      "volume": 2475133
    },
  ];

  LineChartData avgData() {
    List<FlSpot> spots = [];

    // Extracting data for X and Y axes
    for (int i = 0; i < chartData.length; i++) {
      spots.add(FlSpot(i.toDouble(), chartData[i]['close']));
    }

    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: false,
        drawHorizontalLine: false,
        verticalInterval: 1,
        horizontalInterval: 1,
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
      maxX: chartData.length.toDouble() - 1,
      minY: chartData
          .map((data) => data['close'])
          .reduce((a, b) => a < b ? a : b)
          .toDouble(),
      maxY: chartData
          .map((data) => data['close'])
          .reduce((a, b) => a > b ? a : b)
          .toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          color: ThemeColors.accent,
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
                ThemeColors.accent.withOpacity(0.1),
                ThemeColors.background,
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   Navigator.push(context, MaterialPageRoute(
      //     builder: (context) {
      //       return FLtryChart(
      //         chartData: chartData,
      //       );
      //     },
      //   ));
      // },
      child: Container(
        // height: 400,
        width: 200,

        decoration: BoxDecoration(
          // color: ThemeColors.greyBorder,
          borderRadius: BorderRadius.circular(10.sp),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 23, 23, 23),
              // ThemeColors.greyBorder,
              Color.fromARGB(255, 48, 48, 48),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10.sp),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: ThemeColors.greyBorder,
                  ),
                  const SpacerHorizontal(width: 8),
                  Column(
                    children: [
                      Text(
                        "AAPL",
                        style: styleGeorgiaBold(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SpacerVertical(height: 5),
                      Text(
                        "Apple Inc.",
                        style: styleGeorgiaRegular(
                          color: ThemeColors.greyText,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20.sp),
              height: 80,
              // width: 300,
              child: LineChart(avgData()),
            ),
          ],
        ),
      ),
    );
  }
}

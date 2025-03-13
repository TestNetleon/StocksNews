import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../../../../models/stockDetail/financial.dart';

class AIFinancialCharts extends StatelessWidget {
  final List<AiFinancialChartRes>? chart;
  const AIFinancialCharts({super.key, this.chart});

  double _calculateMaxY() {
    if (chart?.isEmpty == true || chart == null) {
      return 0;
    }

    double? maxValue = chart?.fold<double>(
        0.0,
        (previousValue, element) => (element.value ?? 0) > previousValue
            ? element.value?.toDouble() ?? 0
            : previousValue);
    return (maxValue ?? 0) * 1.2;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barTouchData: barTouchData,
          titlesData: titlesData,
          borderData: borderData,
          barGroups: barGroups,
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceEvenly,
          maxY: _calculateMaxY(),
        ),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 2,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              "${chart?[groupIndex].displayValue}",
              styleBaseBold(
                color: ThemeColors.black,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: ThemeColors.black,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    if (value.toInt() >= 0 && value.toInt() < (chart?.length ?? 0)) {
      String text = chart?[value.toInt()].title ?? '';
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: Text(text, style: style),
      );
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text("N/A", style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _greenGradient => LinearGradient(
        colors: const [
          Color.fromARGB(255, 0, 103, 22),
          Color.fromARGB(255, 123, 255, 0),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  LinearGradient get _redGradient => LinearGradient(
        colors: const [
          Color.fromARGB(255, 121, 1, 1),
          Colors.red,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  // List<BarChartGroupData> get barGroups {
  //   if (chart == null || chart!.isEmpty) return [];
  //   List<BarChartGroupData> groups = [];
  //   double? previousValue;
  //   for (int i = (chart?.length ?? 0) - 1; i >= 0; i--) {
  //     LinearGradient barGradient;
  //     double currentValue = chart![i].value?.toDouble() ?? 0;
  //     if (previousValue == null || currentValue > previousValue) {
  //       barGradient = _greenGradient;
  //     } else {
  //       barGradient = _redGradient;
  //     }
  //     previousValue = currentValue;
  //     groups.add(
  //       BarChartGroupData(
  //         x: i,
  //         barRods: [
  //           BarChartRodData(
  //             toY: currentValue,
  //             width: 25,
  //             borderRadius: BorderRadius.vertical(
  //               top: Radius.circular(5),
  //               bottom: Radius.circular(5),
  //             ),
  //             gradient: barGradient,
  //           ),
  //         ],
  //         showingTooltipIndicators: [0],
  //       ),
  //     );
  //   }
  //   return groups.reversed.toList();
  // }

  List<BarChartGroupData> get barGroups {
    if (chart == null || chart!.isEmpty) return [];

    List<BarChartGroupData> groups = [];
    double? previousValue;

    for (int i = 0; i < chart!.length; i++) {
      // Changed loop to go from left to right
      // LinearGradient barGradient;
      Color color;

      double currentValue = chart![i].value?.toDouble() ?? 0;

      if (previousValue == null || currentValue > previousValue) {
        // barGradient = _greenGradient;
        color = ThemeColors.success120;
      } else {
        color = ThemeColors.error120;
        // barGradient = _redGradient;
      }

      previousValue = currentValue;

      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: currentValue,
              width: 25,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(5),
                bottom: Radius.circular(5),
              ),
              // gradient: barGradient,
              color: color,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }

    return groups;
  }
}

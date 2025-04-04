import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/tour_user_detail.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/card.dart';


class GrowthChart extends StatelessWidget {
  final List<GChart>? chart;
  const GrowthChart({super.key, this.chart});

  double _calculateMinY() {
    double minValue = barGroups
        .expand((group) => group.barRods)
        .map((rod) => rod.toY)
        .reduce((a, b) => a < b ? a : b);

    return minValue < 0 ? minValue - 5 : 0;
  }

  double _calculateMaxY() {
    double maxValue = barGroups
        .expand((group) => group.barRods)
        .map((rod) => rod.toY)
        .reduce((a, b) => a > b ? a : b);

    return maxValue + 5;
  }
  @override
  Widget build(BuildContext context) {
    return CommonCard(
      margin: const EdgeInsets.symmetric(horizontal:Pad.pad16),
      padding: const EdgeInsets.symmetric(vertical:Pad.pad16,horizontal: Pad.pad16),
      child: SizedBox(
        height: 300,
        child: BarChart(
          BarChartData(
            barTouchData: barTouchData,
            titlesData: titlesData,
            borderData: borderData,
            barGroups: barGroups,
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: false,
              horizontalInterval: 20,
              verticalInterval: 20,
            ),
            alignment: BarChartAlignment.spaceAround,
            maxY: _calculateMaxY(),
            minY: _calculateMinY(),
          ),
        ),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          fitInsideHorizontally: false,
          fitInsideVertically: false,
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 1,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              "${chart?[groupIndex].formatPerformance}",
              styleBaseBold(
                fontSize: 10,
              ),
            );
          },
        ),
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    DateTime minDate = chart!.first.battleDate!;
    DateTime currentDate = minDate.add(Duration(days: value.toInt()));
    String formattedDate = DateFormat('dd MMM').format(currentDate);
    return SideTitleWidget(
      // meta: meta,
      space: 0,
      axisSide: AxisSide.bottom,
      angle: 80.1,
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(formattedDate, style: styleBaseRegular(fontSize: 12),textAlign: TextAlign.center),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      space: 5,
      axisSide: AxisSide.left,
      child: Text(meta.formattedValue,  style: styleBaseRegular(fontSize: 12),textAlign: TextAlign.center),
    );
  }

  double _calculateInterval() {
    DateTime minDate = chart!.first.battleDate!;
    DateTime maxDate = chart!.length == 1
        ? DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)
        : chart!.last.battleDate!;

    int totalDays = maxDate == minDate ? 1 : maxDate.difference(minDate).inDays;

    int maxLabels = 5;
    double interval = totalDays / maxLabels;
    return interval.ceilToDouble();
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) => bottomTitleWidgets(value, meta),
            //interval: _calculateInterval(),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => leftTitleWidgets(value, meta),
            reservedSize: 30
          ),
          drawBelowEverything: false,
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
        colors:  [
          ThemeColors.accent,
          ThemeColors.accent,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  LinearGradient get _redGradient => LinearGradient(
        colors: [
          ThemeColors.sos,
          ThemeColors.sos,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );


  List<BarChartGroupData> get barGroups {
    if (chart == null || chart!.isEmpty) return [];

    List<BarChartGroupData> groups = [];
    for (int i = 0; i < chart!.length; i++) {
      LinearGradient barGradient;

      double currentValue = chart![i].performance?.toDouble() ?? 0;

      if (currentValue > 0) {
        barGradient = _greenGradient;
      }
      else {
        barGradient = _redGradient;
      }
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: currentValue,
              width: 7,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(0),
                bottom: Radius.circular(0),
              ),
              gradient: barGradient,
            ),
          ],
          //showingTooltipIndicators: [0],
        ),
      );
    }

    return groups;
  }
}

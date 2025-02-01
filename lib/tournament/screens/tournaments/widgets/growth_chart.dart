import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stocks_news_new/tournament/models/tour_user_detail.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class GrowthChart extends StatelessWidget {
  final List<GChart>? chart;
  const GrowthChart({super.key, this.chart});

  double _calculateMaxY() {
    if (chart?.isEmpty == true || chart == null) {
      return 0;
    }

    double? maxValue = chart?.fold<double>(
        0.0,
        (previousValue, element) => (element.performance ?? 0) > previousValue
            ? element.performance?.toDouble() ?? 0
            : previousValue);
    return (maxValue ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
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
            horizontalInterval: 1.5,
            verticalInterval: 5,
          ),
          alignment: BarChartAlignment.spaceAround,
          maxY: _calculateMaxY(),
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
          tooltipMargin:1,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              "${chart?[groupIndex].formatPerformance}",
              styleGeorgiaBold(
                color: Colors.transparent,
                fontSize: 10,
              ),
            );
          },
        ),
      );

  /*String formatDate(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }
  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color:ThemeColors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    if (value.toInt() >= 0 && value.toInt() < (chart?.length ?? 0)) {
      String text = chart?[value.toInt()].battleDate1 ?? '';

      print(formatDate(chart?[value.toInt()].battleDate??DateTime.now()));
      return SideTitleWidget(
        space: 16,
        axisSide: AxisSide.bottom,
        child: Text(formatDate(chart?[value.toInt()].battleDate??DateTime.now()),style: style),
      );
    }
    return SideTitleWidget(
      space: 16,
      axisSide: AxisSide.bottom,
      child: Text(meta.formattedValue, style: style),
    );
  }*/

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    if (value % 1 != 0) {
      return Container();
    }
    final style = TextStyle(
      color:ThemeColors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
      // meta: meta,
      space: 16,
      axisSide: AxisSide.bottom,
      child: Text(meta.formattedValue, style: style),
    );
  }
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      color: ThemeColors.white,
      fontWeight: FontWeight.bold,
      fontSize:14,
    );
    return SideTitleWidget(
      space: 16,
      axisSide: AxisSide.left,
      child: Text(meta.formattedValue, style: style),
    );
  }

  double _calculateInterval() {
    DateTime minDate = chart!.first.battleDate!;
    DateTime maxDate = chart!.length == 1
        ? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
        : chart!.last.battleDate!;

    int totalDays = maxDate == minDate ? 1 : maxDate.difference(minDate).inDays;

    // Set a maximum number of labels you want to display
    int maxLabels = 5; // For example, 5 labels
    double interval = totalDays / maxLabels;

    // Ensure the interval is at least 1 day to avoid zero or negative intervals
    return interval.ceilToDouble();
  }


  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              DateTime minDate = chart!.first.battleDate!;
              DateTime currentDate = minDate.add(Duration(days: value.toInt()));
              String formattedDate = DateFormat('dd MMM').format(currentDate);
              return Text(
                formattedDate,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              );
            },
            //interval: _calculateInterval(),
          ),


        ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) => leftTitleWidgets(value, meta),
        reservedSize: 56,
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
        colors: const [
          Color.fromARGB(255, 0, 103, 22),
          Color.fromARGB(255, 123, 255, 0),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  LinearGradient get _blueGradient => LinearGradient(
        colors: const [
          Color.fromARGB(255, 23, 131, 238),
          Color.fromARGB(255, 15, 236, 243),
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
    // double? previousValue;

    for (int i = 0; i < chart!.length; i++) {
      // Changed loop to go from left to right
      LinearGradient barGradient;

      double currentValue = chart![i].performance?.toDouble() ?? 0;

      if (currentValue > 0) {
        barGradient = _greenGradient;
      }
      /* else if(currentValue == 0){
        barGradient = _blueGradient;
      }*/
      else {
        barGradient = _redGradient;
      }

      // previousValue = currentValue;

      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: currentValue,
              width: 20,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(0),
                bottom: Radius.circular(0),
              ),
              gradient: barGradient,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }

    return groups;
  }
}

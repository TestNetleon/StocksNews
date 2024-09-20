import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../../../../modals/msAnalysis/financials.dart';

class MsFinancialCharts extends StatelessWidget {
  final List<MsFinancialsRes>? chart;
  const MsFinancialCharts({super.key, this.chart});

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
      height: 250,
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
              "${chart?[groupIndex].formattedValue}",
              styleGeorgiaBold(color: Colors.white, fontSize: 10),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Color.fromARGB(255, 247, 247, 247),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    if (value.toInt() >= 0 && value.toInt() < (chart?.length ?? 0)) {
      String text = chart?[value.toInt()].key ?? '';
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

  LinearGradient get _barsGradient => LinearGradient(
        colors: const [
          Color.fromARGB(255, 123, 255, 0),
          Color.fromARGB(255, 4, 131, 32),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => List.generate(
        (chart?.length ?? 0),
        (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: (chart?[index].value?.toDouble() ?? 0),
                width: 25,
                borderRadius: (chart?[index].value ?? 0) < 0
                    ? BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                gradient: _barsGradient,
              ),
            ],
            showingTooltipIndicators: [0],
          );
        },
      );
}

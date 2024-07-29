import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class NetProfitChart extends StatefulWidget {
  const NetProfitChart({super.key});

  @override
  State<NetProfitChart> createState() => _NetProfitChartState();
}

class _NetProfitChartState extends State<NetProfitChart> {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
          barTouchData: barTouchData,
          titlesData: titlesData,
          borderData: borderData,
          barGroups: barGroups,
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceEvenly,
          maxY: 30,
          minY: -15),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 6,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
    String text;
    switch (value.toInt()) {
      case 0:
        text = '2020';
        break;
      case 1:
        text = '2021';
        break;
      case 2:
        text = '2022';
        break;
      case 3:
        text = '2023';
        break;
      case 4:
        text = '2024';
        break;

      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 2,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 20,
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
          Color.fromARGB(255, 140, 250, 36),
          Color.fromARGB(255, 4, 131, 32),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: 8,
              width: 15,
              borderRadius: BorderRadius.zero,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: 10,
              width: 15,
              borderRadius: BorderRadius.zero,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: -6,
              width: 15,
              borderRadius: BorderRadius.zero,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: 15,
              width: 15,
              borderRadius: BorderRadius.zero,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: 13,
              width: 15,
              borderRadius: BorderRadius.zero,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        // BarChartGroupData(
        //   x: 5,
        //   barRods: [
        //     BarChartRodData(
        //       toY: 10,
        //       gradient: _barsGradient,
        //     )
        //   ],
        //   showingTooltipIndicators: [0],
        // ),
        // BarChartGroupData(
        //   x: 6,
        //   barRods: [
        //     BarChartRodData(
        //       toY: 16,
        //       gradient: _barsGradient,
        //     )
        //   ],
        //   showingTooltipIndicators: [0],
        // ),
      ];
}

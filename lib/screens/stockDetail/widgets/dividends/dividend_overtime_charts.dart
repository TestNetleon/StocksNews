// ignore_for_file: unused_local_variable

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/stockDetailRes/dividends.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'dart:math' as math;

class DividendOvertimeCharts extends StatelessWidget {
  final List<DividendCharts>? charts;
  const DividendOvertimeCharts({super.key, this.charts});

  @override
  Widget build(BuildContext context) {
    double minY = getMinY(charts!);
    double maxY = getMinY(charts!);

    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.30,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final Widget text = Container(
      width: 8.0,
      // color: Colors.amber,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: charts?.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final String label = charts![index].label.toString();
          return Text(
            label[value.toInt()],
            style: stylePTSansBold(
              color: Colors.white,
              fontSize: 8,
              decoration: TextDecoration.none,
            ),
          );
        },
      ),
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 1.0,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final Widget text = Container(
      width: 8.0,
      // color: Colors.amber,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: charts?.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final String label = charts![index].chartInfoYield.toString();
          return Transform.rotate(
            angle: -math.pi / 4,
            child: Text(
              label[value.toInt()],
              style: stylePTSansBold(
                color: Colors.white,
                fontSize: 8,
                decoration: TextDecoration.none,
              ),
            ),
          );
        },
      ),
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 1.0,
      child: text,
    );
  }

  LineChartData mainData() {
    double minY = getMinY(charts!);
    double maxY = getMinY(charts!);
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color.fromARGB(100, 100, 100, 100),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color.fromARGB(100, 100, 100, 100),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            // interval: 1,
            getTitlesWidget: bottomTitleWidgets,

            //update it with api response
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            // interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 22,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: charts!.length.toDouble() - 1,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          color: Colors.green,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
        ),
      ],
    );
  }

  double getMinY(List<DividendCharts> data) {
    return data
        .map((e) => double.parse(e.chartInfoYield!.replaceAll('%', '')) / 100)
        .reduce((min, value) => min < value ? min : value);
  }

  double getMaxY(List<DividendCharts> data) {
    return data
        .map((e) => double.parse(e.chartInfoYield!.replaceAll('%', '')) / 100)
        .reduce((max, value) => max > value ? max : value);
  }
}

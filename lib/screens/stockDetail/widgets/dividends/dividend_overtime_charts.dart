import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stocks_news_new/modals/stockDetailRes/dividends.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:vibration/vibration.dart';
import 'dart:math' as math;

class DividendOvertimeCharts extends StatefulWidget {
  final List<DividendCharts>? charts;
  const DividendOvertimeCharts({super.key, this.charts});

  @override
  State<DividendOvertimeCharts> createState() => _DividendOvertimeChartsState();
}

class _DividendOvertimeChartsState extends State<DividendOvertimeCharts> {
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;
  int maxValue = 0;
  int minValue = 0;
  int maxAbsValue = 0;
  int minAbsValue = 0;

  bool valueNegative = true;

  @override
  void initState() {
    super.initState();
    intFunction();
  }

  void intFunction(){
    // setState(() {
    //   final maxRevenue = widget.charts?.isNotEmpty == true
    //       ? widget.charts!
    //           .map((e) => e.label)
    //           .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
    //       : 0;
    //   final maxNetIncome = charts?.isNotEmpty == true
    //       ? charts
    //           ?.map((e) => e.netIncome)
    //           .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
    //       : 0;
    //   maxAbsValue = (maxRevenue! > maxNetIncome!) ? maxRevenue : maxNetIncome;
    // });
  }

  @override
  Widget build(BuildContext context) {
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
        itemCount: widget.charts?.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final String label = widget.charts![index].label.toString() ?? "";
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

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final Widget text = Container(
      width: 8.0,
      // color: Colors.amber,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.charts?.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final String label =
              widget.charts![index].chartInfoYield.toString() ?? "";
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
        maxX: 11,
        minY: 0,
        maxY: 6,
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
        lineTouchData: LineTouchData(
          touchCallback:
              (FlTouchEvent event, LineTouchResponse? touchResponse) async {
            if (event is FlTapUpEvent || event is FlPanEndEvent) {
              try {
                if (Platform.isAndroid) {
                  bool isVibe = await Vibration.hasVibrator() ?? false;
                  if (isVibe) {
                    Vibration.vibrate(
                        pattern: [50, 50, 79, 55], intensities: [1, 10]);
                  }
                } else {
                  HapticFeedback.lightImpact();
                }
                // ignore: empty_catches
              } catch (e) {}
            }
          },
          handleBuiltInTouches: true,
        ));
  }
}

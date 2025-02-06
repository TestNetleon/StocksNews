import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/tournament/models/tour_user_detail.dart';
import 'package:stocks_news_new/utils/colors.dart';


class LineChartSample9 extends StatefulWidget {
  final List<GChart>? gChart;
  const LineChartSample9({super.key,this.gChart});

  @override
  State<LineChartSample9> createState() => _LineChartSample9State();
}

class _LineChartSample9State extends State<LineChartSample9> with SingleTickerProviderStateMixin {

  List<FlSpot> spots = [];
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    DateTime? minDate = widget.gChart!.first.battleDate;
    spots = widget.gChart!
        .map((entry) => FlSpot(
      entry.battleDate!.difference(minDate!).inDays.toDouble(),
      entry.performance!.toDouble(),
    )).toList();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween(begin: 1.0, end: 0.0).animate(_animationController!);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  double _calculateInterval() {
    DateTime minDate = widget.gChart!.first.battleDate!;
    DateTime maxDate = spots.length==1?DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day):widget.gChart!.last.battleDate!;

    int totalDays = maxDate == minDate?1:maxDate.difference(minDate).inDays;
    double screenWidth = MediaQuery.of(context).size.width;
    int maxLabels = (screenWidth / 50).floor();
    return (totalDays / maxLabels).ceilToDouble();
  }

  /*final spots = List.generate(101, (i) => (i - 50) / 10)
      .map((x) => FlSpot(x, cos(x)))
      .toList();*/

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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
        padding: const EdgeInsets.all(16.0),
      child:
    AnimatedBuilder(
    animation: _animation!,
    builder: (context, child) {
    return
      LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              maxContentWidth: 100,
              getTooltipColor: (touchedSpot) => Colors.black,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  final textStyle = TextStyle(
                    color: touchedSpot.bar.gradient?.colors[0] ??
                        touchedSpot.bar.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  );
                  return LineTooltipItem(
                    '${touchedSpot.x}, ${touchedSpot.y.toStringAsFixed(2)}',
                    textStyle,
                  );
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
            getTouchLineStart: (data, index) => 0,
          ),
          lineBarsData: [
            LineChartBarData(
              color: ThemeColors.darkGreen,
              spots: spots,
              isCurved: true,
              isStrokeCapRound: true,
              barWidth: 2,
              belowBarData: BarAreaData(
                show: false,
              ),
              dotData: const FlDotData(show: false),
            ),
          ],
          minY: -1.5,
          maxY: 1.5,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => leftTitleWidgets(value, meta),
                reservedSize: 56,
              ),
              drawBelowEverything: true,
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) =>
                    bottomTitleWidgets(value, meta),
                reservedSize: 36,
                interval: _calculateInterval(),
              ),
              drawBelowEverything: true,
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: false,
            drawHorizontalLine: true,
            drawVerticalLine: true,
            horizontalInterval: 1.5,
            verticalInterval: 5,
            checkToShowHorizontalLine: (value) {
              return value.toInt() == 0;
            },
            getDrawingHorizontalLine: (_) => FlLine(
              color:ThemeColors.white.withValues(alpha: 1),
              dashArray: [8, 2],
              strokeWidth: 0.8,
            ),
            getDrawingVerticalLine: (_) => FlLine(
              color: ThemeColors.white.withValues(alpha: 1),
              dashArray: [8, 2],
              strokeWidth: 0.8,
            ),
            checkToShowVerticalLine: (value) {
              return value.toInt() == 0;
            },
          ),
          borderData: FlBorderData(show: false),
        ),
      );}
    )
    );
  }
}
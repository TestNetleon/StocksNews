import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stocks_news_new/tournament/models/tour_user_detail.dart';
import 'package:stocks_news_new/utils/colors.dart';

class TradingLineChart extends StatefulWidget {
  final List<GChart>? gChart;
  const TradingLineChart({super.key,this.gChart});

  @override
  State<TradingLineChart> createState() => _TradingLineChartState();
}

class _TradingLineChartState extends State<TradingLineChart>  with SingleTickerProviderStateMixin {


  List<FlSpot> currentData = [];

  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    DateTime? minDate = widget.gChart!.first.battleDate;

    currentData = widget.gChart!
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
    DateTime maxDate = currentData.length==1?DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day):widget.gChart!.last.battleDate!;

    int totalDays = maxDate == minDate?1:maxDate.difference(minDate).inDays;
    double screenWidth = MediaQuery.of(context).size.width;
    int maxLabels = (screenWidth / 50).floor();
    return (totalDays / maxLabels).ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      padding: const EdgeInsets.all(16.0),
      child: AnimatedBuilder(
        animation: _animation!,
        builder: (context, child) {
          return LineChart(
            LineChartData(
              minX: currentData.first.x,
              maxX: currentData.length==1?6:currentData.last.x,
              minY: currentData.map((e) => e.y).reduce((a, b) => a < b ? a : b),
              maxY: currentData.map((e) => e.y).reduce((a, b) => a > b ? a : b),

              lineBarsData: [
                _buildLineChartBarData(
                  ThemeColors.darkGreen,
                  currentData,
                  blinkingOpacity: _animation!.value,
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize:35,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.white,fontSize: 10),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      DateTime minDate = widget.gChart!.first.battleDate!;
                      DateTime currentDate = minDate.add(Duration(days: value.toInt()));
                      String formattedDate = DateFormat('dd MMM').format(currentDate);
                      return Text(
                        formattedDate,
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      );
                    },
                    interval: _calculateInterval(),
                  ),
                ),
              ),
              gridData: FlGridData(
                show: false,
                drawHorizontalLine: true,
                drawVerticalLine: true,
              ),
              borderData: FlBorderData(show: false, border: Border.all(color: Colors.white)),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) {
                    return Colors.grey;
                  },
                ),
                handleBuiltInTouches: true,
                getTouchedSpotIndicator: (barData, spotIndexes) {
                  return spotIndexes.map((index) {
                    return TouchedSpotIndicatorData(
                      FlLine(
                        color: Colors.grey,
                        strokeWidth: 1,
                      ),
                      FlDotData(show: false),
                    );
                  }).toList();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  LineChartBarData _buildLineChartBarData(
      Color color,
      List<FlSpot> spots, {
        double blinkingOpacity = 1.0,
      }) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 2,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(show: true),
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          if (index == spots.length - 1) {
            return FlDotCirclePainter(
              radius: 4,
              color: Colors.red.withOpacity(blinkingOpacity),
              strokeWidth: 1,
              strokeColor: Colors.black,
            );
          }
          return FlDotCirclePainter(radius: 0);
        },
      ),
    );
  }
}

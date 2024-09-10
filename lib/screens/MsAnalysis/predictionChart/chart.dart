import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';

class MsForecastChart extends StatefulWidget {
  const MsForecastChart({super.key});

  @override
  State<MsForecastChart> createState() => _MsForecastChartState();
}

class _MsForecastChartState extends State<MsForecastChart>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> data = [
    {'amount': 0.0, 'year': 2020},
    {'amount': 4.9, 'year': 2021},
    {'amount': 1.4, 'year': 2022},
    {'amount': 4.0345345, 'year': 2023},
    {'amount': 4.78567, 'year': 2024},
  ];

  final List<Map<String, dynamic>> prediction1 = [
    {'amount': 4.78567, 'year': 2024},
    {'amount': 5.85767, 'year': 2025},
    {'amount': 7.88867, 'year': 2026},
  ];

  final List<Map<String, dynamic>> prediction2 = [
    {'amount': 4.78567, 'year': 2024},
    {'amount': 3.78567, 'year': 2025},
    {'amount': 9.78867, 'year': 2026},
  ];

  List<FlSpot> currentData = [];
  List<FlSpot> predictionData1 = [];
  List<FlSpot> predictionData2 = [];

  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    for (var entry in data) {
      if (entry['year'] <= 2024) {
        currentData.add(FlSpot(entry['year'] - 2020.0, entry['amount']));
      }
    }
    for (var entry in prediction1) {
      predictionData1.add(FlSpot(entry['year'] - 2020.0, entry['amount']));
    }
    for (var entry in prediction2) {
      predictionData2.add(FlSpot(entry['year'] - 2020.0, entry['amount']));
    }

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
              minX: 0,
              maxX: 6,
              minY: 0,
              maxY: 10,
              lineBarsData: [
                _buildLineChartBarData(
                  Colors.blue,
                  currentData,
                  blinkingOpacity: _animation!.value,
                ),
                _buildLineChartBarData(
                  Colors.green,
                  predictionData1,
                  isDashed: true,
                ),
                _buildLineChartBarData(
                  Colors.red,
                  predictionData2,
                  isDashed: true,
                ),
              ],
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        "$value",
                        style: TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    interval: 1,
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 0:
                          return Text(
                            '2020',
                            style: TextStyle(color: Colors.white),
                          );
                        case 1:
                          return Text(
                            '2021',
                            style: TextStyle(color: Colors.white),
                          );
                        case 2:
                          return Text(
                            '2022',
                            style: TextStyle(color: Colors.white),
                          );
                        case 3:
                          return Text(
                            '2023',
                            style: TextStyle(color: Colors.white),
                          );
                        case 4:
                          return Text(
                            '2024',
                            style: TextStyle(color: Colors.white),
                          );
                        case 5:
                          return Text(
                            '2025',
                            style: TextStyle(color: Colors.white),
                          );
                        case 6:
                          return Text(
                            '2026',
                            style: TextStyle(color: Colors.white),
                          );
                        default:
                          return Text('');
                      }
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: true,
              ),
              borderData: FlBorderData(
                  show: true, border: Border.all(color: Colors.white)),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) {
                    return ThemeColors.greyBorder.withOpacity(0.6);
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
                      FlDotData(show: true),
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
    bool isDashed = false,
    double blinkingOpacity = 1.0,
  }) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 2,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(show: false),
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          if (index == spots.length - 1) {
            return FlDotCirclePainter(
              radius: 4,
              color: color.withOpacity(blinkingOpacity),
              strokeWidth: 1,
              strokeColor: Colors.black,
            );
          }
          return FlDotCirclePainter(radius: 0);
        },
      ),
      dashArray: isDashed ? [5, 5] : null,
    );
  }
}

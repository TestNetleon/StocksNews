import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ForecastingChart extends StatefulWidget {
  const ForecastingChart({super.key});

  @override
  State<ForecastingChart> createState() => _ForecastingChartState();
}

class _ForecastingChartState extends State<ForecastingChart> {
  List<Color> gradientColors = [
    Colors.green,
    const Color.fromARGB(255, 1, 126, 5),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> combinedChart = [
      {
        "year": 2023,
        "amount": 3,
        "month": "MAY",
      },
      {
        "year": 2023,
        "amount": 4,
        "month": "OCT",
      },
      {
        "year": 2024,
        "amount": 2,
        "month": "MAY",
      },
      {
        "year": 2024,
        "amount": 5,
        "month": "OCT",
      },
      {
        "year": 2025,
        "amount": 2,
        "month": "JAN",
      },
      {
        "year": 2025,
        "amount": 4,
        "month": "MAR",
      },
      {
        "year": 2025,
        "amount": 3,
        "month": "MAY",
      },
      {
        "year": 2025,
        "amount": 1,
        "month": "OCT",
      },
    ];

    List<Map<String, dynamic>> pastData = [];
    List<Map<String, dynamic>> futureData = [];

    void processData() {
      for (var data in combinedChart) {
        if (data['year'] <= 2024) {
          pastData.add(data);
        } else {
          futureData.add(data);
        }
      }
    }

    List<FlSpot> spots = combinedChart.map((entry) {
      final double x = entry["year"].toDouble(); // Use year as x-coordinate
      final double y = entry["amount"].toDouble(); // Use amount as y-coordinate
      return FlSpot(x, y);
    }).toList();

    // Find the maximum amount
    double maxAmount =
        spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

    // Calculate the interval for the y-axis
    // double interval = (maxAmount / 3).ceilToDouble();
    double yAxisInterval = 0.5; // Adjust as needed

    return AspectRatio(
      aspectRatio: 1.10,
      child: LineChart(
        LineChartData(
          maxY: maxAmount + yAxisInterval,
          minY: 0.0,
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 1),
                FlSpot(1, 3),
                FlSpot(2, 2),
                FlSpot(4, 3),
              ],
              isCurved: true,
              // colors: [Colors.red],
              color: Colors.blue,
              barWidth: 5,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: [
                const FlSpot(2, 2),
                const FlSpot(5, 3),
              ],
              isCurved: true,
              color: Colors.green,
              barWidth: 5,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: [
                const FlSpot(2, 2),
                const FlSpot(3, 3),
              ],
              isCurved: true,
              color: const Color.fromARGB(255, 248, 42, 42),
              barWidth: 5,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
            ),
          ],
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 1.0,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        combinedChart[value.toInt()]['year'].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: yAxisInterval,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return Text(
                    combinedChart[value.toInt()]['amount'].toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 1,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: Colors.green,
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return const FlLine(
                color: Colors.green,
                strokeWidth: 1,
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';

class ForcastingChart extends StatefulWidget {
  const ForcastingChart({super.key});

  @override
  State<ForcastingChart> createState() => _ForcastingChartState();
}

class _ForcastingChartState extends State<ForcastingChart> {
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
    double interval = (maxAmount / 3).ceilToDouble();
    double yAxisInterval = 0.5; // Adjust as needed

    return Container(
      height: 300,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Forcasting Analysis Metrics',
              style: stylePTSansBold(fontSize: 18, color: Colors.black)),
          const SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: LineChart(
              LineChartData(
                maxY: maxAmount,
                minY: 0.0,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 1),
                      FlSpot(1, 3),
                      FlSpot(2, 2),
                      FlSpot(3, 2),
                      FlSpot(4, 3),
                    ],
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 5,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: const [
                      FlSpot(4, 3),
                      FlSpot(5, 4),
                      FlSpot(6, 3),
                      FlSpot(7, 5),
                    ],
                    isCurved: false,
                    color: Colors.green,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: const [
                      FlSpot(4, 3),
                      FlSpot(5, 3),
                      FlSpot(6, 2),
                      FlSpot(7, 1),
                    ],
                    isCurved: false,
                    color: Colors.red,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: [
                      // FlSpot(3, 2),
                      FlSpot(4, 3),
                      FlSpot(4, 3),
                      FlSpot(6, 2),
                      FlSpot(7, 3),
                    ],
                    isCurved: false,
                    color: Colors.yellow,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text('Yearly Record',
                        style:
                            stylePTSansBold(fontSize: 14, color: Colors.black)),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 15,
                      getTitlesWidget: (value, meta) {
                        final year = value.toInt();

                        return Text(
                          combinedChart[value.toInt()]['year'].toString(),
                          style: TextStyle(color: Colors.black),
                        );
                      },
                      interval: 1.20,
                    ),
                  ),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    axisNameWidget: Text('Stock Amount',
                        style:
                            stylePTSansBold(fontSize: 14, color: Colors.black)),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 15,
                      getTitlesWidget: (value, meta) {
                        final amount = value.toInt();
                        return Text(
                          combinedChart[value.toInt()]['amount'].toString(),
                          style: TextStyle(color: Colors.black),
                        );
                      },
                      interval: 1,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                      color: Color.fromARGB(255, 236, 231, 231), width: 0.50),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 1,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Color.fromARGB(255, 236, 231, 231),
                      strokeWidth: 0.50,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return const FlLine(
                      color: Color.fromARGB(255, 236, 231, 231),
                      strokeWidth: 0.50,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

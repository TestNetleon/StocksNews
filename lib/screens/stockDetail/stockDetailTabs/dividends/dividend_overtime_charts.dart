import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/dividends.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/utils.dart';

class DividendPaymentLineChart extends StatelessWidget {
  const DividendPaymentLineChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    if (provider.dividends?.chartInfo == null ||
        provider.dividends!.chartInfo!.isEmpty) {
      return const Center(child: SizedBox.shrink());
    }

    List<FlSpot> spots =
        provider.dividends!.chartInfo!.asMap().entries.map((entry) {
      int index = entry.key;
      DividendCharts data = entry.value;
      double yield =
          double.tryParse(data.chartInfoYield!.replaceAll('%', '')) ?? 0;
      return FlSpot(index.toDouble(), yield);
    }).toList();

    // Find the maximum amount
    double maxAmount =
        spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    // double minAmount = 0.0;
    double interval = (maxAmount / 4).ceilToDouble();
    double yAxisInterval = 0.5;

    return AspectRatio(
      aspectRatio: 1.10,
      child: LineChart(
        LineChartData(
          maxY: maxAmount + yAxisInterval,
          // maxY: maxAmount,
          minY: 0.0,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: yAxisInterval,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  Utils().showLog(interval);
                  return Text(
                    '${value.toDouble()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index < 0 ||
                      index >= provider.dividends!.chartInfo!.length) {
                    Utils().showLog(
                        "data length is checking ${provider.dividends!.chartInfo!.length}");
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 1.0,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        provider.dividends!.chartInfo![index].label.toString(),
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
          ),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(
            show: true,
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.green,
              barWidth: 4,
              // belowBarData: BarAreaData(show: true, color: Colors.green),
              dotData: const FlDotData(show: false),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (group) => Colors.white,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  final data =
                      provider.dividends!.chartInfo![touchedSpot.spotIndex];
                  String inputDate = data.payableDate.toString();
                  DateTime date = DateFormat("MM/dd/yyyy").parse(inputDate);
                  String formattedDate = DateFormat("MMM d").format(date);
                  return LineTooltipItem(
                    textAlign: TextAlign.start,
                    '${data.label} $formattedDate\n ${data.chartInfoYield}',
                    const TextStyle(color: Colors.black),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}

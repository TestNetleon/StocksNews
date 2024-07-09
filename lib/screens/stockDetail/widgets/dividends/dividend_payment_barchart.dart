import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/dividends.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/utils.dart';

class DividendPaymentBarchart extends StatelessWidget {
  const DividendPaymentBarchart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    if (provider.dividends?.chartInfo == null ||
        provider.dividends!.chartInfo!.isEmpty) {
      return const Center(child: SizedBox.shrink());
    }

    List<double> amounts = provider.dividends!.chartInfo!.map((data) {
      return double.parse(data.amount!.replaceAll('\$', ''));
    }).toList();

    // Find the maximum amount
    double maxAmount = amounts.reduce((a, b) => a > b ? a : b);
    double minAmount = 0.0;

    double interval = (maxAmount - minAmount) / 4;

    return AspectRatio(
      aspectRatio: 1.10,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxAmount,
          // minY: minAmount,
          barGroups: provider.dividends!.chartInfo!.asMap().entries.map((entry) {
            int index = entry.key;
            DividendCharts data = entry.value;
            double amount =
                double.tryParse(data.amount!.replaceAll('\$', '')) ?? 0;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: amount,
                  color: Colors.green,
                  width: 16,
                  borderRadius: BorderRadius.circular(0),
                ),
              ],
              // showingTooltipIndicators: [0],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: double.parse(interval.toStringAsFixed(2)),
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '\$${value.toDouble()}',
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
                        "checking data lenght ${provider.dividends!.chartInfo!.length}");
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
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Colors.white,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final data = provider.dividends!.chartInfo![groupIndex];
                String inputDate = data.payableDate.toString();
                DateTime date = DateFormat("MM/dd/yyyy").parse(inputDate);
                String formattedDate = DateFormat("MMM d").format(date);
                return BarTooltipItem(
                  textAlign: TextAlign.start,
                  '${data.label} $formattedDate\n${data.amount}',
                  const TextStyle(color: Colors.black),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

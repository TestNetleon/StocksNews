import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stocks_news_new/modals/stockDetailRes/dividends.dart';
import 'package:vibration/vibration.dart';

class DividendPaymentBarchart extends StatefulWidget {
  final DividendCharts? data;
  DividendPaymentBarchart({super.key, this.data});

  @override
  State<DividendPaymentBarchart> createState() =>
      _DividendPaymentBarchartState();
}

class _DividendPaymentBarchartState extends State<DividendPaymentBarchart> {
  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barChartGroupData = [
      BarChartGroupData(x: 1, barRods: [
        BarChartRodData(fromY: 0, color: Colors.green, toY: 10),
      ]),
      BarChartGroupData(x: 2, barRods: [
        BarChartRodData(fromY: 0, color: Colors.green, toY: 3.8),
      ]),
      BarChartGroupData(x: 3, barRods: [
        BarChartRodData(fromY: 0, color: Colors.green, toY: 10.9),
      ]),
      BarChartGroupData(x: 4, barRods: [
        BarChartRodData(fromY: 0, color: Colors.green, toY: 5.6),
      ]),
      BarChartGroupData(x: 5, barRods: [
        BarChartRodData(fromY: 0, color: Colors.green, toY: 8.3),
      ]),
    ];
    return AspectRatio(
      aspectRatio: 1.30,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceEvenly,
            maxY: 20,
            barTouchData: BarTouchData(
                enabled: true,
                handleBuiltInTouches: true,
                touchCallback: (event, response) async {
                  if (response != null &&
                      response.spot != null &&
                      event is FlTapUpEvent) {
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
                    setState(() {
                      final x = response.spot!.touchedBarGroup.x;
                    });
                  }
                },
                mouseCursorResolver: (event, response) {
                  return response == null || response.spot == null
                      ? MouseCursor.defer
                      : SystemMouseCursors.click;
                }),
            titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 25,
                    interval: 0.20,
                    getTitlesWidget: bottomTitleWidgets,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 6,
                        child: Text(
                          value.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 25,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 2.0,
                        child: Text(
                          value.toInt().toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 16,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 8.0,
                        child: Text(value.toInt().toString()),
                      );
                    },
                  ),
                )),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey, width: 0.30),
            ),
            //--------new widget --------
            //  barGroups: List.generate(financialData!.length, (index) {
            //    final revenueString = financialData?[index]['Revenue'] as String;
            //    final revenueNumberString = revenueString.replaceAll(RegExp(r'[^\d.]'), '');
            //    final revenue = double.tryParse(revenueNumberString) ?? 0.0;
            barGroups: barChartGroupData,
            //final incomeString = financialData?[index]['Net Income'] as String;
            //    final incomeNumberString = incomeString.replaceAll(RegExp(r'[^\d.]'), '');
            //    final income = double.tryParse(incomeNumberString) ?? 0.0;
            //    print("revenue data"+ revenue.toString());
            //    print("income data"+ income.toString());
            //    return BarChartGroupData(
            //      x: index,
            //      barRods: [
            //        BarChartRodData(
            //          toY: revenue,
            //          color: Colors.blue,
            //          width: 10,
            //          borderRadius: BorderRadius.zero,
            //        ),
            //      ],
            //    );
            //  }),
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white);
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('MAR', style: style);
        break;
      case 2:
        text = const Text('JUN', style: style);
        break;
      case 3:
        text = const Text('SEP', style: style);
        break;
      case 4:
        text = const Text('OCT', style: style);
        break;
      case 5:
        text = const Text('Nov', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: text,
    );
  }
}

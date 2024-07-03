import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/stockDetailRes/financial.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';

class BarChartThreeLine extends StatefulWidget {
  const BarChartThreeLine({this.data, super.key});
  final SdFinancialRes? data;
  final Color leftBarColor = const Color.fromARGB(255, 7, 181, 255);
  final Color rightBarColor = ThemeColors.accent;
  final Color yellowBarColor = Colors.yellow;
  final Color avgColor = Colors.orange;

  @override
  State<StatefulWidget> createState() => BarChartThreeLineState();
}

class BarChartThreeLineState extends State<BarChartThreeLine> {
  final double width = 10.sp;
  final BorderRadius? radius = BorderRadius.all(Radius.circular(0.sp));

  List<BarChartGroupData>? rawBarGroups;
  List<BarChartGroupData>? showingBarGroups;
  List<Chart>? charts;

  int touchedGroupIndex = -1;
  int maxValue = 0;
  int minValue = 0;
  int maxAbsValue = 0;
  int minAbsValue = 0;

  bool valueNegative = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => intFunction());
  }

  void intFunction() {
    // setState(() {});
    charts = widget.data?.chart?.sublist(0, 5);
    log("LENGTH OF CHARTS => ${charts?.length}");

    // for (var i = 4; i > 0; i--) {
    for (var i = (charts?.length ?? 0) - 1; i > 0; i--) {
      BarChartGroupData barGroup = makeGroupData(
        0,
        (charts?[i].operatingCashFlow1 == null)
            ? 0.0
            : double.parse("${charts?[i].operatingCashFlow1}"),
        charts?[i].operatingCashFlow2 == null
            ? 0.0
            : double.parse("${charts![i].operatingCashFlow2}"),
        charts?[i].operatingCashFlow3 == null
            ? 0.0
            : double.parse("${charts![i].operatingCashFlow3}"),
      );

      if (rawBarGroups == null) {
        rawBarGroups = [barGroup];
      } else {
        rawBarGroups?.add(barGroup);
      }
    }

    // if (charts?[4].operatingCashFlow1 != null) {
    // BarChartGroupData barGroup1 = makeGroupData(
    //     0,
    //     (charts?[4].operatingCashFlow1 == null)
    //         ? 0.0
    //         : double.parse("${charts?[4].operatingCashFlow1}"),
    //     charts?[4].operatingCashFlow2 == null
    //         ? 0.0
    //         : double.parse("${charts![4].operatingCashFlow2}"),
    //     charts?[4].operatingCashFlow3 == null
    //         ? 0.0
    //         : double.parse(
    //             "${charts![4].operatingCashFlow3}")); // ww
    // BarChartGroupData barGroup2 = makeGroupData(
    //     1,
    //     charts?[3].operatingCashFlow1 == null
    //         ? 0.0
    //         : double.parse("${charts?[3].operatingCashFlow1}"),
    //     charts?[3].operatingCashFlow2 == null
    //         ? 0.0
    //         : double.parse("${charts![3].operatingCashFlow2}"),
    //     charts?[3].operatingCashFlow3 == null
    //         ? 0.0
    //         : double.parse("${charts![3].operatingCashFlow3}"));
    // BarChartGroupData barGroup3 = makeGroupData(
    //     2,
    //     charts?[2].operatingCashFlow1 == null
    //         ? 0.0
    //         : double.parse("${charts?[2].operatingCashFlow1}"),
    //     charts?[2].operatingCashFlow2 == null
    //         ? 0.0
    //         : double.parse("${charts![2].operatingCashFlow2}"),
    //     charts?[2].operatingCashFlow3 == null
    //         ? 0.0
    //         : double.parse("${charts![2].operatingCashFlow3}"));
    // BarChartGroupData barGroup4 = makeGroupData(
    //     3,
    //     charts?[1].operatingCashFlow1 == null
    //         ? 0.0
    //         : double.parse("${charts?[1].operatingCashFlow1}"),
    //     charts?[1].operatingCashFlow2 == null
    //         ? 0.0
    //         : double.parse("${charts![1].operatingCashFlow2}"),
    //     charts?[1].operatingCashFlow3 == null
    //         ? 0.0
    //         : double.parse("${charts![1].operatingCashFlow3}"));
    // BarChartGroupData barGroup5 = makeGroupData(
    //     4,
    //     charts?[0].operatingCashFlow1 == null
    //         ? 0.0
    //         : double.parse("${charts?[0].operatingCashFlow1}"),
    //     charts?[0].operatingCashFlow2 == null
    //         ? 0.0
    //         : double.parse("${charts![0].operatingCashFlow2}"),
    //     charts?[0].operatingCashFlow3 == null
    //         ? 0.0
    //         : double.parse("${charts![0].operatingCashFlow3}"));

    // final items = [
    //   barGroup1,
    //   barGroup2,
    //   barGroup3,
    //   barGroup4,
    //   barGroup5,
    // ];

    // rawBarGroups = items;

    showingBarGroups = rawBarGroups;

    final maxRevenue = charts?.isNotEmpty == true
        ? charts!
            .map((e) => e.operatingCashFlow1)
            .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
        : 0;
    final maxNetIncome = charts?.isNotEmpty == true
        ? charts
            ?.map((e) => e.operatingCashFlow2)
            .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
        : 0;
    final maxNetFin = charts?.isNotEmpty == true
        ? charts
            ?.map((e) => e.operatingCashFlow3)
            .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
        : 0; // ww

    final maxValueItem =
        (maxRevenue!.abs() > maxNetIncome!.abs()) ? maxRevenue : maxNetIncome;

    maxValue =
        (maxValueItem.abs() > maxNetFin!.abs()) ? maxValueItem : maxNetFin;

    final minRevenue = charts?.isNotEmpty == true
        ?
        // charts!
        //     .map((e) => e.operatingCashFlow1)
        //     // Filter only negative values
        //     .where((e) => e != null && e < 0)
        //     // Find the minimum negative value
        //     .reduce((a, b) => a! < b! ? a : b)

        charts
            ?.map((e) => e.operatingCashFlow1)
            // Filter only negative values
            .where((e) => e != null && e < 0)
            // Provide a default value (null) if no negative values are found
            .fold<int?>(null, (min, e) => min == null || e! < min ? e : min)
        : null;

    final minNetIncome = charts?.isNotEmpty == true
        ?
        // charts!
        //     .map((e) => e.operatingCashFlow2)
        //     // Filter only negative values
        //     .where((e) => e != null && e < 0)
        //     // Find the minimum negative value
        //     .reduce((a, b) => a! < b! ? a : b)
        charts
            ?.map((e) => e.operatingCashFlow2)
            // Filter only negative values
            .where((e) => e != null && e < 0)
            // Provide a default value (null) if no negative values are found
            .fold<int?>(null, (min, e) => min == null || e! < min ? e : min)
        : null;
    final minNetFin = charts?.isNotEmpty == true
        ?
        // charts!
        //     .map((e) => e.operatingCashFlow3)
        //     // Filter only negative values
        //     .where((e) => e != null && e < 0)
        //     // Find the minimum negative value
        //     .reduce((a, b) => a! < b! ? a : b)
        charts
            ?.map((e) => e.operatingCashFlow3)
            // Filter only negative values
            .where((e) => e != null && e < 0)
            // Provide a default value (null) if no negative values are found
            .fold<int?>(null, (min, e) => min == null || e! < min ? e : min)
        : null;

    final minAbsValueItem = (minRevenue != null && minNetIncome != null)
        ? (minRevenue.abs() < minNetIncome.abs() ? minRevenue : minNetIncome)
        : 0;
    minAbsValue = (minAbsValueItem != null && minNetFin != null)
        ? (minAbsValueItem.abs() < minNetFin.abs()
            ? minAbsValueItem
            : minNetFin)
        : 0;

    final maxAbsValueItem = (maxRevenue.abs() > maxNetIncome.abs())
        ? maxRevenue.abs()
        : maxNetIncome.abs();
    maxAbsValue = (maxAbsValueItem.abs() > maxNetFin.abs())
        ? maxAbsValueItem.abs()
        : maxNetFin.abs();

    setState(() {});

    // }
  }

  @override
  Widget build(BuildContext context) {
    double positiveInterval = maxAbsValue / 5; // Example positive interval
    double negativeInterval = minAbsValue / 5;

    return charts == null
        ? const SizedBox()
        : BarChart(
            BarChartData(
              maxY: double.parse("$maxAbsValue"),
              minY: charts?[0].operatingCashFlow1 == null
                  ? null
                  : -double.parse("$maxAbsValue"),
              titlesData: FlTitlesData(
                show: true,
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: bottomTitles,
                    reservedSize: 42,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    reservedSize: 42,
                    showTitles: true,
                    // Default value to avoid division by zero
                    interval: maxAbsValue / 5,
                    getTitlesWidget: (value, meta) {
                      // if (charts?[0].operatingCashFlow1 == null) {
                      //   String formattedValue = convertToReadableValue(value);
                      //   return Text(
                      //     formattedValue,
                      //     style: stylePTSansBold(fontSize: 9.sp),
                      //   );
                      // }

                      if (value == 0) {
                        String formattedValue = convertToReadableValue(0.0);
                        return Text(
                          formattedValue,
                          style: stylePTSansBold(fontSize: 9.sp),
                        );
                        // Return '0' for the axis origin
                      } else if (value > 0) {
                        int index = (value / positiveInterval).ceil();
                        String formattedValue = convertToReadableValue(
                            double.parse(
                                '+${index * positiveInterval.toInt()}'));
                        return Text(
                          formattedValue,
                          style: stylePTSansBold(fontSize: 9.sp),
                        );
                      } else {
                        int index = (value == 0 || negativeInterval == 0)
                            ? 0
                            : (value / negativeInterval).floor();
                        String formattedValue = convertToReadableValue(
                            double.parse(
                                '${index * negativeInterval.toInt()}'));
                        return Text(
                          formattedValue,
                          style: stylePTSansBold(fontSize: 9.sp),
                        ); // Negative values below axis
                      }
                    },
                  ),
                ),

                // rightTitles: AxisTitles(
                //   sideTitles: SideTitles(
                //     reservedSize: 52,
                //     showTitles: true,
                //     interval: maxValue / 5,
                //     getTitlesWidget: (value, meta) {
                //       return Text(
                //         convertDollarValue(
                //             double.parse(value.toStringAsFixed(1))),
                //         style: stylePTSansBold(fontSize: 9.sp),
                //       );
                //     },
                //   ),
                // ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: showingBarGroups,
              gridData: const FlGridData(show: false),
            ),
          );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    log("HERE WE ARE ==> $value  = ${meta.formattedValue}");
    final titles = charts?.map((chart) => chart.period ?? "").toList();

    // final titles = <String>[
    //   charts?[4].period ?? "",
    //   charts?[3].period ?? "",
    //   charts?[2].period ?? "",
    //   charts?[1].period ?? "",
    //   charts?[0].period ?? "",
    // ];

    final Widget text = Text(
      titles?[value.toInt()] ?? "",
      style: stylePTSansBold(
        color: ThemeColors.white,
        fontSize: 12,
        decoration: TextDecoration.none,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
          borderRadius: radius,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
          borderRadius: radius,
        ),
        BarChartRodData(
          toY: y3,
          color: widget.yellowBarColor,
          width: width,
          borderRadius: radius,
        ),
      ],
    );
  }

  // Widget makeTransactionsIcon() {
  //   const width = 4.5;
  //   const space = 3.5;
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: <Widget>[
  //       Container(
  //         width: width,
  //         height: 10,
  //         color: Colors.white.withOpacity(0.4),
  //       ),
  //       const SizedBox(
  //         width: space,
  //       ),
  //       Container(
  //         width: width,
  //         height: 28,
  //         color: Colors.white.withOpacity(0.8),
  //       ),
  //       const SizedBox(
  //         width: space,
  //       ),
  //       Container(
  //         width: width,
  //         height: 42,
  //         color: Colors.white.withOpacity(1),
  //       ),
  //       const SizedBox(
  //         width: space,
  //       ),
  //       Container(
  //         width: width,
  //         height: 28,
  //         color: Colors.white.withOpacity(0.8),
  //       ),
  //     ],
  //   );
  // }
}

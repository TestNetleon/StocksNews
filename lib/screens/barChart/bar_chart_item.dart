import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/stockDetailRes/financial.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';

class BarChartSample extends StatefulWidget {
  const BarChartSample({this.data, super.key});
  final SdFinancialRes? data;
  final Color leftBarColor = const Color.fromARGB(255, 7, 181, 255);
  final Color rightBarColor = ThemeColors.accent;
  final Color avgColor = Colors.orange;

  @override
  State<StatefulWidget> createState() => BarChartSampleState();
}

class BarChartSampleState extends State<BarChartSample> {
  final double width = 10.sp;
  final BorderRadius? radius = BorderRadius.all(Radius.circular(0.sp));

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

  void intFunction() {
    setState(() {});
    if (widget.data?.chart?[4].revenue != null) {
      BarChartGroupData barGroup1 = makeGroupData(
        0,
        (widget.data?.chart?[4].revenue == null ||
                (widget.data?.chart![4].revenue ?? 0) < 0)
            ? 0.0
            : double.parse("${widget.data?.chart?[4].revenue}"),
        widget.data?.chart?[4].netIncome == null ||
                (widget.data?.chart![4].netIncome ?? 0) < 0
            ? 0.0
            : double.parse("${widget.data?.chart![4].netIncome}"),
      );
      BarChartGroupData barGroup2 = makeGroupData(
          1,
          widget.data?.chart?[3].revenue == null ||
                  (widget.data?.chart![3].revenue ?? 0) < 0
              ? 0.0
              : double.parse("${widget.data?.chart?[3].revenue}"),
          widget.data?.chart?[3].netIncome == null ||
                  (widget.data?.chart![3].netIncome ?? 0) < 0
              ? 0.0
              : double.parse("${widget.data?.chart![3].netIncome}"));
      BarChartGroupData barGroup3 = makeGroupData(
          2,
          widget.data?.chart?[2].revenue == null ||
                  (widget.data?.chart![2].revenue ?? 0) < 0
              ? 0.0
              : double.parse("${widget.data?.chart?[2].revenue}"),
          widget.data?.chart?[2].netIncome == null ||
                  (widget.data?.chart![2].netIncome ?? 0) < 0
              ? 0.0
              : double.parse("${widget.data?.chart![2].netIncome}"));
      BarChartGroupData barGroup4 = makeGroupData(
          3,
          widget.data?.chart?[1].revenue == null ||
                  (widget.data?.chart![1].revenue ?? 0) < 0
              ? 0.0
              : double.parse("${widget.data?.chart?[1].revenue}"),
          widget.data?.chart?[1].netIncome == null ||
                  (widget.data?.chart![1].netIncome ?? 0) < 0
              ? 0.0
              : double.parse("${widget.data?.chart![1].netIncome}"));
      BarChartGroupData barGroup5 = makeGroupData(
          4,
          widget.data?.chart?[0].revenue == null ||
                  (widget.data?.chart![0].revenue ?? 0) < 0
              ? 0.0
              : double.parse("${widget.data?.chart?[0].revenue}"),
          widget.data?.chart?[0].netIncome == null ||
                  (widget.data?.chart![0].netIncome ?? 0) < 0
              ? 0.0
              : double.parse("${widget.data?.chart![0].netIncome}"));
      final items = [
        barGroup1,
        barGroup2,
        barGroup3,
        barGroup4,
        barGroup5,
      ];
      rawBarGroups = items;

      showingBarGroups = rawBarGroups;
      final maxRevenue = widget.data?.chart?.isNotEmpty == true
          ? widget.data!.chart!
              .map((e) => e.revenue)
              .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
          : 0;
      final maxNetIncome = widget.data?.chart?.isNotEmpty == true
          ? widget.data?.chart
              ?.map((e) => e.netIncome)
              .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
          : 0;
      maxAbsValue = (maxRevenue! > maxNetIncome!) ? maxRevenue : maxNetIncome;
      setState(() {});
    }
    if (widget.data?.chart?[4].totalAssets != null) {
      BarChartGroupData barGroup1 = makeGroupData(
          0,
          (widget.data?.chart?[4].totalAssets == null ||
                  (widget.data?.chart?[4].totalAssets ?? 0) < 0)
              ? 0.0
              : double.parse("${widget.data?.chart?[4].totalAssets}"),
          widget.data?.chart?[4].totalLiabilities == null ||
                  (widget.data?.chart?[4].totalLiabilities ?? 0) < 0
              ? 0.0
              : double.parse("${widget.data?.chart![4].totalLiabilities}"));
      BarChartGroupData barGroup2 = makeGroupData(
          1,
          widget.data?.chart?[3].totalAssets == null ||
                  (widget.data?.chart?[3].totalAssets ?? 0) < 0
              ? 0.0
              : double.parse("${widget.data?.chart?[3].totalAssets}"),
          widget.data?.chart?[3].totalLiabilities == null ||
                  (widget.data?.chart?[3].totalLiabilities ?? 0) < 0
              ? 0.0
              : double.parse("${widget.data?.chart![3].totalLiabilities}"));
      BarChartGroupData barGroup3 = makeGroupData(
          2,
          widget.data?.chart?[2].totalAssets == null ||
                  (widget.data?.chart?[2].totalAssets ?? 0) < 0
              ? 0.0
              : double.parse("${widget.data?.chart?[2].totalAssets}"),
          widget.data?.chart?[2].totalLiabilities == null ||
                  (widget.data?.chart?[2].totalLiabilities ?? 0) < 0
              ? 0.0
              : double.parse("${widget.data?.chart![2].totalLiabilities}"));
      BarChartGroupData barGroup4 = makeGroupData(
          3,
          widget.data?.chart?[1].totalAssets == null ||
                  (widget.data?.chart?[1].totalAssets ?? 0) < 0
              ? 0.0
              : double.parse("${widget.data?.chart?[1].totalAssets}"),
          widget.data?.chart?[1].totalLiabilities == null ||
                  (widget.data?.chart?[1].totalLiabilities ?? 0) < 0
              ? 0.0
              : double.parse("${widget.data?.chart![1].totalLiabilities}"));
      BarChartGroupData barGroup5 = makeGroupData(
          4,
          widget.data?.chart?[0].totalAssets == null ||
                  (widget.data?.chart?[0].totalAssets ?? 0) < 0
              ? 0.0
              : double.parse("${widget.data?.chart?[0].totalAssets}"),
          widget.data?.chart?[0].totalLiabilities == null ||
                  (widget.data?.chart?[0].totalLiabilities ?? 0) < 0
              ? 0.0
              : double.parse("${widget.data?.chart![0].totalLiabilities}"));
      final items = [
        barGroup1,
        barGroup2,
        barGroup3,
        barGroup4,
        barGroup5,
      ];
      rawBarGroups = items;

      showingBarGroups = rawBarGroups;
      final maxRevenue = widget.data?.chart?.isNotEmpty == true
          ? widget.data!.chart!
              .map((e) => e.totalAssets)
              .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
          : 0;
      final maxNetIncome = widget.data?.chart?.isNotEmpty == true
          ? widget.data?.chart
              ?.map((e) => e.totalLiabilities)
              .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
          : 0;
      maxAbsValue = (maxRevenue! > maxNetIncome!) ? maxRevenue : maxNetIncome;
      setState(() {});
    }
    if (widget.data?.chart?[4].operatingCashFlow1 != null) {
      BarChartGroupData barGroup1 = makeGroupData(
          0,
          (widget.data?.chart?[4].operatingCashFlow1 == null)
              ? 0.0
              : double.parse("${widget.data?.chart?[4].operatingCashFlow1}"),
          widget.data?.chart?[4].operatingCashFlow2 == null
              ? 0.0
              : double.parse("${widget.data?.chart![4].operatingCashFlow2}"));
      BarChartGroupData barGroup2 = makeGroupData(
          1,
          widget.data?.chart?[3].operatingCashFlow1 == null
              ? 0.0
              : double.parse("${widget.data?.chart?[3].operatingCashFlow1}"),
          widget.data?.chart?[3].operatingCashFlow2 == null
              ? 0.0
              : double.parse("${widget.data?.chart![3].operatingCashFlow2}"));
      BarChartGroupData barGroup3 = makeGroupData(
          2,
          widget.data?.chart?[2].operatingCashFlow1 == null
              ? 0.0
              : double.parse("${widget.data?.chart?[2].operatingCashFlow1}"),
          widget.data?.chart?[2].operatingCashFlow2 == null
              ? 0.0
              : double.parse("${widget.data?.chart![2].operatingCashFlow2}"));
      BarChartGroupData barGroup4 = makeGroupData(
          3,
          widget.data?.chart?[1].operatingCashFlow1 == null
              ? 0.0
              : double.parse("${widget.data?.chart?[1].operatingCashFlow1}"),
          widget.data?.chart?[1].operatingCashFlow2 == null
              ? 0.0
              : double.parse("${widget.data?.chart![1].operatingCashFlow2}"));
      BarChartGroupData barGroup5 = makeGroupData(
          4,
          widget.data?.chart?[0].operatingCashFlow1 == null
              ? 0.0
              : double.parse("${widget.data?.chart?[0].operatingCashFlow1}"),
          widget.data?.chart?[0].operatingCashFlow2 == null
              ? 0.0
              : double.parse("${widget.data?.chart![0].operatingCashFlow2}"));
      final items = [
        barGroup1,
        barGroup2,
        barGroup3,
        barGroup4,
        barGroup5,
      ];
      rawBarGroups = items;

      showingBarGroups = rawBarGroups;
      // final maxRevenue = widget.data?.chart?.isNotEmpty == true
      //     ? widget.data!.chart!
      //         .map((e) => e.operatingCashFlow1)
      //         .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
      //     : 0;
      // final maxNetIncome = widget.data?.chart?.isNotEmpty == true
      //     ? widget.data?.chart
      //         ?.map((e) => e.operatingCashFlow2)
      //         .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
      //     : 0;
      // maxValue = (maxRevenue! > maxNetIncome!) ? maxRevenue : maxNetIncome;

      // final minRevenue = widget.data?.chart?.isNotEmpty == true
      //     ? widget.data!.chart!
      //         .map((e) => e.operatingCashFlow1)
      //         .reduce((a, b) => a!.abs() < b!.abs() ? a : b)
      //     : 0;

      // final minNetIncome = widget.data?.chart?.isNotEmpty == true
      //     ? widget.data?.chart
      //         ?.map((e) => e.operatingCashFlow2)
      //         .reduce((a, b) => a!.abs() < b!.abs() ? a : b)
      //     : 0;

      // minValue = (minRevenue! < minNetIncome!) ? minRevenue : minNetIncome;
      final maxRevenue = widget.data?.chart?.isNotEmpty == true
          ? widget.data!.chart!
              .map((e) => e.operatingCashFlow1)
              .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
          : 0;
      final maxNetIncome = widget.data?.chart?.isNotEmpty == true
          ? widget.data?.chart
              ?.map((e) => e.operatingCashFlow2)
              .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
          : 0;
      maxValue =
          (maxRevenue!.abs() > maxNetIncome!.abs()) ? maxRevenue : maxNetIncome;

      // final minRevenue = widget.data?.chart?.isNotEmpty == true
      //     ? widget.data!.chart!
      //         .map((e) => e.operatingCashFlow1)
      //         .where((e) => e != null)
      //         .reduce((a, b) => a!.abs() < b!.abs() ? a : b)
      //     : 0;
      // final minNetIncome = widget.data?.chart?.isNotEmpty == true
      //     ? widget.data?.chart
      //         ?.map((e) => e.operatingCashFlow2)
      //         .where((e) => e != null)
      //         .reduce((a, b) => a!.abs() < b!.abs() ? a : b)
      //     : 0;
      // minValue = (minRevenue != null && minNetIncome != null)
      //     ? (minRevenue.abs() < minNetIncome.abs() ? minRevenue : minNetIncome)
      //     : 0;
      // minAbsValue = (minRevenue != null && minNetIncome != null)
      //     ? (minRevenue.abs() < minNetIncome.abs()
      //         ? minRevenue.abs()
      //         : minNetIncome.abs())
      //     : 0;
      final minRevenue = widget.data?.chart?.isNotEmpty == true
          ? widget.data!.chart!
              .map((e) => e.operatingCashFlow1)
              .where((e) => e != null && e < 0) // Filter only negative values
              .reduce(
                  (a, b) => a! < b! ? a : b) // Find the minimum negative value
          : null;

      final minNetIncome = widget.data?.chart?.isNotEmpty == true
          ? widget.data!.chart!
              .map((e) => e.operatingCashFlow2)
              .where((e) => e != null && e < 0) // Filter only negative values
              .reduce(
                  (a, b) => a! < b! ? a : b) // Find the minimum negative value
          : null;

      minAbsValue = (minRevenue != null && minNetIncome != null)
          ? (minRevenue.abs() < minNetIncome.abs() ? minRevenue : minNetIncome)
          : 0;

      maxAbsValue = (maxRevenue.abs() > maxNetIncome.abs())
          ? maxRevenue.abs()
          : maxNetIncome.abs();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // intFunction();
    double positiveInterval = maxAbsValue / 5; // Example positive interval
    double negativeInterval = minAbsValue / 5;

    return widget.data?.chart == null
        ? const SizedBox()
        : BarChart(
            BarChartData(
              maxY: double.parse("$maxAbsValue"),
              minY: widget.data?.chart?[0].operatingCashFlow1 == null
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
                    reservedSize: 52,
                    showTitles: true,
                    interval: maxAbsValue /
                        5, // Default value to avoid division by zero
                    getTitlesWidget: (value, meta) {
                      if (widget.data?.chart?[4].operatingCashFlow1 == null) {
                        String formattedValue = convertToReadableValue(value);
                        return Text(
                          formattedValue,
                          style: stylePTSansBold(fontSize: 9.sp),
                        );
                      }

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
                        int index = (value / negativeInterval).floor();
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
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: showingBarGroups,
              gridData: const FlGridData(show: false),
            ),
          );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>[
      widget.data?.chart?[4].period ?? "",
      widget.data?.chart?[3].period ?? "",
      widget.data?.chart?[2].period ?? "",
      widget.data?.chart?[1].period ?? "",
      widget.data?.chart?[0].period ?? "",
    ];

    final Widget text = Text(
      titles[value.toInt()],
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

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
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
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
      ],
    );
  }
}

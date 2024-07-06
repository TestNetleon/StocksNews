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

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;
  int maxValue = 0;
  int minValue = 0;
  int maxAbsValue = 0;
  int minAbsValue = 0;

  bool valueNegative = true;
  List<Chart>? charts;
  List<Chart>? chartsPlaceHolder;

  @override
  void initState() {
    super.initState();
    intFunction();
  }

  void intFunction() {
    charts = widget.data?.chart?.sublist(0, 5);
    if (charts != null) chartsPlaceHolder = charts;

    setState(() {});

    if (charts?[4].operatingCashFlow1 != null) {
      BarChartGroupData barGroup1 = makeGroupData(
          0,
          (charts?[4].operatingCashFlow1 == null)
              ? 0.0
              : double.parse("${charts?[4].operatingCashFlow1}"),
          charts?[4].operatingCashFlow2 == null
              ? 0.0
              : double.parse("${charts![4].operatingCashFlow2}"),
          charts?[4].operatingCashFlow3 == null
              ? 0.0
              : double.parse("${charts![4].operatingCashFlow3}")); // ww
      BarChartGroupData barGroup2 = makeGroupData(
          1,
          charts?[3].operatingCashFlow1 == null
              ? 0.0
              : double.parse("${charts?[3].operatingCashFlow1}"),
          charts?[3].operatingCashFlow2 == null
              ? 0.0
              : double.parse("${charts![3].operatingCashFlow2}"),
          charts?[3].operatingCashFlow3 == null
              ? 0.0
              : double.parse("${charts![3].operatingCashFlow3}"));
      BarChartGroupData barGroup3 = makeGroupData(
          2,
          charts?[2].operatingCashFlow1 == null
              ? 0.0
              : double.parse("${charts?[2].operatingCashFlow1}"),
          charts?[2].operatingCashFlow2 == null
              ? 0.0
              : double.parse("${charts![2].operatingCashFlow2}"),
          charts?[2].operatingCashFlow3 == null
              ? 0.0
              : double.parse("${charts![2].operatingCashFlow3}"));
      BarChartGroupData barGroup4 = makeGroupData(
          3,
          charts?[1].operatingCashFlow1 == null
              ? 0.0
              : double.parse("${charts?[1].operatingCashFlow1}"),
          charts?[1].operatingCashFlow2 == null
              ? 0.0
              : double.parse("${charts![1].operatingCashFlow2}"),
          charts?[1].operatingCashFlow3 == null
              ? 0.0
              : double.parse("${charts![1].operatingCashFlow3}"));
      BarChartGroupData barGroup5 = makeGroupData(
          4,
          charts?[0].operatingCashFlow1 == null
              ? 0.0
              : double.parse("${charts?[0].operatingCashFlow1}"),
          charts?[0].operatingCashFlow2 == null
              ? 0.0
              : double.parse("${charts![0].operatingCashFlow2}"),
          charts?[0].operatingCashFlow3 == null
              ? 0.0
              : double.parse("${charts![0].operatingCashFlow3}"));
      final items = [
        barGroup1,
        barGroup2,
        barGroup3,
        barGroup4,
        barGroup5,
      ];
      rawBarGroups = items;

      showingBarGroups = rawBarGroups;

      final maxRevenue = charts?.isNotEmpty == true
          ? widget.data!.chart!
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

      final minRevenue = (charts?.isNotEmpty == true &&
              widget.data?.chart != null &&
              widget.data!.chart!.any((e) =>
                  e.operatingCashFlow1 != null && e.operatingCashFlow1! < 0))
          ? widget.data!.chart!
              .map((e) => e.operatingCashFlow1)
              .where((e) => e != null && e < 0) // Filter only negative values
              .reduce(
                  (a, b) => a! < b! ? a : b) // Find the minimum negative value
          : null;

      final minNetIncome = (charts?.isNotEmpty == true &&
              widget.data?.chart != null &&
              widget.data!.chart!.any((e) =>
                  e.operatingCashFlow2 != null && e.operatingCashFlow2! < 0))
          ? widget.data!.chart!
              .map((e) => e.operatingCashFlow2)
              .where((e) => e != null && e < 0) // Filter only negative values
              .reduce(
                  (a, b) => a! < b! ? a : b) // Find the minimum negative value
          : null;
      final minNetFin = (charts?.isNotEmpty == true &&
              widget.data?.chart != null &&
              widget.data!.chart!.any((e) =>
                  e.operatingCashFlow3 != null && e.operatingCashFlow3! < 0))
          ? widget.data!.chart!
              .map((e) => e.operatingCashFlow3)
              .where((e) => e != null && e < 0) // Filter only negative values
              .reduce(
                  (a, b) => a! < b! ? a : b) // Find the minimum negative value
          : null;

      final minAbsValueItem = (minRevenue != null && minNetIncome != null)
          ? (minRevenue.abs() < minNetIncome.abs() ? minRevenue : minNetIncome)
          : 0;
      minAbsValue = (minNetFin != null)
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
    }
  }

  @override
  Widget build(BuildContext context) {
    intFunction();
// Example positive interval

    return chartsPlaceHolder == null
        ? Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ThemeColors.blackShade,
            ),
            height: 200,
          )
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
                    interval: maxAbsValue /
                        2, // Default value to avoid division by zero
                    getTitlesWidget: (value, meta) {
                      // if (charts?[4].operatingCashFlow1 == null) {
                      String formattedValue = convertToReadableValue(value);
                      return Text(
                        formattedValue,
                        style: stylePTSansBold(fontSize: 9.sp),
                      );
                      // }

                      // if (value == 0) {
                      //   String formattedValue = convertToReadableValue(0.0);
                      //   return Text(
                      //     formattedValue,
                      //     style: stylePTSansBold(fontSize: 9.sp),
                      //   );
                      //   // Return '0' for the axis origin
                      // } else if (value > 0) {
                      //   int index = (value / positiveInterval).ceil();
                      //   String formattedValue = convertToReadableValue(
                      //       double.parse(
                      //           '+${index * positiveInterval.toInt()}'));
                      //   return Text(
                      //     formattedValue,
                      //     style: stylePTSansBold(fontSize: 9.sp),
                      //   );
                      // } else if (value < 0) {
                      //   int index = (value / negativeInterval).floor();
                      //   String formattedValue = convertToReadableValue(
                      //       double.parse(
                      //           '${index * negativeInterval.toInt()}'));
                      //   return Text(
                      //     formattedValue,
                      //     style: stylePTSansBold(fontSize: 9.sp),
                      //   ); // Negative values below axis
                      // } else {
                      //   // Handle the case where value is exactly 0 if needed
                      //   return Text(
                      //     '0',
                      //     style: stylePTSansBold(fontSize: 9.sp),
                      //   );
                      // }
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
      charts?[4].period ?? "",
      charts?[3].period ?? "",
      charts?[2].period ?? "",
      charts?[1].period ?? "",
      charts?[0].period ?? "",
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

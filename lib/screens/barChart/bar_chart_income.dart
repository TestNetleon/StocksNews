import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/stockDetailRes/financial.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';

class BarChartIncome extends StatefulWidget {
  const BarChartIncome({this.data, super.key});
  final SdFinancialRes? data;
  final Color leftBarColor = const Color.fromARGB(255, 7, 181, 255);
  final Color rightBarColor = ThemeColors.accent;
  final Color avgColor = Colors.orange;

  @override
  State<StatefulWidget> createState() => BarChartIncomeState();
}

class BarChartIncomeState extends State<BarChartIncome> {
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

    setState(() {});
    if (charts?[4].revenue != null) {
      BarChartGroupData barGroup1 = makeGroupData(
        0,
        (charts?[4].revenue == null || (charts![4].revenue ?? 0) < 0)
            ? 0.0
            : double.parse("${charts?[4].revenue}"),
        charts?[4].netIncome == null || (charts![4].netIncome ?? 0) < 0
            ? 0.0
            : double.parse("${charts![4].netIncome}"),
      );
      BarChartGroupData barGroup2 = makeGroupData(
          1,
          charts?[3].revenue == null || (charts![3].revenue ?? 0) < 0
              ? 0.0
              : double.parse("${charts?[3].revenue}"),
          charts?[3].netIncome == null || (charts![3].netIncome ?? 0) < 0
              ? 0.0
              : double.parse("${charts![3].netIncome}"));
      BarChartGroupData barGroup3 = makeGroupData(
          2,
          charts?[2].revenue == null || (charts![2].revenue ?? 0) < 0
              ? 0.0
              : double.parse("${charts?[2].revenue}"),
          charts?[2].netIncome == null || (charts![2].netIncome ?? 0) < 0
              ? 0.0
              : double.parse("${charts![2].netIncome}"));
      BarChartGroupData barGroup4 = makeGroupData(
          3,
          charts?[1].revenue == null || (charts![1].revenue ?? 0) < 0
              ? 0.0
              : double.parse("${charts?[1].revenue}"),
          charts?[1].netIncome == null || (charts![1].netIncome ?? 0) < 0
              ? 0.0
              : double.parse("${charts![1].netIncome}"));
      BarChartGroupData barGroup5 = makeGroupData(
          4,
          charts?[0].revenue == null || (charts![0].revenue ?? 0) < 0
              ? 0.0
              : double.parse("${charts?[0].revenue}"),
          charts?[0].netIncome == null || (charts![0].netIncome ?? 0) < 0
              ? 0.0
              : double.parse("${charts![0].netIncome}"));
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
              .map((e) => e.revenue)
              .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
          : 0;
      final maxNetIncome = charts?.isNotEmpty == true
          ? charts
              ?.map((e) => e.netIncome)
              .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
          : 0;
      maxAbsValue = (maxRevenue! > maxNetIncome!) ? maxRevenue : maxNetIncome;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    intFunction();
    double positiveInterval = maxAbsValue / 5; // Example positive interval
    double negativeInterval = minAbsValue / 5;

    return charts == null
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
                      if (charts?[4].operatingCashFlow1 == null) {
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

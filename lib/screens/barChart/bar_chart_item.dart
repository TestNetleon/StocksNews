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
  List<Chart>? charts;

  @override
  void initState() {
    super.initState();
    intFunction();
  }

  void intFunction() {
    if ((widget.data?.chart?.length ?? 0) < 5) {
      charts = widget.data?.chart?.sublist(0, widget.data?.chart?.length);
    } else {
      charts = widget.data?.chart?.sublist(0, 5);
    }

    setState(() {});

    List<BarChartGroupData> items = [];

    for (int i = charts!.length - 1; i >= 0; i--) {
      double totalAssets = (charts?[i].totalAssets == null)
          ? 0.0
          : double.parse("${charts?[i].totalAssets}");
      double totalLiabilities = (charts?[i].totalLiabilities == null)
          ? 0.0
          : double.parse("${charts![i].totalLiabilities}");

      BarChartGroupData barGroup =
          makeGroupData(i, totalAssets, totalLiabilities);
      items.add(barGroup);
    }

    rawBarGroups = items;
    showingBarGroups = rawBarGroups;
    Utils().showLog("showingBarGroups  === $showingBarGroups");

    final maxTotalAssets = charts?.isNotEmpty == true
        ? charts!
            .map((e) => e.totalAssets)
            .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
        : 0;
    final maxTotalLiabilities = charts?.isNotEmpty == true
        ? charts
            ?.map((e) => e.totalLiabilities)
            .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
        : 0;
    final minTotalAssets = (charts?.isNotEmpty == true &&
            widget.data?.chart != null &&
            widget.data!.chart!
                .any((e) => e.totalAssets != null && e.totalAssets! < 0))
        ? widget.data!.chart!
            .map((e) => e.totalAssets)
            .where((e) => e != null && e < 0) // Filter only negative values
            .reduce(
                (a, b) => a! < b! ? a : b) // Find the minimum negative value
        : null;
    final minTotalLiabilities = (charts?.isNotEmpty == true &&
            widget.data?.chart != null &&
            widget.data!.chart!.any(
                (e) => e.totalLiabilities != null && e.totalLiabilities! < 0))
        ? widget.data!.chart!
            .map((e) => e.totalLiabilities)
            .where((e) => e != null && e < 0) // Filter only negative values
            .reduce(
                (a, b) => a! < b! ? a : b) // Find the minimum negative value
        : null;
    minAbsValue = (minTotalAssets != null && minTotalLiabilities != null)
        ? (minTotalAssets.abs() < minTotalLiabilities.abs()
            ? minTotalAssets
            : minTotalLiabilities)
        : 0;
    maxAbsValue = (maxTotalAssets!.abs() > maxTotalLiabilities!.abs())
        ? maxTotalAssets.abs()
        : maxTotalLiabilities.abs();

    // minAbsValue = minAbsValueItem;
    // maxAbsValue = (maxRevenue! > maxNetIncome!) ? maxRevenue : maxNetIncome;

    setState(() {});
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
              minY: minAbsValue == 0 ? null : -double.parse("$maxAbsValue"),
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
                      if (charts?[0].operatingCashFlow1 == null) {
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
    List<String> titles = <String>[];

    // Ensure 'charts' is not null and has elements
    if (charts != null && charts!.isNotEmpty) {
      // Iterate over 'charts' from end to start
      for (int i = charts!.length - 1; i >= 0; i--) {
        if (charts![i].period != null) {
          titles.add(charts![i].period!);
        }
      }

      // Reverse the titles list
      titles = titles.reversed.toList();
    }

    // Check if value is within the range of titles
    if (value.toInt() >= 0 && value.toInt() < titles.length) {
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
        space: 16, // margin top
        child: text,
      );
    }

    return Container();
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
}

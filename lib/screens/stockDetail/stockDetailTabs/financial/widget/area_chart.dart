import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/financial.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';

import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/financial/widget/arer_chart_top_widget.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class IncomeAreaChart extends StatefulWidget {
  const IncomeAreaChart({super.key});

  @override
  State<IncomeAreaChart> createState() => _IncomeAreaChartState();
}

class _IncomeAreaChartState extends State<IncomeAreaChart> {
  double? minAbsValue;
  double? maxAbsValue;
  dynamic maxPeriod;
  dynamic minPeriod;
  List<Chart>? data;
  dynamic minRevenue;

  dynamic minNetIncome;
  dynamic minEbitda;

  @override
  void initState() {
    super.initState();

    StockDetailProviderNew provider = context.read<StockDetailProviderNew>();
    data = provider.sdFinancialChartRes?.chart;
    if (data!.length < 10) {
      provider.changeTabAreaIncomeTenInt("1", data);
    } else {
      provider.changeTabAreaIncomeTen("1", data);
    }

    final maxRevenue = provider.areaIncomeChart?.isNotEmpty == true
        ? provider.areaIncomeChart!
            .map((e) => e.revenue)
            .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
        : 0;
    final maxNetIncome = provider.areaIncomeChart?.isNotEmpty == true
        ? provider.areaIncomeChart!
            .map((e) => e.netIncome)
            .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
        : 0;
    final maxEbitda = provider.areaIncomeChart?.isNotEmpty == true
        ? provider.areaIncomeChart!
            .map((e) => e.ebitda)
            .reduce((a, b) => a!.abs() > b!.abs() ? a : b)
        : 0;

    minRevenue = (provider.areaIncomeChart?.isNotEmpty == true &&
            provider.areaIncomeChart != null &&
            provider.areaIncomeChart!
                .any((e) => e.revenue != null && e.revenue! < 0))
        ? provider.areaIncomeChart!
            .map((e) => e.revenue)
            .where((e) => e != null && e < 0) // Filter only negative values
            .reduce(
                (a, b) => a! < b! ? a : b) // Find the minimum negative value
        : null;

    minNetIncome = (provider.areaIncomeChart?.isNotEmpty == true &&
            provider.areaIncomeChart != null &&
            provider.areaIncomeChart!
                .any((e) => e.netIncome != null && e.netIncome! < 0))
        ? provider.areaIncomeChart!
            .map((e) => e.netIncome)
            .where((e) => e != null && e < 0) // Filter only negative values
            .reduce(
                (a, b) => a! < b! ? a : b) // Find the minimum negative value
        : null;
    minEbitda = (provider.areaIncomeChart?.isNotEmpty == true &&
            provider.areaIncomeChart != null &&
            provider.areaIncomeChart!
                .any((e) => e.ebitda != null && e.ebitda! < 0))
        ? provider.areaIncomeChart!
            .map((e) => e.ebitda)
            .where((e) => e != null && e < 0) // Filter only negative values
            .reduce(
                (a, b) => a! < b! ? a : b) // Find the minimum negative value
        : null;
    setState(() {});

    final maxAbsValueItem = (maxRevenue.abs() > maxNetIncome.abs())
        ? maxRevenue.abs()
        : maxNetIncome.abs();
    final maxAbsValueValue = (maxAbsValueItem.abs() > maxEbitda.abs())
        ? maxAbsValueItem.abs()
        : maxEbitda.abs();

    maxAbsValue = double.parse("$maxAbsValueValue");

    final minAbsValueItem = (minRevenue != null && minNetIncome != null)
        ? (minRevenue.abs() < minNetIncome.abs() ? minRevenue : minNetIncome)
        : 0;
    final minAbsValueValue = (minEbitda != null)
        ? (minAbsValueItem.abs() < minEbitda.abs()
            ? minAbsValueItem
            : minEbitda)
        : 0;
    minAbsValue = double.parse(
        "${min(double.parse("${minRevenue ?? 0.0}"), min(double.parse("${minNetIncome ?? 0.0}"), double.parse("${minEbitda ?? 0.0}")))}");
    final maxPeriodItem = provider.areaIncomeChart?.isNotEmpty == true
        ? provider.areaIncomeChart!
            .map((e) => int.tryParse(e.period) ?? 0)
            .reduce((a, b) => a.abs() > b.abs() ? a : b)
        : 0;

    final minPeriodItem = provider.areaIncomeChart?.isNotEmpty == true
        ? provider.areaIncomeChart!
            .map((e) => int.tryParse(e.period) ?? 0)
            .reduce((a, b) => a.abs() < b.abs() ? a : b)
        : 0;
    maxPeriod = double.parse("$maxPeriodItem");
    minPeriod = double.parse("$minPeriodItem");

    setState(() {});
    Utils().showLog('Error initializing Firebase12: $minAbsValueValue');
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    data = provider.sdFinancialChartRes?.chart;

    List<FlSpot> generateSpots(List<Chart>? financialData) {
      return financialData!
          .map((data) => FlSpot(
              double.parse("${data.period}"), double.parse("${data.revenue}")))
          .toList();
    }

    List<Chart>? financialData = data != null ? provider.areaIncomeChart : [];
    List<FlSpot> spots1 = generateSpots(financialData);

    List<FlSpot> generateSpotsTwo(List<Chart>? financialData) {
      return financialData!
          .map((data) => FlSpot(double.parse("${data.period}"),
              double.parse("${data.netIncome}")))
          .toList();
    }

    List<Chart>? financialDataTwo =
        data != null ? provider.areaIncomeChart : [];
    List<FlSpot> spotsTwo = generateSpotsTwo(financialDataTwo);

    List<FlSpot> generateSpotsEbitda(List<Chart>? financialData) {
      return financialData!
          .map((data) => FlSpot(
              double.parse("${data.period}"), double.parse("${data.ebitda}")))
          .toList();
    }

    List<Chart>? financialDataEbitda =
        data != null ? provider.areaIncomeChart : [];
    List<FlSpot> spotsEbitda = generateSpotsEbitda(financialDataEbitda);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(
              Dimen.padding, Dimen.padding, Dimen.padding, 0),
          child: AreaChartTopWidget(),
        ),
        const SpacerVertical(height: 20),
        SizedBox(
          height: 200,
          child: Stack(
            children: [
              LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots1,
                      isCurved: true,
                      color: const Color(0xff008aff),
                      barWidth: 1,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(146, 33, 149, 243),
                            Color.fromARGB(136, 98, 178, 244),
                            Color.fromARGB(148, 235, 242, 248),
                          ],

                          stops: [
                            0.0,
                            0.5,
                            1.0
                          ], // Position stops for the gradient colors
                        ),
                      ),
                      dotData: const FlDotData(show: false),
                      preventCurveOverShooting: true,
                    ),
                    LineChartBarData(
                      preventCurveOverShooting: true,
                      spots: spotsEbitda,
                      isCurved: true,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(160, 122, 213, 37),
                            Color.fromARGB(103, 122, 213, 37),
                            Color.fromARGB(60, 122, 213, 37),
                          ],
                        ),
                      ),
                      color: const Color(0xff76d123),
                      barWidth: 1,
                      dotData: const FlDotData(
                        show: false,
                      ),
                    ),
                    LineChartBarData(
                      preventCurveOverShooting: true,
                      spots: spotsTwo,
                      isCurved: true,
                      color: const Color(0xfff34e8b),
                      barWidth: 2,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(142, 242, 76, 137),
                            Color.fromARGB(91, 242, 76, 137),
                            Color.fromARGB(43, 242, 76, 137),
                          ],
                        ),
                      ),
                      dotData: const FlDotData(
                        show: false,
                      ),
                    ),
                  ],
                  gridData: FlGridData(
                    show: false,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(
                        color: Color(0xffe7e8ec),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      drawBelowEverything: true,
                      sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: bottomTitles,
                          reservedSize: 42),
                    ),
                  ),
                  minX: minPeriod,
                  maxX: maxPeriod,
                  minY:
                      minAbsValue == 0.0 ? null : double.parse("$minAbsValue"),
                  maxY: double.parse("$maxAbsValue"),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipHorizontalOffset: 0,
                      showOnTopOfTheChartBoxArea: true,
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      tooltipRoundedRadius: 8,
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            '${spot.x.toInt()}',
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                    handleBuiltInTouches:
                        true, // Disable built-in touch handling
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    convertToReadableValue(
                        double.parse("${maxAbsValue ?? 0.0}")),
                    style: stylePTSansBold(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20, right: 10),
                  child: Text(
                    convertToReadableValue(min(
                        double.parse("${minRevenue ?? 0.0}"),
                        min(double.parse("${minNetIncome ?? 0.0}"),
                            double.parse("${minEbitda ?? 0.0}")))),
                    style: stylePTSansBold(),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SpacerVertical(height: 20),
        Container(
          decoration: BoxDecoration(
            color: ThemeColors.greyBorder.withOpacity(0.4),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  StockDetailProviderNew provider =
                      context.read<StockDetailProviderNew>();
                  data = provider.sdFinancialChartRes?.chart;
                  if (data == null) return;

                  if (data!.length < 10) {
                    provider.changeTabAreaIncomeTenInt("1", data);
                    final maxPeriodItem = data?.isNotEmpty == true
                        ? data!
                            .map((e) => int.tryParse(e.period) ?? 0)
                            .reduce((a, b) => a.abs() > b.abs() ? a : b)
                        : 0;

                    final minPeriodItem = data?.isNotEmpty == true
                        ? data!
                            .map((e) => int.tryParse(e.period) ?? 0)
                            .reduce((a, b) => a.abs() < b.abs() ? a : b)
                        : 0;
                    maxPeriod = double.parse("$maxPeriodItem");
                    minPeriod = double.parse("$minPeriodItem");
                  } else {
                    provider.changeTabAreaIncomeTen("1", data);
                    final maxPeriodItem =
                        provider.areaIncomeChart?.isNotEmpty == true
                            ? provider.areaIncomeChart!
                                .map((e) => int.tryParse(e.period) ?? 0)
                                .reduce((a, b) => a.abs() > b.abs() ? a : b)
                            : 0;

                    final minPeriodItem =
                        provider.areaIncomeChart?.isNotEmpty == true
                            ? provider.areaIncomeChart!
                                .map((e) => int.tryParse(e.period) ?? 0)
                                .reduce((a, b) => a.abs() < b.abs() ? a : b)
                            : 0;
                    maxPeriod = double.parse("$maxPeriodItem");
                    minPeriod = double.parse("$minPeriodItem");
                  }

                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: provider.changeTabAreaValue == "1"
                        ? ThemeColors.accent
                        : Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Text(
                    "10Y",
                    style: stylePTSansBold(fontSize: 12),
                  ),
                ),
              ),
              const SpacerHorizontal(width: 10),
              GestureDetector(
                onTap: () {
                  StockDetailProviderNew provider =
                      context.read<StockDetailProviderNew>();
                  data = provider.sdFinancialChartRes?.chart;

                  if (data == null) return;

                  if (data!.length < 6) {
                    provider.changeTabAreaIncomeTenInt("0", data);
                    final maxPeriodItem = data?.isNotEmpty == true
                        ? data!
                            .map((e) => int.tryParse(e.period) ?? 0)
                            .reduce((a, b) => a.abs() > b.abs() ? a : b)
                        : 0;

                    final minPeriodItem = data?.isNotEmpty == true
                        ? data!
                            .map((e) => int.tryParse(e.period) ?? 0)
                            .reduce((a, b) => a.abs() < b.abs() ? a : b)
                        : 0;
                    maxPeriod = double.parse("$maxPeriodItem");
                    minPeriod = double.parse("$minPeriodItem");
                  } else {
                    provider.changeTabAreaIncomeSix("0", data);
                    final maxPeriodItem =
                        provider.areaIncomeChart?.isNotEmpty == true
                            ? provider.areaIncomeChart!
                                .map((e) => int.tryParse(e.period) ?? 0)
                                .reduce((a, b) => a.abs() > b.abs() ? a : b)
                            : 0;

                    final minPeriodItem =
                        provider.areaIncomeChart?.isNotEmpty == true
                            ? provider.areaIncomeChart!
                                .map((e) => int.tryParse(e.period) ?? 0)
                                .reduce((a, b) => a.abs() < b.abs() ? a : b)
                            : 0;
                    maxPeriod = double.parse("$maxPeriodItem");
                    minPeriod = double.parse("$minPeriodItem");
                  }

                  setState(() {});

                  Utils().showLog('Error initializing Firebase: $data');
                  // provider.changeTabAreaIncomeSix("0", data);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: provider.changeTabAreaValue == "0"
                        ? ThemeColors.accent
                        : Colors.transparent,
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(5)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Text(
                    "6Y",
                    style: stylePTSansBold(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    data = provider.sdFinancialChartRes?.chart;

    List<Chart> dataChart = provider.areaIncomeChart ?? [];
    for (var i = 0; i < dataChart.length; i++) {
      if (value == double.parse("${provider.areaIncomeChart?[i].period}")) {
        return SideTitleWidget(
            axisSide: meta.axisSide,
            space: 20, // margin top
            child: Text(
              "${provider.areaIncomeChart?[i].period}",
              style: stylePTSansBold(fontSize: 14),
            ));
      }
    }

    return Container();
  }
}

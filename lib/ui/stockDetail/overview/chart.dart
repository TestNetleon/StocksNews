import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/models/stockDetail/historical_chart.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../utils/colors.dart';
import '../../../utils/constants.dart';

class StocksDetailHistoricalChart extends StatefulWidget {
  const StocksDetailHistoricalChart({super.key});

  @override
  State<StocksDetailHistoricalChart> createState() =>
      _StocksDetailHistoricalChartState();
}

class _StocksDetailHistoricalChartState
    extends State<StocksDetailHistoricalChart> {
  // final List<String> _ranges = ['1H', '1D', '1W', '1M', '1Y'];

  final List<MarketResData> _ranges = [
    MarketResData(
      title: '1H',
      slug: '1hour',
    ),
    MarketResData(
      title: '1D',
      slug: '1day',
    ),
    MarketResData(
      title: '1W',
      slug: '1week',
    ),
    MarketResData(
      title: '1M',
      slug: '1month',
    ),
    MarketResData(
      title: '1Y',
      slug: '1year',
    ),
  ];

  int _selectedIndex = 0;

  LineChartData avgData({
    bool showDate = true,
    required List<HistoricalChartRes> reversedData,
  }) {
    // List<HistoricalChartRes> reversedData =
    //     historicalChartData.reversed.toList();

    List<FlSpot> spots = [];

    for (int i = 0; i < reversedData.length; i++) {
      spots.add(FlSpot(i.toDouble(), reversedData[i].close.toDouble()));
    }

    return LineChartData(
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(
        getTouchLineEnd: (barData, spotIndex) {
          return double.infinity;
        },
        getTouchLineStart: (barData, spotIndex) {
          return 0.0;
        },
        getTouchedSpotIndicator: (barData, spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(
                // color: Colors.grey[400],
                color: spots.first.y > spots.last.y
                    ? ThemeColors.sos
                    : ThemeColors.accent,
                strokeWidth: 1,
                dashArray: [5, 0],
              ),
              FlDotData(
                show: true,
                checkToShowDot: (spot, barData) {
                  return true;
                },
              ),
            );
          }).toList();
        },
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipHorizontalOffset: 0,
          tooltipRoundedRadius: 4.0,
          showOnTopOfTheChartBoxArea: true,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          maxContentWidth: 300,
          // tooltipPadding:
          //     const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          // tooltipMargin: 1,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map(
              (LineBarSpot touchedSpot) {
                return LineTooltipItem(
                  children: [
                    TextSpan(
                      text: "\$${touchedSpot.y.toStringAsFixed(2)}\n",
                      style: styleBaseSemiBold(
                        fontSize: 18,
                      ),
                    ),
                    TextSpan(
                      text: !showDate
                          ? DateFormat('dd MMM, yyyy')
                              .format(reversedData[touchedSpot.x.toInt()].date)
                          : '${DateFormat('dd MMM').format(reversedData[touchedSpot.x.toInt()].date)}, ${DateFormat('h:mm a').format(reversedData[touchedSpot.x.toInt()].date)}',
                      style: styleBaseSemiBold(
                          height: 1.5,
                          color: ThemeColors.neutral20,
                          fontSize: 13),
                    ),
                  ],
                  '',
                  styleBaseSemiBold(color: ThemeColors.white, fontSize: 10),
                );
              },
            ).toList();
          },
          getTooltipColor: (touchedSpot) {
            return ThemeColors.neutral5;
          },
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(
            sideTitles: SideTitles(
          showTitles: false,
        )),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: false,
        )),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 32,
            showTitles: false,
          ),
        ),
      ),
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: ThemeColors.white,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: ThemeColors.white,
            strokeWidth: 1,
          );
        },
      ),
      minX: 0,
      maxX: reversedData.length.toDouble() - 1,
      minY: reversedData
          .map((data) => data.close.toDouble())
          .reduce((a, b) => a < b ? a : b),
      maxY: reversedData
          .map((data) => data.close.toDouble())
          .reduce((a, b) => a > b ? a : b),
      lineBarsData: [
        LineChartBarData(
          preventCurveOverShooting: true,
          spots: spots,
          color: spots.first.y > spots.last.y
              ? ThemeColors.sos
              : ThemeColors.accent,
          isCurved: true,
          barWidth: 2,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: spots.first.y > spots.last.y
                  ? [
                      const Color.fromRGBO(255, 99, 99, 0.18),
                      const Color.fromRGBO(255, 150, 150, 0.15),
                      const Color.fromRGBO(255, 255, 255, 0.0),
                    ]
                  : [
                      const Color.fromRGBO(71, 193, 137, 0.18),
                      const Color.fromRGBO(171, 227, 201, 0.15),
                      const Color.fromRGBO(255, 255, 255, 0.0),
                    ],
              stops: [0.0, 0.6, 4],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    StocksDetailManager manager = context.watch<StocksDetailManager>();
    StocksDetailHistoricalChartRes? chart = manager.dataHistoricalC;
    bool hasData = manager.dataHistoricalC != null;
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: chart?.totalChange != null,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
              child: RichText(
                text: TextSpan(
                  children: [
                    if (chart?.totalChange != null)
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Image.asset(
                            (chart?.totalChange ?? 0) >= 0
                                ? Images.trendingUP
                                : Images.trendingDOWN,
                            height: 18,
                            width: 18,
                            color: (chart?.totalChange ?? 0) >= 0
                                ? ThemeColors.accent
                                : ThemeColors.sos,
                          ),
                        ),
                      ),
                    TextSpan(
                      text: '${chart?.totalChange ?? 0}',
                      style: styleBaseSemiBold(
                        fontSize: 18,
                        color: (chart?.totalChange ?? 0) >= 0
                            ? ThemeColors.accent
                            : ThemeColors.sos,
                      ),
                    ),
                    if (chart?.label != null && chart?.label != '')
                      TextSpan(
                        text: '  ${chart?.label}',
                        style: styleBaseSemiBold(
                          fontSize: 13,
                          color: ThemeColors.neutral40,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SpacerVertical(height: 10),
          SizedBox(
            height: constraints.maxWidth * 0.5,
            child: Stack(
              children: [
                hasData
                    ? LineChart(
                        avgData(
                            reversedData: chart!.chartData!.reversed.toList()),
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.linear,
                      )
                    : manager.isLoadingHistoricalC && !hasData
                        ? Loading()
                        : Center(
                            child: Text(
                              manager.errorHistoricalC ?? '',
                              style: styleBaseBold(color: ThemeColors.black),
                            ),
                          ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _ranges.length,
                (index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 32),
                    child: GestureDetector(
                      onTap: () {
                        if (_selectedIndex != index) {
                          _selectedIndex = index;
                          setState(() {});
                          manager.getStocksDetailHistoricalC(
                            range: _ranges[index].slug ?? '',
                          );
                        }
                      },
                      child: Text(
                        _ranges[index].title ?? '',
                        style: _selectedIndex == index
                            ? styleBaseBold()
                            : styleBaseRegular(
                                color: ThemeColors.neutral20,
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}

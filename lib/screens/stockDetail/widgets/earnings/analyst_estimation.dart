import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/earnings.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

enum ChartValue { all, current, low, high, average }

class EarningsAnalystEstimateLineChart extends StatefulWidget {
  const EarningsAnalystEstimateLineChart({
    super.key,
  });

  @override
  State<EarningsAnalystEstimateLineChart> createState() =>
      _EarningsAnalystEstimateLineChartState();
}

class _EarningsAnalystEstimateLineChartState
    extends State<EarningsAnalystEstimateLineChart> {
  ChartValue _selectedValue = ChartValue.all;

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    if (provider.earnings?.epsEstimates == null ||
        provider.earnings!.epsEstimates!.isEmpty) {
      return const Center(child: SizedBox.shrink());
    }

    List<FlSpot> currentSpots = provider.earnings!.epsEstimates!.asMap().entries.map((entry) {
      int index = entry.key;
      EpsEstimate data = entry.value;
      double current = double.tryParse(data.numberOfEstimates.toString()) ?? 0;
      return FlSpot(index.toDouble(), current);
    }).toList();

    List<FlSpot> lowSpots =
        provider.earnings!.epsEstimates!.asMap().entries.map((entry) {
      int index = entry.key;
      EpsEstimate data = entry.value;
      double low = double.tryParse(
              data.estimatedEpsLow!.replaceAll('\$', '').toString()) ??
          0;
      return FlSpot(index.toDouble(), low);
    }).toList();

    List<FlSpot> highSpots =
        provider.earnings!.epsEstimates!.asMap().entries.map((entry) {
      int index = entry.key;
      EpsEstimate data = entry.value;
      double high = double.tryParse(
              data.estimatedEpsHigh!.replaceAll('\$', '').toString()) ??
          0;
      return FlSpot(index.toDouble(), high);
    }).toList();

    List<FlSpot> averageSpots =
        provider.earnings!.epsEstimates!.asMap().entries.map((entry) {
      int index = entry.key;
      EpsEstimate data = entry.value;
      double average = double.tryParse(
              data.estimatedEpsAvg!.replaceAll('\$', '').toString()) ??
          0;
      return FlSpot(index.toDouble(), average);
    }).toList();

    // double maxValue = [
    //   currentSpots,
    //   lowSpots,
    //   highSpots,
    //   averageSpots,
    // ]
    //     .expand((spots) => spots)
    //     .map((spot) => spot.y)
    //     .reduce((a, b) => a > b ? a : b);

    List<LineChartBarData> lineBarsData = [];
    if (_selectedValue == ChartValue.all ||
        _selectedValue == ChartValue.current) {
      lineBarsData.add(LineChartBarData(
        spots: currentSpots,
        isCurved: true,
        color: Colors.green,
        barWidth: 4,
        dotData: const FlDotData(show: true),
      ));
    }
    if (_selectedValue == ChartValue.all || _selectedValue == ChartValue.low) {
      lineBarsData.add(LineChartBarData(
        spots: lowSpots,
        isCurved: true,
        color: Colors.red,
        barWidth: 4,
        dotData: const FlDotData(show: true),
      ));
    }
    if (_selectedValue == ChartValue.all || _selectedValue == ChartValue.high) {
      lineBarsData.add(LineChartBarData(
        spots: highSpots,
        isCurved: true,
        color: Colors.blue,
        barWidth: 4,
        dotData: const FlDotData(show: true),
      ));
    }
    if (_selectedValue == ChartValue.all ||
        _selectedValue == ChartValue.average) {
      lineBarsData.add(LineChartBarData(
        spots: averageSpots,
        isCurved: true,
        color: Colors.yellow,
        barWidth: 4,
        dotData: const FlDotData(show: true),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Radio<ChartValue>(
              activeColor: Colors.green,
              fillColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.white.withOpacity(.32);
                }
                return Colors.white;
              }),
              value: ChartValue.all,
              groupValue: _selectedValue,
              onChanged: (ChartValue? value) {
                setState(() {
                  _selectedValue = value!;
                });
              },
            ),
            const Text(
              'All Estimation',
              style: TextStyle(color: Colors.white),
            ),
            const SpacerHorizontal(width: 20),
            Radio<ChartValue>(
              activeColor: Colors.green,
              fillColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.white.withOpacity(.32);
                }
                return Colors.green;
              }),
              value: ChartValue.current,
              groupValue: _selectedValue,
              onChanged: (ChartValue? value) {
                setState(() {
                  _selectedValue = value!;
                });
              },
            ),
            const Text(
              'Current Estimation',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Radio<ChartValue>(
            fillColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.green;
              }
              return Colors.red;
            }),
            value: ChartValue.low,
            groupValue: _selectedValue,
            onChanged: (ChartValue? value) {
              setState(() {
                _selectedValue = value!;
              });
            },
          ),
          const Text(
            'Low',
            style: TextStyle(color: Colors.white),
          ),
          const SpacerHorizontal(width: 10),
          Radio<ChartValue>(
            activeColor: Colors.blue,
            fillColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return Colors.white.withOpacity(.32);
              }
              return Colors.blue;
            }),
            value: ChartValue.high,
            groupValue: _selectedValue,
            onChanged: (ChartValue? value) {
              setState(() {
                _selectedValue = value!;
              });
            },
          ),
          const Text(
            'High',
            style: TextStyle(color: Colors.white),
          ),
          const SpacerHorizontal(width: 10),
          Radio<ChartValue>(
            activeColor: Colors.green,
            fillColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return Colors.white.withOpacity(.32);
              }
              return Colors.yellow;
            }),
            value: ChartValue.average,
            groupValue: _selectedValue,
            onChanged: (ChartValue? value) {
              setState(() {
                _selectedValue = value!;
              });
            },
          ),
          const Text(
            'Average',
            style: TextStyle(color: Colors.white),
          ),
        ]),
        AspectRatio(
          aspectRatio: 1.0,
          child: LineChart(LineChartData(
              // maxY: maxValue,
              maxY: 25,
              // minY: 0.0,
              minY: -5.0,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 20,
                    interval: (25 / 3).ceilToDouble(),
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 5.0,
                        child: Text(
                          '${value.toInt()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
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
                          index >= provider.earnings!.epsEstimates!.length) {
                        Utils().showLog(
                            "data length is checking ${provider.earnings!.epsEstimates!.length}");
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 1.20,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            provider.earnings!.epsEstimates![index].quarter
                                .toString(),
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
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: (25 / 3).ceilToDouble(),
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 4.0,
                        child: Text(
                          '\$${value.toDouble()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
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
              lineBarsData: lineBarsData,
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (group) => Colors.white,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((touchedSpot) {
                      final data = provider
                          .earnings!.epsEstimates![touchedSpot.spotIndex];
                      String text = '';
                      Color textColor = Colors.black;
                      switch (_selectedValue) {
                        case ChartValue.all:
                          switch (touchedSpot.barIndex) {
                            case 0:
                              text = 'Current: ${data.numberOfEstimates}';
                              textColor = Colors.green;
                              break;
                            case 1:
                              text = 'Low: ${data.estimatedEpsLow}';
                              textColor = Colors.red;
                              break;
                            case 2:
                              text = 'High: ${data.estimatedEpsHigh}';
                              textColor = Colors.blue;
                              break;
                            case 3:
                              text = 'Average: ${data.estimatedEpsAvg}';
                              textColor = Colors.yellow;
                              break;
                            default:
                              text = '';
                              textColor = Colors.black;
                              break;
                          }
                          break;
                        case ChartValue.current:
                          if (touchedSpot.barIndex == 0) {
                            text = 'Current: ${data.numberOfEstimates}';
                            textColor = Colors.green;
                          }
                          break;
                        case ChartValue.low:
                          if (touchedSpot.barIndex == 0) {
                            text = 'Low: ${data.estimatedEpsLow}';
                            textColor = Colors.red;
                          }
                          break;
                        case ChartValue.high:
                          if (touchedSpot.barIndex == 0) {
                            text = 'High: ${data.estimatedEpsHigh}';
                            textColor = Colors.blue;
                          }
                          break;
                        case ChartValue.average:
                          if (touchedSpot.barIndex == 0) {
                            text = 'Average: ${data.estimatedEpsAvg}';
                            textColor = Colors.yellow;
                          }
                          break;
                        default:
                          text = '';
                          textColor = Colors.black;
                          break;
                      }
                      return LineTooltipItem(
                        text,
                        TextStyle(color: textColor),
                      );
                    }).toList();
                  },
                ),
              ))),
        ),
      ],
    );
  }

  // LineChartData Currentchart(BuildContext context) {
  //   StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
  //   List<FlSpot> currentSpots =
  //       provider.earnings!.epsEstimates!.asMap().entries.map((entry) {
  //     int index = entry.key;
  //     EpsEstimate data = entry.value;
  //     double current = double.tryParse(data.numberOfEstimates.toString()) ?? 0;
  //     return FlSpot(index.toDouble(), current);
  //   }).toList();
  //   List<FlSpot> lowSpots =
  //       provider.earnings!.epsEstimates!.asMap().entries.map((entry) {
  //     int index = entry.key;
  //     EpsEstimate data = entry.value;
  //     double low = double.tryParse(
  //             data.estimatedEpsLow!.replaceAll('\$', '').toString()) ??
  //         0;
  //     return FlSpot(index.toDouble(), low);
  //   }).toList();
  //   List<FlSpot> highSpots =
  //       provider.earnings!.epsEstimates!.asMap().entries.map((entry) {
  //     int index = entry.key;
  //     EpsEstimate data = entry.value;
  //     double high = double.tryParse(
  //             data.estimatedEpsHigh!.replaceAll('\$', '').toString()) ??
  //         0;
  //     return FlSpot(index.toDouble(), high);
  //   }).toList();
  //   List<FlSpot> averageSpots =
  //       provider.earnings!.epsEstimates!.asMap().entries.map((entry) {
  //     int index = entry.key;
  //     EpsEstimate data = entry.value;
  //     double average = double.tryParse(
  //             data.estimatedEpsAvg!.replaceAll('\$', '').toString()) ??
  //         0;
  //     return FlSpot(index.toDouble(), average);
  //   }).toList();
  //   double maxValue = [
  //     currentSpots,
  //     lowSpots,
  //     highSpots,
  //     averageSpots,
  //   ]
  //       .expand((spots) => spots)
  //       .map((spot) => spot.y)
  //       .reduce((a, b) => a > b ? a : b);
  //   return LineChartData(
  //     // maxY: maxValue,
  //     maxY: 25,
  //     // minY: 0.0,
  //     minY: -5.0,
  //     titlesData: FlTitlesData(
  //       leftTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           reservedSize: 20,
  //           interval: (maxValue / 5).ceilToDouble(),
  //           getTitlesWidget: (value, meta) {
  //             return SideTitleWidget(
  //               axisSide: meta.axisSide,
  //               space: 5.0,
  //               child: Text(
  //                 '${value.toInt()}',
  //                 style: const TextStyle(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 10,
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //       bottomTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           interval: 1,
  //           reservedSize: 40,
  //           getTitlesWidget: (value, meta) {
  //             int index = value.toInt();
  //             if (index < 0 ||
  //                 index >= provider.earnings!.epsEstimates!.length) {
  //               Utils().showLog(
  //                   "data length is checking ${provider.earnings!.epsEstimates!.length}");
  //               return const SizedBox.shrink();
  //             }
  //             return SideTitleWidget(
  //               axisSide: meta.axisSide,
  //               space: 1.25,
  //               child: RotatedBox(
  //                 quarterTurns: 3,
  //                 child: Text(
  //                   provider.earnings!.epsEstimates![index].quarter.toString(),
  //                   style: const TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 10,
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //       rightTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           reservedSize: 30,
  //           interval: (25 / 5).ceilToDouble(),
  //           getTitlesWidget: (value, meta) {
  //             return SideTitleWidget(
  //               axisSide: meta.axisSide,
  //               space: 4.0,
  //               child: Text(
  //                 '\$${value.toDouble()}',
  //                 style: const TextStyle(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 10,
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //     gridData: const FlGridData(show: true),
  //     borderData: FlBorderData(
  //       show: true,
  //     ),
  //     lineBarsData: [
  //       LineChartBarData(
  //         spots: currentSpots,
  //         isCurved: true,
  //         color: Colors.green,
  //         barWidth: 4,
  //         // belowBarData: BarAreaData(show: true, color: Colors.green),
  //         dotData: const FlDotData(show: true),
  //       ),
  //       LineChartBarData(
  //         spots: lowSpots,
  //         isCurved: true,
  //         color: Colors.red,
  //         barWidth: 4,
  //         // belowBarData: BarAreaData(show: true, color: Colors.green),
  //         dotData: const FlDotData(show: true),
  //       ),
  //       LineChartBarData(
  //         spots: highSpots,
  //         isCurved: true,
  //         color: Colors.blue,
  //         barWidth: 4,
  //         // belowBarData: BarAreaData(show: true, color: Colors.green),
  //         dotData: const FlDotData(show: true),
  //       ),
  //       LineChartBarData(
  //         spots: averageSpots,
  //         isCurved: true,
  //         color: Colors.yellow,
  //         barWidth: 4,
  //         // belowBarData: BarAreaData(show: true, color: Colors.green),
  //         dotData: const FlDotData(show: true),
  //       ),
  //     ],
  //     lineTouchData: LineTouchData(
  //       touchTooltipData: LineTouchTooltipData(
  //         getTooltipColor: (group) => Colors.white,
  //         getTooltipItems: (touchedSpots) {
  //           return touchedSpots.map((touchedSpot) {
  //             final data =
  //                 provider.earnings!.epsEstimates![touchedSpot.spotIndex];
  //             String text;
  //             Color textColor;
  //             if (touchedSpot.barIndex == 0) {
  //               text = 'Current: ${data.numberOfEstimates}';
  //               textColor = Colors.green;
  //             } else if (touchedSpot.barIndex == 1) {
  //               text = 'Low: ${data.estimatedEpsLow}';
  //               textColor = Colors.red;
  //             } else if (touchedSpot.barIndex == 2) {
  //               text = 'High: ${data.estimatedEpsHigh}';
  //               textColor = Colors.blue;
  //             } else if (touchedSpot.barIndex == 3) {
  //               text = 'Average: ${data.estimatedEpsAvg}';
  //               textColor = Colors.yellow;
  //             } else {
  //               text = '';
  //               textColor = Colors.black;
  //             }
  //             return LineTooltipItem(
  //               text,
  //               TextStyle(color: textColor),
  //             );
  //           }).toList();
  //         },
  //       ),
  //     ),
  //   );
  // }
}

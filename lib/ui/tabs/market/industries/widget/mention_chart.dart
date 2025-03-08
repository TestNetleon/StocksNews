import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/industries/industries.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class MentionChart extends StatelessWidget {
  const MentionChart({super.key});

  @override
  Widget build(BuildContext context) {
    IndustriesManager manager = context.read<IndustriesManager>();
    return Padding(
      padding: const EdgeInsets.only(top: Pad.pad20,bottom: Pad.pad20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:  Pad.pad20),
            child: Row(
              children: [
                Text(
                  "Mentions",
                  style: stylePTSansBold(fontSize:22,color: ThemeColors.splashBG),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Pad.pad5),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: index == 0
                                        ? ThemeColors.success:
                                    index == 1
                                        ? ThemeColors.error120:
                                    ThemeColors.category100,
                                    borderRadius: BorderRadius.circular(Pad.pad2)
                                ),
                                padding: EdgeInsets.all(Pad.pad8),

                              ),
                              SpacerHorizontal(width: Pad.pad5),
                              Text(
                                index == 0?"Positive":index == 1?"Negative":"Neutral",
                                style: stylePTSansRegular(fontSize: 12,color: ThemeColors.splashBG),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SpacerVertical(),
          SizedBox(
            height: 300,
            child:
            BarChart(
              BarChartData(
                barGroups: List.generate(manager.data!.chart!.labels!.length, (index) {
                  return BarChartGroupData(
                      x: index, barRods: [
                    BarChartRodData(
                      toY: (manager.data!.chart!.positiveMentions![index] + manager.data!.chart!.negativeMentions![index] + manager.data!.chart!.neutralMentions![index]).toDouble(),
                      rodStackItems: [
                        BarChartRodStackItem(0, manager.data!.chart!.positiveMentions![index].toDouble(),ThemeColors.success),
                        BarChartRodStackItem(manager.data!.chart!.positiveMentions![index].toDouble(), (manager.data!.chart!.positiveMentions![index] + manager.data!.chart!.negativeMentions![index]).toDouble(), ThemeColors.error120),
                        BarChartRodStackItem((manager.data!.chart!.positiveMentions![index] + manager.data!.chart!.negativeMentions![index]).toDouble(), (manager.data!.chart!.positiveMentions![index] + manager.data!.chart!.negativeMentions![index] + manager.data!.chart!.neutralMentions![index]).toDouble(),  ThemeColors.category100),
                      ],
                      width: 12,
                      borderRadius: BorderRadius.zero,
                    ),
                  ]);
                }),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize:40,
                    interval: 1000,
                    getTitlesWidget: (value, meta) {
                      if (value % 1000 == 0) {
                        return SideTitleWidget(
                          space: 5,
                          axisSide: AxisSide.left,
                          child: Text(meta.formattedValue, style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          )),
                        );
                      }
                      return Container();
                    },
                  //  getTitlesWidget: (value, meta) => leftTitleWidgets(value, meta),
                  )),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text("${manager.data!.chart!.labels![value.toInt()].substring(0, 3)}.." ,),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: false,
                ),

                barTouchData: BarTouchData(
                  handleBuiltInTouches: false
                )

              ),
            ),

           /* BarChart(
              BarChartData(
                barGroups: _getBarGroups(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Transform.rotate(
                          angle: -0.5,
                          child: Text(manager.data!.chart!.labels![value.toInt()], style: TextStyle(fontSize: 10)),
                        );
                      },
                      reservedSize: 80,
                      interval: 1,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: true),
                barTouchData: BarTouchData(enabled: true),
              ),
            ),*/
          ),
        ],
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );
    return SideTitleWidget(
      space: 5,
      axisSide: AxisSide.left,
      child: Text(meta.formattedValue, style: style),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    IndustriesManager manager = navigatorKey.currentContext!.read<IndustriesManager>();
    return List.generate(manager.data!.chart!.labels!.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            fromY: 0,
            toY: manager.data!.chart!.positiveMentions![index].toDouble(),
            width: 10,
            color: Colors.green,
          ),
          BarChartRodData(
            fromY: manager.data!.chart!.positiveMentions![index].toDouble(),
            toY: manager.data!.chart!.positiveMentions![index] + manager.data!.chart!.negativeMentions![index].toDouble(),
            width: 10,
            color: Colors.red,
          ),
          BarChartRodData(
            fromY: manager.data!.chart!.positiveMentions![index] + manager.data!.chart!.negativeMentions![index].toDouble(),
            toY: manager.data!.chart!.positiveMentions![index] + manager.data!.chart!.negativeMentions![index] + manager.data!.chart!.neutralMentions![index].toDouble(),
            width: 10,
            color: Colors.blue,
          ),
        ],
      );
    });
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/models/stockDetail/historical_chart.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../utils/colors.dart';
import '../../../utils/constants.dart';

class SDHistoricalChart extends StatefulWidget {
  const SDHistoricalChart({super.key});

  @override
  State<SDHistoricalChart> createState() => _SDHistoricalChartState();
}

class _SDHistoricalChartState extends State<SDHistoricalChart> {
  // final List<String> _ranges = ['1H', '1D', '1W', '1M', '1Y'];

  @override
  Widget build(BuildContext context) {
    return Consumer<SDManager>(
      builder: (context, value, child) {
        SDHistoricalChartRes? chart = value.dataHistoricalC;
        bool hasData =
            chart?.chartData != null && chart?.chartData?.isNotEmpty == true;
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
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
                            value.avgData(
                                reversedData:
                                    chart?.chartData?.reversed.toList() ?? []),
                            duration: const Duration(milliseconds: 150),
                            curve: Curves.linear,
                          )
                        : value.isLoadingHistoricalC && !hasData
                            ? Loading()
                            : Center(
                                child: Text(
                                  value.errorHistoricalC ?? '',
                                  style:
                                      styleBaseBold(color: ThemeColors.black),
                                ),
                              ),
                  ],
                ),
              ),
              SpacerVertical(height: Pad.pad32),
              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    value.ranges.length,
                    (index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            right: index == value.ranges.length - 1 ? 0 : 32),
                        child: GestureDetector(
                          onTap: () {
                            value.changeChartIndex(index);
                          },
                          child: Text(
                            value.ranges[index].title ?? '',
                            style: value.selectedChartIndex == index
                                ? styleBaseBold(color: ThemeColors.secondary120)
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
      },
    );
  }
}

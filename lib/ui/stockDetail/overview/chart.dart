import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/models/stockDetail/historical_chart.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../utils/colors.dart';
import '../../../utils/constants.dart';

class SDHistoricalChart extends StatefulWidget {
  final SDHistoricalChartRes? chart;
  final bool hasData;
  final void Function(String) onTap;
  final String? error;
  const SDHistoricalChart({
    super.key,
    this.chart,
    required this.hasData,
    required this.onTap,
    this.error,
  });

  @override
  State<SDHistoricalChart> createState() => _SDHistoricalChartState();
}

class _SDHistoricalChartState extends State<SDHistoricalChart> {
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

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: widget.chart?.totalChange != null,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
              child: RichText(
                text: TextSpan(
                  children: [
                    if (widget.chart?.totalChange != null)
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Image.asset(
                            (widget.chart?.totalChange ?? 0) >= 0
                                ? Images.trendingUP
                                : Images.trendingDOWN,
                            height: 18,
                            width: 18,
                            color: (widget.chart?.totalChange ?? 0) >= 0
                                ? ThemeColors.accent
                                : ThemeColors.sos,
                          ),
                        ),
                      ),
                    TextSpan(
                      text: '${widget.chart?.totalChange ?? 0}',
                      style: styleBaseSemiBold(
                        fontSize: 18,
                        color: (widget.chart?.totalChange ?? 0) >= 0
                            ? ThemeColors.accent
                            : ThemeColors.sos,
                      ),
                    ),
                    if (widget.chart?.label != null &&
                        widget.chart?.label != '')
                      TextSpan(
                        text: '  ${widget.chart?.label}',
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
                widget.hasData
                    ? LineChart(
                        manager.avgData(
                            reversedData:
                                widget.chart?.chartData?.reversed.toList() ??
                                    []),
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.linear,
                      )
                    : manager.isLoadingHistoricalC && !widget.hasData
                        ? Loading()
                        : Center(
                            child: Text(
                              widget.error ?? '',
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
                    padding: EdgeInsets.only(
                        right: index == _ranges.length - 1 ? 0 : 32),
                    child: GestureDetector(
                      onTap: () {
                        if (_selectedIndex != index) {
                          _selectedIndex = index;
                          setState(() {});
                          widget.onTap(_ranges[index].slug ?? '');
                        }
                      },
                      child: Text(
                        _ranges[index].title ?? '',
                        style: _selectedIndex == index
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
  }
}

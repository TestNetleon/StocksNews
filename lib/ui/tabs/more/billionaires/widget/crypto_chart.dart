
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/models/stockDetail/historical_chart.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class CryptoChart extends StatefulWidget {
  final List<HistoricalChartRes>? chart;
  final bool hasData;
  final void Function(String) onTap;
  final String? error;
  const CryptoChart({
    super.key,
    this.chart,
    required this.hasData,
    required this.onTap,
    this.error,
  });

  @override
  State<CryptoChart> createState() => _CryptoChartState();
}

class _CryptoChartState extends State<CryptoChart> {
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
    BillionairesManager manager = context.watch<BillionairesManager>();


    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: constraints.maxWidth * 0.5,
            child: Stack(
              children: [
                widget.hasData
                    ? LineChart(
                  manager.avgData(
                      reversedData:
                      widget.chart?.reversed.toList() ??
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
          SpacerVertical(height: Pad.pad32),
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
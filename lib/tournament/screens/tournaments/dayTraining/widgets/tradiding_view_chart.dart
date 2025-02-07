import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/trades.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class TradingViewChart extends StatefulWidget {
  final String symbol;
  final EdgeInsets? padding;
  const TradingViewChart({super.key, required this.symbol, this.padding});

  @override
  State<TradingViewChart> createState() => _TradingViewChartState();
}

class _TradingViewChartState extends State<TradingViewChart> {
  List<String> range = ['1H', '1D', '1W', '1M', '1Y'];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //_callApi();
    });
  }

  _callApi() {
    context
        .read<TournamentTradesProvider>()
        .getOverviewGraphData(symbol: widget.symbol);
  }
  @override
  Widget build(BuildContext context) {
    TournamentTradesProvider provider = context.watch<TournamentTradesProvider>();
    if (provider.isLoadingGraph && provider.graphChart == null) {
      return const SizedBox();
    }
    if (provider.graphChart == null && !provider.isLoadingGraph) {
      return Padding(
        padding: widget.padding ??
            EdgeInsets.symmetric(horizontal: 10.sp, vertical: 40.sp),
        child: Text(
          "${provider.errorGraph}",
          style: stylePTSansRegular(),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            const SpacerVertical(height: 20),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.sp),
              height: constraints.maxWidth * 0.8,
              child: LineChart(
                provider.avgData(showDate: _selectedIndex != 4),
                duration: const Duration(milliseconds: 150),
                curve: Curves.linear,
              ),
            ),
            const SpacerVertical(height: 5),
            CupertinoSlidingSegmentedControl<int>(
              groupValue: _selectedIndex,
              thumbColor: ThemeColors.greyBorder.withOpacity(0.4),
              padding: const EdgeInsets.all(4),
              backgroundColor: const Color.fromARGB(255, 28, 28, 28),
              onValueChanged: (int? index) {
                setState(() {
                  _selectedIndex = index!;
                });
                provider.getOverviewGraphData(
                  showProgress: true,
                  symbol: widget.symbol,
                  range: range[_selectedIndex],
                );
              },
              children: {
                for (int i = 0; i < range.length; i++)
                  i: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: Text(
                      range[i],
                      style: styleGeorgiaRegular(
                        fontSize: 13,
                        color: _selectedIndex == i
                            ? ThemeColors.accent
                            : ThemeColors.white,
                        // color: ThemeColors.white,
                      ),
                    ),
                  ),
              },
            ),
            const SpacerVertical(height: 20),
          ],
        );
      },
    );
  }
}

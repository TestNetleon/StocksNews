import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/trades.dart';
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


  @override
  void initState() {

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    TradesManger manger = context.watch<TradesManger>();

    /*if (provider.isLoadingGraph && provider.graphChart == null) {
      return const SizedBox();
    }
    if (provider.graphChart == null && !provider.isLoadingGraph) {
      return Padding(
        padding: widget.padding ??
            EdgeInsets.symmetric(horizontal: 10.sp, vertical: 40.sp),
        child: Text(
          "${provider.errorGraph}",
          style: styleBaseRegular(),
        ),
      );
    }*/

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            const SpacerVertical(height: 20),

            manger.isLoadingGraph && manger.dataHistoricalC == null?
            SizedBox():
            manger.dataHistoricalC == null && !manger.isLoadingGraph?
            Padding(
              padding: widget.padding ??
                  EdgeInsets.symmetric(horizontal: 10.sp, vertical: 40.sp),
              child: Text(
                "${manger.errorGraph}",
                style: styleBaseRegular(),
              ),
            ):
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.sp),
              height: constraints.maxWidth * 0.8,
              child: LineChart(
                manger.avgData(showDate: manger.selectedIndex != 4),
                duration: const Duration(milliseconds: 150),
                curve: Curves.linear,
              ),
            ),
            const SpacerVertical(height: 20),
            SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  manger.range.length,
                      (index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          right: index == manger.range.length - 1 ? 0 : 32),
                      child: GestureDetector(
                        onTap: () {
                          if (manger.selectedIndex != index) {
                            setState(() {
                              manger.selectedIndex = index;
                            });
                            manger.getOverviewGraphData(
                              showProgress: true,
                              symbol: widget.symbol,
                              range: manger.range[manger.selectedIndex],
                              initial: manger.selectedIndex==0?true:false
                            );

                          }
                        },
                        child: Text(
                          manger.range[index],
                          style: manger.selectedIndex == index
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
            const SpacerVertical(height: 20),
          ],
        );
      },
    );
  }
}

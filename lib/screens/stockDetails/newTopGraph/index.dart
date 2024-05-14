import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class NewTopGraphIndex extends StatefulWidget {
  const NewTopGraphIndex({super.key});

  @override
  State<NewTopGraphIndex> createState() => _NewTopGraphIndexState();
}

class _NewTopGraphIndexState extends State<NewTopGraphIndex> {
  // List<String>? interval = ['1M', '5M', '15M', '30M', '1H', '4H'];
  List<String>? range = ['1H', '1D', '1W', '1M', '1Y'];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    StockDetailProvider provider = context.watch<StockDetailProvider>();
    if (provider.isLoadingGraph &&
        (provider.graphChart?.isEmpty == true || provider.graphChart == null)) {
      return const SizedBox();
    }
    // KeyStats? stats = context.watch<StockDetailProvider>().data?.keyStats;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            const SpacerVertical(height: 20),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.sp),
              height: constraints.maxWidth * 0.8,
              child: LineChart(
                duration: const Duration(milliseconds: 150),
                curve: Curves.linear,
                provider.avgData(showDate: _selectedIndex != 4),
              ),
            ),
            const SpacerVertical(height: 5),
            SizedBox(
              height: 28.sp,
              child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _selectedIndex = index;
                        setState(() {});
                        provider.getStockGraphData(
                          symbol: provider.data?.keyStats?.symbol ?? "",
                          range: range?[_selectedIndex] ?? "1H",
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.sp, vertical: 5.sp),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: _selectedIndex == index
                                    ? ThemeColors.accent
                                    : ThemeColors.greyBorder),
                            borderRadius: BorderRadius.circular(5.sp)),
                        child: Text(
                          "${range?[index]}",
                          style: styleGeorgiaRegular(
                              fontSize: 13,
                              color: _selectedIndex == index
                                  ? ThemeColors.accent
                                  : ThemeColors.white),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SpacerHorizontal(width: 15);
                  },
                  itemCount: range?.length ?? 0),
            ),
            // const SpacerVertical(height: 10),

            // StockDetailTopDisclaimer(),

            const SpacerVertical(height: 40),
          ],
        );
      },
    );
  }
}

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
  List<String>? interval = ['1M', '5M', '15M', '30M', '1H', '4H'];
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    StockDetailProvider provider = context.watch<StockDetailProvider>();
    if (provider.isLoadingGraph &&
        (provider.graphChart?.isEmpty == true || provider.graphChart == null)) {
      return const SizedBox();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 5.sp),
              height: constraints.maxWidth * 0.8,
              child: LineChart(
                duration: const Duration(milliseconds: 150), // Optional
                curve: Curves.linear, // Optional
                provider.avgData(from: "UI"),
              ),
            ),
            const SpacerVertical(height: 5),
            SizedBox(
              height: 30.sp,
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
                            interval: interval?[_selectedIndex] ?? "15M");
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.sp, vertical: 5.sp),
                        decoration: BoxDecoration(
                            border: _selectedIndex == index
                                ? Border.all(color: ThemeColors.greyBorder)
                                : null,
                            borderRadius: BorderRadius.circular(10.sp)),
                        child: Text(
                          "${interval?[index]}",
                          style: styleGeorgiaRegular(fontSize: 13),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SpacerHorizontal(width: 15);
                  },
                  itemCount: interval?.length ?? 0),
            ),
            const SpacerVertical(height: 15),
          ],
        );
      },
    );
  }
}

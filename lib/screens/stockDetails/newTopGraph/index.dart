import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class NewTopGraphIndex extends StatefulWidget {
  final String symbol;
  const NewTopGraphIndex({super.key, required this.symbol});

  @override
  State<NewTopGraphIndex> createState() => _NewTopGraphIndexState();
}

class _NewTopGraphIndexState extends State<NewTopGraphIndex> {
  // List<String>? interval = ['1M', '5M', '15M', '30M', '1H', '4H'];

  List<String> range = ['1H', '1D', '1W', '1M', '1Y'];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _selectedIndex = context.read<StockDetailProvider>().graphIndex;
      });
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     context
  //         .read<StockDetailProvider>()
  //         .getStockGraphData(symbol: widget.symbol);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    StockDetailProvider provider = context.watch<StockDetailProvider>();
    if (provider.isLoadingGraph && provider.graphChart == null) {
      return const SizedBox();
    }
    if (provider.graphChart == null && !provider.isLoadingGraph) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 40.sp),
        child: Text(
          "${provider.graphError}",
          style: stylePTSansRegular(),
        ),
      );
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

            // SizedBox(
            //   height: 28.sp,
            //   child: ListView.separated(
            //       physics: const BouncingScrollPhysics(),
            //       scrollDirection: Axis.horizontal,
            //       shrinkWrap: true,
            //       itemBuilder: (context, index) {
            //         return GestureDetector(
            //           onTap: () {
            //             setState(() {
            //               _selectedIndex = index;
            //             });
            //             provider.getStockGraphData(
            //               clearData: false,
            //               showProgress: true,
            //               symbol: provider.data?.keyStats?.symbol ?? "",
            //               range: range?[_selectedIndex] ?? "1H",
            //               index: _selectedIndex,
            //             );
            //           },
            //           child: Container(
            //             padding: EdgeInsets.symmetric(
            //                 horizontal: 15.sp, vertical: 5.sp),
            //             decoration: BoxDecoration(
            //               border: Border.all(
            //                 color: _selectedIndex == index
            //                     ? ThemeColors.accent
            //                     : ThemeColors.greyBorder,
            //               ),
            //               borderRadius: BorderRadius.circular(5.sp),
            //             ),
            //             child: Center(
            //               child: Text(
            //                 "${range?[index]}",
            //                 style: styleGeorgiaRegular(
            //                   fontSize: 13,
            //                   color: _selectedIndex == index
            //                       ? ThemeColors.accent
            //                       : ThemeColors.white,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         );
            //       },
            //       separatorBuilder: (context, index) {
            //         return const SpacerHorizontal(width: 15);
            //       },
            //       itemCount: range?.length ?? 0),
            // ),

            CupertinoSlidingSegmentedControl<int>(
              groupValue: _selectedIndex,
              thumbColor: ThemeColors.greyBorder.withOpacity(0.4),
              // thumbColor: ThemeColors.white,
              padding: const EdgeInsets.all(4),
              // backgroundColor: Color.fromARGB(255, 190, 255, 253),
              onValueChanged: (int? index) {
                setState(() {
                  _selectedIndex = index!;
                });
                provider.getStockGraphData(
                  clearData: false,
                  showProgress: true,
                  symbol: provider.data?.keyStats?.symbol ?? "",
                  range: range[_selectedIndex],
                  index: _selectedIndex,
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
            // SegmentedButton(
            //   segments: const <ButtonSegment<String>>[
            //     ButtonSegment<String>(
            //         value: 'day',
            //         label: Text('Day'),
            //         icon: Icon(Icons.calendar_view_day)),
            //     ButtonSegment<String>(
            //         value: 'week',
            //         label: Text('Week'),
            //         icon: Icon(Icons.calendar_view_week)),
            //     ButtonSegment<String>(

            //         value: 'month',
            //         label: Text('Month'),
            //         icon: Icon(Icons.calendar_view_month)),
            //     ButtonSegment<String>(
            //         value: 'year',
            //         label: Text('Year'),
            //         icon: Icon(Icons.calendar_today)),
            //   ],
            //   selected: <String>{'day'},
            //   onSelectionChanged: (Set<String> newSelection) {},
            // ),

            // const SpacerVertical(height: 10),

            // StockDetailTopDisclaimer(),

            const SpacerVertical(height: 40),
          ],
        );
      },
    );
  }
}

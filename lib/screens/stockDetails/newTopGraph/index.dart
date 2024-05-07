import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_detail_graph.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../modals/home_alert_res.dart';

class NewTopGraphIndex extends StatefulWidget {
  const NewTopGraphIndex({super.key});

  @override
  State<NewTopGraphIndex> createState() => _NewTopGraphIndexState();
}

class _NewTopGraphIndexState extends State<NewTopGraphIndex> {
  List<String>? interval = ['1M', '5M', '15M', '30M', '1H', '4H'];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    StockDetailProvider provider = context.watch<StockDetailProvider>();
    final points = [
      FlSpot(1, 2),
      FlSpot(3, 4),
      FlSpot(5, 6),
      FlSpot(2, 3),
      FlSpot(1, 45),
      FlSpot(1, 2),
      FlSpot(87, 32),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.sp),
              height: constraints.maxWidth * 0.8,
              child: LineChart(
                  duration: Duration(milliseconds: 150), // Optional
                  curve: Curves.linear, // Optional
                  provider.avgData(
                    from: "UI",
                  )),
              // child: LineChart(
              //   LineChartData(
              //     lineBarsData: [
              //       LineChartBarData(
              //         spots: points
              //             .map((point) => FlSpot(point.x, point.y))
              //             .toList(),
              //         isCurved: false,
              //         // dotData: FlDotData(
              //         //   show: false,
              //         // ),
              //       ),
              //     ],
              //   ),
              // ),
            ),
            const SpacerVertical(height: 5),
            Container(
              height: 30.sp,
              child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _selectedIndex = index;
                        setState(() {});

                        provider.getStockGraphData(
                            symbol: provider.data?.keyStats?.symbol ?? "",
                            interval: interval?[_selectedIndex] ?? "1M");
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
                    return SpacerHorizontal(width: 15);
                  },
                  itemCount: interval?.length ?? 0),
            ),
            SpacerVertical(height: 15),
          ],
        );
      },
    );
  }
}

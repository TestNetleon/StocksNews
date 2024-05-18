import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stocks_other_detail_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import 'item.dart';

class CompanyEarningStockDetail extends StatelessWidget {
  const CompanyEarningStockDetail({super.key});
//
  @override
  Widget build(BuildContext context) {
    StockDetailProvider provider = context.watch<StockDetailProvider>();
    Earning? earning = provider.otherData?.earning;

    if (provider.otherLoading &&
        provider.otherData?.earning?.data?.isEmpty == true) {
      return Padding(
        padding: EdgeInsets.only(bottom: 20.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: ThemeColors.accent,
            ),
            const SpacerHorizontal(width: 5),
            Flexible(
              child: Text(
                "Fetching company earning data...",
                style: stylePTSansRegular(color: ThemeColors.accent),
              ),
            ),
          ],
        ),
      );
    }

    if (!provider.otherLoading &&
        provider.otherData?.earning?.data?.isEmpty == true) {
      return const SizedBox();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 20.sp),
      child: Column(
        children: [
          // ScreenTitle(
          //   // title: earning?.title ?? "",
          //   subTitle: earning?.text,
          // ),
          Visibility(
            visible: earning?.text != '',
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.sp),
              child: Text(
                earning?.text ?? "",
                style: stylePTSansRegular(
                    fontSize: 13, color: ThemeColors.greyText),
              ),
            ),
          ),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    Divider(
                      color: ThemeColors.greyBorder,
                      height: 15.sp,
                      thickness: 1,
                    ),
                    Row(
                      children: [
                        AutoSizeText(
                          maxLines: 1,
                          "QUARTER",
                          style: stylePTSansRegular(
                            fontSize: 12,
                            color: ThemeColors.greyText,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                                maxLines: 1,
                                "EPS (Earnings Per Share)",
                                style: stylePTSansRegular(
                                  fontSize: 12,
                                  color: ThemeColors.greyText,
                                )),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: AutoSizeText(
                              maxLines: 1,
                              "REVENUE",
                              style: stylePTSansRegular(
                                fontSize: 12,
                                color: ThemeColors.greyText,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: ThemeColors.greyBorder,
                      height: 15.sp,
                      thickness: 1,
                    ),
                    // const SpacerVertical(height: 5),
                    CompanyEarningItem(index: index),
                  ],
                );
              }
              return CompanyEarningItem(index: index);
            },
            separatorBuilder: (context, index) {
              // return const SpacerVertical(height: 10);
              return Divider(
                color: ThemeColors.greyBorder,
                height: 20.sp,
              );
            },
            itemCount: earning?.data?.length ?? 0,
          ),
          Divider(
            color: ThemeColors.greyBorder,
            height: 20.sp,
          ),

          // Container(
          //   height: 300,
          //   color: ThemeColors.greyBorder,
          //   width: double.infinity,
          //   child: BarChart(
          //     BarChartData(
          //       titlesData: FlTitlesData(
          //           leftTitles: AxisTitles(
          //             sideTitles: SideTitles(showTitles: false),
          //           ),
          //           bottomTitles: AxisTitles(
          //             sideTitles: SideTitles(
          //               showTitles: true,
          //               // getTextStyles: (context, value) => const TextStyle(
          //               //     color: Colors.black,
          //               //     fontWeight: FontWeight.bold,
          //               //     fontSize: 14),
          //             ),
          //           )),
          //       borderData: FlBorderData(show: false),
          //       barGroups:
          //           _createBarGroups(data: provider.otherData?.earning?.data),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // List<BarChartGroupData> _createBarGroups({List<EarningData>? data}) {
  //   final List<String> quarters = [
  //     "Q2 - 2023",
  //     "Q3 - 2023",
  //     "Q4 - 2023",
  //     "Q1 - 2024"
  //   ];

  //   // final List<String?> quarters = data?.map((e) => e.quarter).toList() ?? [];

  //   final List<double> eps = [0.59, 0.71, 0.46, 0.74];
  //   final List<double> revenue = [11.972, 11.953, 10.849, 11.3]; // In billions

  //   return List.generate(quarters.length, (index) {
  //     return BarChartGroupData(
  //       x: index,
  //       barRods: [
  //         BarChartRodData(
  //           toY: eps[index],
  //           color: Colors.amber,
  //           width: 15,
  //         ),
  //         BarChartRodData(
  //           toY: revenue[index],
  //           color: Colors.black,
  //           width: 15,
  //         ),
  //       ],
  //       barsSpace: 10,
  //     );
  //   });
  // }
}

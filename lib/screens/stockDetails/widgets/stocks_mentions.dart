import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_mentions_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class StocksMentions extends StatelessWidget {
  const StocksMentions({super.key});
//
  @override
  Widget build(BuildContext context) {
    StockDetailProvider provider = context.watch<StockDetailProvider>();

    List<Mentions>? mentions = provider.dataMentions?.mentions;

    if (provider.mentionLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: ThemeColors.accent,
        ),
      );
    }
    if (!provider.mentionLoading && mentions?.isEmpty == true) {
      return Center(
        child: ErrorDisplayWidget(
          smallHeight: true,
          error: "No mentions found.",
          onRefresh: () async {
            provider.getStockDetailsMentions(
              symbol: provider.data?.keyStats?.symbol ?? "",
              sectorSlug: provider.data?.companyInfo?.sectorSlug ?? '',
              price: provider.data?.keyStats?.priceWithoutCur,
            );
          },
        ),
      );
    }

    return Column(
      children: [
        const ScreenTitle(
          title: "News Mentions",
          subTitle:
              "The News Mentions section reveals the frequency of this stock's coverage by top news outlets, providing an indication of its media visibility.",
          // style: stylePTSansRegular(fontSize: 20),
        ),
        SizedBox(
          height: 130.sp,
          child: PieChart(
            PieChartData(
              sections: List.generate(
                mentions?.length ?? 0,
                (index) => PieChartSectionData(
                  color: mentions?[index].color,
                  value: mentions?[index].mentionCount?.toDouble(),
                  title: '',
                  radius: 6,
                ),
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 5.sp,
              centerSpaceRadius: 60.sp,
            ),
          ),
        ),
        ListView.separated(
          padding: EdgeInsets.only(top: 20.sp),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Row(
              children: [
                CircleAvatar(
                  backgroundColor: mentions?[index].color,
                  radius: 5.sp,
                ),
                const SpacerHorizontal(width: 10),
                Expanded(
                  child: Wrap(
                    children: [
                      Text(
                        mentions?[index].website ?? "",
                        style: stylePTSansBold(fontSize: 14),
                      ),
                      const SpacerHorizontal(width: 20),
                      Text(
                        "${mentions?[index].mentionCount}",
                        style: stylePTSansBold(fontSize: 14),
                      )
                    ],
                  ),
                )
              ],
            );
          },
          separatorBuilder: (context, index) {
            return const SpacerVertical(height: 12);
          },
          itemCount: mentions?.length ?? 0,
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/top_trending_res.dart';
import 'package:stocks_news_new/providers/top_trending_provider.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/item.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

class TrendingNowListView extends StatelessWidget {
  const TrendingNowListView({super.key});
//
  @override
  Widget build(BuildContext context) {
    List<TopTrendingDataRes>? dataList =
        context.watch<TopTrendingProvider>().data;

    return ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 10.sp),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          TopTrendingDataRes? data = dataList?[index];
          if (data == null) {
            return const SizedBox();
          }
          return TopTrendingItem(
            index: index,
            data: data,
            alertAdded: data.isAlertAdded == 1,
            watchlistAdded: data.isWatchlistAdded == 1,
          );
        },
        separatorBuilder: (context, index) {
          return const SpacerVerticel(height: 10);
        },
        itemCount: dataList?.length ?? 0);
  }
}

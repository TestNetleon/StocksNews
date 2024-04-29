import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/top_trending_res.dart';
import 'package:stocks_news_new/providers/top_trending_provider.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

import '../cap_heading.dart';

class MicroCapListView extends StatelessWidget {
  const MicroCapListView({super.key});
//
  @override
  Widget build(BuildContext context) {
    TopTrendingProvider provider = context.watch<TopTrendingProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const TrendingMarketCapHeading(
          leading: "Micro Cap",
          trailing: "Less than \$250 Million",
        ),
        !provider.isLoading &&
                (provider.microCap == null ||
                    provider.microCap?.isEmpty == true)
            ? const Center(
                child: ErrorDisplayWidget(
                    fontSize: 11,
                    showHeight: false,
                    error: TopTrendingError.microCap),
              )
            : ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 10.sp),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  TopTrendingDataRes? data = provider.microCap?[index];
                  if (data == null) {
                    return const SizedBox();
                  }
                  return TopTrendingItem(
                    data: data,
                    index: index,
                    alertAdded: data.isAlertAdded == 1,
                    watchlistAdded: data.isWatchlistAdded == 1,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SpacerVerticel(height: 10);
                },
                itemCount: provider.microCap?.length ?? 0),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/top_trending_res.dart';
import 'package:stocks_news_new/providers/top_trending_provider.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../cap_heading.dart';

class NanoCapListView extends StatelessWidget {
  const NanoCapListView({super.key});
//
  @override
  Widget build(BuildContext context) {
    TopTrendingProvider provider = context.watch<TopTrendingProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const TrendingMarketCapHeading(
          leading: "Nano Cap",
          trailing: "\$30 million",
        ),
        !provider.isLoading &&
                (provider.nanoCap == null || provider.nanoCap?.isEmpty == true)
            ? const Center(
                child: ErrorDisplayWidget(
                    fontSize: 11,
                    showHeight: false,
                    error: TopTrendingError.nanoCap),
              )
            : ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 10.sp),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  TopTrendingDataRes? data = provider.nanoCap?[index];
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
                  return const SpacerVertical(height: 12);
                },
                itemCount: provider.nanoCap?.length ?? 0),
      ],
    );
  }
}

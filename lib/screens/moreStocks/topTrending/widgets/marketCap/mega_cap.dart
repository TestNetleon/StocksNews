import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/top_trending_res.dart';
import 'package:stocks_news_new/providers/top_trending_provider.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';

import '../cap_heading.dart';

class MegaCapListView extends StatelessWidget {
  const MegaCapListView({super.key});
//
  @override
  Widget build(BuildContext context) {
    TopTrendingProvider provider = context.watch<TopTrendingProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const TrendingMarketCapHeading(
          leading: "Mega Cap",
          trailing: "More than \$200 Billion",
        ),
        !provider.isLoading &&
                (provider.megaCap == null || provider.megaCap?.isEmpty == true)
            ? const Center(
                child: ErrorDisplayWidget(
                  fontSize: 11,
                  showHeight: false,
                  error: TopTrendingError.megaCap,
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 10.sp),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  TopTrendingDataRes? data = provider.megaCap?[index];
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
                  // return const SpacerVertical(height: 10);
                  return Divider(
                    color: ThemeColors.greyBorder,
                    height: 20.sp,
                  );
                },
                itemCount: provider.megaCap?.length ?? 0),
      ],
    );
  }
}

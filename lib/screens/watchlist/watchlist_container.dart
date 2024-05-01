import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/watchlist_res.dart';
import 'package:stocks_news_new/providers/watchlist_provider.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';

class WatchlistContainer extends StatelessWidget {
  const WatchlistContainer({super.key});

  @override
  Widget build(BuildContext context) {
    WatchlistProvider provider = context.watch<WatchlistProvider>();
//
    return RefreshControll(
      onRefresh: () => provider.getData(showProgress: true),
      canLoadmore: provider.canLoadMore,
      onLoadMore: () => provider.getData(loadMore: true),
      child: ListView.separated(
        itemCount: provider.data?.length ?? 0,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 16.sp),
        itemBuilder: (context, index) {
          WatchlistData data = provider.data![index];
          return WatchlistItem(index: index, data: data);
        },
        separatorBuilder: (BuildContext context, int index) {
          // return const SpacerVertical(height: 12);
          return Divider(
            color: ThemeColors.greyBorder,
            height: 12.sp,
          );
        },
      ),
    );
  }
}

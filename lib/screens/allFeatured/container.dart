import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/featured_ticker.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';

import '../../modals/home_alert_res.dart';
import 'item.dart';

class AllFeaturedContainer extends StatelessWidget {
  const AllFeaturedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    FeaturedTickerProvider provider = context.watch<FeaturedTickerProvider>();

    return RefreshControll(
      onRefresh: () async => provider.getFeaturedTicker(showProgress: true),
      canLoadmore: provider.canLoadMore,
      onLoadMore: () async => provider.getFeaturedTicker(loadMore: true),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
        itemBuilder: (context, index) {
          HomeAlertsRes? data = provider.data?[index];
          if (data == null) {
            return const SizedBox();
          }

          // if (index == 0 || index == 1) {
          //   return AllFeaturedItem(
          //     data: data,
          //   ).bigWidget();
          // }

          return AllFeaturedItem(
            data: data,
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: ThemeColors.greyBorder,
            height: 15.sp,
          );
        },
        itemCount: provider.data?.length ?? 0,
      ),
    );
  }
}

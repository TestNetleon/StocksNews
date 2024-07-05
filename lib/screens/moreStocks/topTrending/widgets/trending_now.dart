import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/top_trending_res.dart';
import 'package:stocks_news_new/providers/top_trending_provider.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TrendingNowListView extends StatefulWidget {
  const TrendingNowListView({super.key});

  @override
  State<TrendingNowListView> createState() => _TrendingNowListViewState();
}

class _TrendingNowListViewState extends State<TrendingNowListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<TopTrendingProvider>()
          .getNowRecentlyData(showProgress: false, type: "now", reset: true);

      FirebaseAnalytics.instance.logEvent(
        name: 'ScreensVisit',
        parameters: {'screen_name': "Top Trending"},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    TopTrendingProvider provider = context.watch<TopTrendingProvider>();
    List<TopTrendingDataRes>? dataList = provider.data;

    return RefreshControl(
      onRefresh: () async => provider.getNowRecentlyData(type: "now"),
      canLoadMore: provider.canLoadMore,
      onLoadMore: () async => provider.getNowRecentlyData(
        loadMore: true,
        type: "now",
      ),
      child: provider.isLoading
          ? const Loading()
          : provider.data == null
              ? ErrorDisplayWidget(
                  error: provider.error,
                  onRefresh: () => provider.getNowRecentlyData(type: "now"),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    Dimen.padding,
                    0,
                    Dimen.padding,
                    0,
                  ),
                  child: Column(
                    children: [
                      Visibility(
                        visible: !isEmpty(provider.textTop?.now),
                        child: ScreenTitle(
                          subTitle: provider.textTop?.now ?? "",
                          dividerPadding: EdgeInsets.zero,
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 10.sp),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          TopTrendingDataRes? data = dataList?[index];
                          if (data == null) {
                            return const SizedBox();
                          }
                          return TopTrendingItem(
                            type: "Now",
                            index: index,
                            data: data,
                            alertAdded: data.isAlertAdded == 1,
                            watchlistAdded: data.isWatchlistAdded == 1,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SpacerVertical(height: 12);
                          // return Divider(
                          //   color: ThemeColors.greyBorder,
                          //   height: 20.sp,
                          // );
                        },
                        itemCount: dataList?.length ?? 0,
                      ),
                    ],
                  ),
                ),
    );
  }
}

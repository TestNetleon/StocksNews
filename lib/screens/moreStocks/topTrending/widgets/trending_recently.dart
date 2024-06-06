import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/top_trending_res.dart';
import 'package:stocks_news_new/providers/top_trending_provider.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TrendingRecentlyListView extends StatefulWidget {
  const TrendingRecentlyListView({super.key});

  @override
  State<TrendingRecentlyListView> createState() =>
      _TrendingRecentlyListViewState();
}

class _TrendingRecentlyListViewState extends State<TrendingRecentlyListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TopTrendingProvider>().getNowRecentlyData(
          showProgress: false, type: "recently", reset: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    TopTrendingProvider provider = context.watch<TopTrendingProvider>();
    List<TopTrendingDataRes>? dataList = provider.data;

    return RefreshControl(
      onRefresh: () async => provider.getNowRecentlyData(type: "recently"),
      canLoadMore: provider.canLoadMore,
      onLoadMore: () async => provider.getNowRecentlyData(
        loadMore: true,
        type: "recently",
      ),
      child: provider.isLoading
          ? const Loading()
          : provider.data == null
              ? ErrorDisplayWidget(
                  error: provider.error,
                  onRefresh: () =>
                      provider.getNowRecentlyData(type: "recently"),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    Dimen.padding,
                    Dimen.padding,
                    Dimen.padding,
                    0,
                  ),
                  child: Column(
                    children: [
                      const SpacerVertical(height: 10),
                      Visibility(
                        visible: !isEmpty(provider.textTop?.recently),
                        child: HtmlWidget(
                          provider.textTop?.recently ?? "",
                          textStyle: stylePTSansRegular(
                            fontSize: 13,
                            color: ThemeColors.greyText,
                          ),
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
                            index: index,
                            data: data,
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
                        itemCount: dataList?.length ?? 0,
                      ),
                    ],
                  ),
                ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/top_trending_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/widgets/marketCap/large_cap.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/widgets/marketCap/medium_cap.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/widgets/marketCap/mega_cap.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/widgets/marketCap/micro_cap.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/widgets/marketCap/small_cap.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/widgets/trending_recently.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/technicalAnalysis/base.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'widgets/trending_now.dart';

//
class TopTrendingContainer extends StatefulWidget {
  const TopTrendingContainer({super.key});

  @override
  State<TopTrendingContainer> createState() => _TopTrendingContainerState();
}

class _TopTrendingContainerState extends State<TopTrendingContainer> {
  List<TabData> tabs = [
    TabData(tabName: "Trending Now"),
    TabData(tabName: "Trending Recently"),
    TabData(tabName: "Trending By Market Cap"),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<TopTrendingProvider>()
          .getNowRecentlyData(showProgress: false, type: "now", reset: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    TopTrendingProvider provider = context.watch<TopTrendingProvider>();
    return BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      appBar: const AppBarHome(
          isPopback: true, showTrailing: false, canSearch: true),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            Dimen.padding.sp, Dimen.padding.sp, Dimen.padding.sp, 0),
        child: Column(
          children: [
            // const ScreenTitle(title: "Social Trending Stocks"),
            Expanded(
              child: CustomTabContainerNEW(
                onChange: (index) =>
                    provider.onTabChanged(index: index, showProgress: false),
                tabs: List.generate(
                  tabs.length,
                  (index) => tabs[index].tabName,
                ),
                tabsPadding: EdgeInsets.symmetric(horizontal: 0.sp),
                widgets: List.generate(
                  tabs.length,
                  (index) => RefreshControll(
                    onRefresh: () => index == 2
                        ? provider.getCapData()
                        : provider.getNowRecentlyData(
                            type: index == 0
                                ? "now"
                                : index == 1
                                    ? "recently"
                                    : "cap",
                          ),
                    canLoadmore: index == 2 ? false : provider.canLoadMore,
                    onLoadMore: () => provider.getNowRecentlyData(
                      loadMore: true,
                      type: index == 0
                          ? "now"
                          : index == 1
                              ? "recently"
                              : "cap",
                    ),
                    child: provider.isLoading
                        ? Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(
                                  color: ThemeColors.accent,
                                ),
                                const SpacerHorizontal(width: 5),
                                Flexible(
                                  child: Text(
                                    "Preparing your data.. Please wait.",
                                    style: stylePTSansRegular(),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : index == 2 &&
                                !provider.isLoading &&
                                (provider.capData == null ||
                                    provider.capData?.isEmpty == true)
                            ? Center(
                                child: ErrorDisplayWidget(
                                  error: TopTrendingError.cap,
                                  onRefresh: () => provider.getCapData(),
                                ),
                              )
                            : index == 0 &&
                                    index == 1 &&
                                    !provider.isLoading &&
                                    (provider.data == null ||
                                        provider.data?.isEmpty == true)
                                ? Center(
                                    child: ErrorDisplayWidget(
                                      error: index == 0
                                          ? TopTrendingError.now
                                          : TopTrendingError.now,
                                    ),
                                  )
                                : SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const SpacerVertical(height: 10),
                                        // Divider(
                                        //     color: ThemeColors.border,
                                        //     height: 10.sp),
                                        Text(
                                          index == 0
                                              ? 'A stock is considered "trending" if it was talked about more in the last 24 hours than it was in the prior 24 hour are trending on Twitter, Reddit and StockTwits.'
                                              : index == 1
                                                  ? 'A stock is considered "trending" if it was talked about more in the last 24-48 hours are trending on Twitter, Reddit and StockTwits.'
                                                  : 'This page lists stocks that are trending on Twitter, Reddit and StockTwits today, grouped by market capitalization.',
                                          style:
                                              stylePTSansRegular(fontSize: 12),
                                        ),
                                        Visibility(
                                          visible: index != 0 && index != 2,
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(top: 10.sp),
                                            child: Text(
                                              'This list is ordered based on how large the change is. A very obscure stock suddenly hitting the headlines will jump to the top of this list. Stocks frequently in public discussion (GME, AAPL, etc.) will tend towards the bottom of this list, because the total volume of discussion is mostly constant.',
                                              style: stylePTSansRegular(
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: index == 0,
                                          child: const TrendingNowListView(),
                                        ),
                                        Visibility(
                                          visible: index == 1,
                                          child:
                                              const TrendingRecentlyListView(),
                                        ),
                                        Visibility(
                                          visible: index == 2,
                                          child: const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              MegaCapListView(),
                                              LargeCapListView(),
                                              MediumCapListView(),
                                              SmallCapListView(),
                                              MicroCapListView(),
                                              // NanoCapListView(),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

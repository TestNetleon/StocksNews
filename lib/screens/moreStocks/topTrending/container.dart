// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/top_trending_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/widgets/marketCap/large_cap.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/widgets/marketCap/medium_cap.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/widgets/marketCap/mega_cap.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/widgets/marketCap/micro_cap.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/widgets/marketCap/small_cap.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/widgets/trending_by_market_cap.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/widgets/trending_recently.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/technicalAnalysis/base.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'widgets/trending_now.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

//
class TopTrendingContainer extends StatelessWidget {
  const TopTrendingContainer({super.key});

  // @override
  @override
  Widget build(BuildContext context) {
    List<TabData> tabs = [
      TabData(tabName: "Trending Now"),
      TabData(tabName: "Trending Recently"),
      TabData(tabName: "Trending By Market Cap"),
    ];
    return BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      appBar: const AppBarHome(isPopback: true, canSearch: true),
      body: Padding(
        padding: EdgeInsets.zero,
        // padding: EdgeInsets.fromLTRB(
        //     Dimen.padding.sp, Dimen.padding.sp, Dimen.padding.sp, 0),
        child: CommonTabContainer(
          scrollable: true,
          // onChange: (index) =>
          //     provider.onTabChanged(index: index, showProgress: false),
          tabs: List.generate(
            tabs.length,
            (index) => tabs[index].tabName,
          ),
          padding: EdgeInsets.symmetric(horizontal: 0.sp),
          widgets: const [
            TrendingNowListView(),
            TrendingRecentlyListView(),
            TrendingByMarketCap()
          ],
          // widgets: List.generate(
          //   tabs.length,
          //   (index) => RefreshControl(
          //     onRefresh: () async => index == 2
          //         ? provider.getCapData()
          //         : provider.getNowRecentlyData(
          //             type: index == 0
          //                 ? "now"
          //                 : index == 1
          //                     ? "recently"
          //                     : "cap",
          //           ),
          //     canLoadMore: index == 2 ? false : provider.canLoadMore,
          //     onLoadMore: () async => provider.getNowRecentlyData(
          //       loadMore: true,
          //       type: index == 0
          //           ? "now"
          //           : index == 1
          //               ? "recently"
          //               : "cap",
          //     ),
          //     child: provider.isLoading
          //         ? const Loading()
          //         // Center(
          //         //     child: Row(
          //         //       mainAxisSize: MainAxisSize.min,
          //         //       children: [
          //         //         const CircularProgressIndicator(
          //         //           color: ThemeColors.accent,
          //         //         ),
          //         //         const SpacerHorizontal(width: 5),
          //         //         Flexible(
          //         //           child: Text(
          //         //             "Preparing your data.. Please wait.",
          //         //             style: stylePTSansRegular(),
          //         //           ),
          //         //         ),
          //         //       ],
          //         //     ),
          //         //   )
          //         : index == 2 &&
          //                 !provider.isLoading &&
          //                 (provider.capData == null ||
          //                     provider.capData?.isEmpty == true)
          //             ? Center(
          //                 child: ErrorDisplayWidget(
          //                   error: TopTrendingError.cap,
          //                   onRefresh: () => provider.getCapData(),
          //                 ),
          //               )
          //             : index == 0 &&
          //                     index == 1 &&
          //                     !provider.isLoading &&
          //                     (provider.data == null ||
          //                         provider.data?.isEmpty == true)
          //                 ? Center(
          //                     child: ErrorDisplayWidget(
          //                       error: index == 0
          //                           ? TopTrendingError.now
          //                           : TopTrendingError.now,
          //                     ),
          //                   )
          //                 : SingleChildScrollView(
          //                     child: Column(
          //                       children: [
          //                         const SpacerVertical(height: 10),
          //                         // Divider(
          //                         //     color: ThemeColors.border,
          //                         //     height: 10.sp),
          //                         Visibility(
          //                           visible: index == 0 || index == 2,
          //                           child: Text(
          //                             index == 0
          //                                 ? provider.textTop?.now ?? ""
          //                                 : index == 2
          //                                     ? provider.textTop?.cap ?? ""
          //                                     : "",
          //                             style: stylePTSansRegular(
          //                                 fontSize: 13,
          //                                 color: ThemeColors.greyText),
          //                           ),
          //                         ),
          //                         Visibility(
          //                           visible: index != 0 && index != 2,
          //                           child: HtmlWidget(
          //                             provider.textTop?.recently ?? "",
          //                             textStyle: stylePTSansRegular(
          //                                 fontSize: 13,
          //                                 color: ThemeColors.greyText),
          //                           ),
          //                         ),
          //                         Visibility(
          //                           visible: index == 0,
          //                           child: const TrendingNowListView(),
          //                         ),
          //                         Visibility(
          //                           visible: index == 1,
          //                           child: const TrendingRecentlyListView(),
          //                         ),
          //                         Visibility(
          //                           visible: index == 2,
          //                           child: Column(
          //                             crossAxisAlignment:
          //                                 CrossAxisAlignment.start,
          //                             mainAxisSize: MainAxisSize.min,
          //                             children: [
          //                               const MegaCapListView(),
          //                               const LargeCapListView(),
          //                               const MediumCapListView(),
          //                               const SmallCapListView(),
          //                               const MicroCapListView(),
          //                               // NanoCapListView(),
          //                               if (provider.extra?.disclaimer != null)
          //                                 DisclaimerWidget(
          //                                   data: provider.extra!.disclaimer!,
          //                                 ),
          //                             ],
          //                           ),
          //                         )
          //                       ],
          //                     ),
          //                   ),
          //   ),
          // ),
        ),
      ),
    );
  }
}

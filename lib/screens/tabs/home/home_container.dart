import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/home_partial_loading_widget.dart';
// ignore: unused_import
import 'package:stocks_news_new/screens/tabs/home/widgets/myAlerts/index.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/myAlerts/index_copy.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
// import 'package:upgrader/upgrader.dart';
import '../../../widgets/custom/refresh_indicator.dart';
import 'widgets/home_inner_tabs.dart';
import 'widgets/sliderNews/slider.dart';
import 'widgets/stockBuzz/index.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();

    if (!provider.isLoadingSlider &&
        provider.statusSlider != Status.ideal &&
        !provider.isLoadingHomeAlert &&
        provider.statusHomeAlert != Status.ideal &&
        !provider.isLoadingTrending &&
        provider.statusTrending != Status.ideal &&
        provider.homeSliderRes == null &&
        provider.homeAlertData == null &&
        provider.homeTrendingRes == null) {
      return ErrorDisplayWidget(
        error: Const.errSomethingWrong,
        onRefresh: () => provider.refreshData(null),
      );
    }
    return CommonRefreshIndicator(
      onRefresh: () async {
        provider.refreshData(null);
      },
      child: DefaultTextStyle(
        style: styleGeorgiaBold(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const HomeTopNewsSlider(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimen.padding.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!((provider.homeTrendingRes?.popular.isEmpty == true ||
                            provider.homeTrendingRes?.popular == null ||
                            provider.homeTrendingRes == null) &&
                        provider.statusTrending != Status.loading))
                      const StockInBuzz(),
                    const HomeMyAlerts(),
                    HomePartialLoading(
                      loading: provider.isLoadingTrending,
                      error: provider.statusTrending != Status.ideal &&
                              !provider.isLoadingTrending &&
                              provider.homeTrendingRes == null
                          ? provider.homeTrendingRes?.gainers.isEmpty == true
                              ? HomeError.gainers
                              : provider.homeTrendingRes?.losers.isEmpty == true
                                  ? HomeError.loosers
                                  : HomeError.trending
                          : null,
                      onRefresh: provider.refreshWithCheck,
                      child: const HomeInnerTabs(),
                    ),

                    // HomePartialLoading(
                    //   loading: provider.isLoadingIpo,
                    //   error: !provider.isLoadingIpo && provider.ipoRes == null
                    //       ? HomeError.ipo
                    //       : null,
                    //   onRefresh: provider.refreshWithCheck,
                    //   child: const IpoIndex(),
                    // ),
                    // Visibility(
                    //   visible: provider.focusRes != null,
                    //   child: HomePartialLoading(
                    //     loading: provider.isLoadingStockFocus,
                    //     error: null,
                    //     onRefresh: provider.refreshWithCheck,
                    //     child: const StocksInFocus(),
                    //   ),
                    // ),
                    // const SpacerVertical(height: 10),
                    // const HomeBanner(),
                    // HomePartialLoading(
                    //   loading: provider.isLoadingSentiment,
                    //   error: !provider.isLoadingSentiment &&
                    //           provider.homeSentimentRes == null
                    //       ? HomeError.sentiment
                    //       : null,
                    //   onRefresh: provider.refreshWithCheck,
                    //   child: const SentimentsGraph(),
                    // ),
                    // HomePartialLoading(
                    //   loading: provider.isLoadingInsider,
                    //   error: !provider.isLoadingInsider &&
                    //           provider.homeInsiderRes == null
                    //       ? provider.homeInsiderRes?.news.isEmpty == true
                    //           ? HomeError.news
                    //           : provider.homeInsiderRes?.recentMentions
                    //                       ?.isEmpty ==
                    //                   true
                    //               ? HomeError.mentions
                    //               : HomeError.insiderTrading
                    //       : null,
                    //   onRefresh: provider.refreshWithCheck,
                    //   child: const Column(
                    //     children: [
                    //       MostRecentMentions(),
                    //       // InsiderSocialTabs(),
                    //       // SpacerVertical(),
                    //       // HomeNewsItem(),
                    //       // SpacerVertical(),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/search_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/home_news_item.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/home_partial_loading_widget.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/insider_social_tabs.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/recentMentions/container.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/sentiments_graph.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
import 'package:stocks_news_new/widgets/text_input_field_search_common.dart';
import 'package:upgrader/upgrader.dart';
//
import 'widgets/home_inner_tabs.dart';
import 'widgets/sliderNews/slider.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();

    return RefreshIndicator(
      onRefresh: () async {
        provider.refreshData();
        // provider.getHomeData();
        // provider.getHomeNewData();
      },
      child: DefaultTextStyle(
        style: styleGeorgiaBold(),
        child: UpgradeAlert(
          upgrader: Upgrader(
            // dialogStyle: UpgradeDialogStyle.cupertino,
            showIgnore: false,
            showLater: Platform.isIOS,
            durationUntilAlertAgain: Duration.zero,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                Dimen.padding.sp,
                Dimen.padding.sp,
                Dimen.padding.sp,
                0,
              ),
              child: Column(
                children: [
                  TextInputFieldSearchCommon(
                    hintText: "Search symbol, company name or news",
                    searching: context.watch<SearchProvider>().isLoading,
                    onChanged: (text) {},
                  ),
                  Visibility(
                    visible: provider.homeSliderRes?.sliderPosts?.isNotEmpty ??
                        false,
                    child: Container(
                      margin: EdgeInsets.only(top: 20.sp),
                      child: const HomeTopNewsSlider(),
                    ),
                  ),
                  HomePartialLoading(
                    loading: provider.isLoadingSentiment,
                    error: !provider.isLoadingSentiment &&
                            provider.homeSentimentRes == null
                        ? HomeError.sentiment
                        : null,
                    onRefresh: provider.refreshWithCheck,
                    child: const SentimentsGraph(),
                  ),
                  HomePartialLoading(
                    loading: provider.isLoadingTrending,
                    error: !provider.isLoadingTrending &&
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
                  HomePartialLoading(
                    loading: provider.isLoadingInsider,
                    error: !provider.isLoadingInsider &&
                            provider.homeInsiderRes == null
                        ? provider.homeInsiderRes?.news.isEmpty == true
                            ? HomeError.news
                            : provider.homeInsiderRes?.recentMentions
                                        ?.isEmpty ==
                                    true
                                ? HomeError.mentions
                                : HomeError.insiderTrading
                        : null,
                    onRefresh: provider.refreshWithCheck,
                    child: const Column(
                      children: [
                        MostRecentMentions(),
                        InsiderSocialTabs(),
                        SpacerVerticel(),
                        HomeNewsItem(),
                        SpacerVerticel(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

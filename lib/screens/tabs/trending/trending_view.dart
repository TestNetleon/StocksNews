import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/trending_provider.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/most_bearish.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/most_bullish.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/trending_stories.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
import 'package:stocks_news_new/widgets/text_input_field_search_common.dart';

import 'widgets/trending_partial_loading.dart';
import 'widgets/trending_sectors.dart';

//
class TrendingView extends StatefulWidget {
  const TrendingView({super.key});

  @override
  State<TrendingView> createState() => _TrendingViewState();
}

class _TrendingViewState extends State<TrendingView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // context.read<TrendingProvider>().getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    TrendingProvider provider = context.watch<TrendingProvider>();

    return provider.isLoadingBullish
        ? Center(
            child: Text(
              "We are preparing…",
              style: styleGeorgiaRegular(
                color: Colors.white,
              ),
            ),
          )
        : RefreshIndicator(
            onRefresh: () async {
              await provider.refreshData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  Dimen.padding.sp,
                  Dimen.padding.sp,
                  Dimen.padding.sp,
                  0,
                ),
                child: Column(
                  children: [
                    const ScreenTitle(title: "Trending"),
                    TextInputFieldSearchCommon(
                      hintText: "Search symbol, company name or news",
                      onChanged: (text) {},
                    ),
                    // const SpacerVerticel(),
                    // const TrendingGraphTabs(),
                    // const SentimentsGraph(),
                    // const SpacerVerticel(),
                    // const TrendingFilter(),
                    const SpacerVerticel(),
                    TrendingPartialLoading(
                      loading: provider.isLoadingBullish,
                      error: !provider.isLoadingBullish &&
                              provider.mostBullish?.mostBullish?.isEmpty == true
                          ? TrendingError.bullish
                          : null,
                      onRefresh: provider.refreshWithCheck,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20.sp),
                        child: const MostBullish(),
                      ),
                    ),

                    TrendingPartialLoading(
                      loading: provider.isLoadingBearish,
                      error: !provider.isLoadingBearish &&
                              (provider.mostBearish == null ||
                                  provider.mostBearish?.mostBearish?.isEmpty ==
                                      true)
                          ? TrendingError.bearish
                          : null,
                      onRefresh: provider.refreshWithCheck,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20.sp),
                        child: const MostBearish(),
                      ),
                    ),

                    TrendingPartialLoading(
                      loading: provider.isLoadingStories,
                      error: !provider.isLoadingStories &&
                              provider.trendingStories?.sectors?.isEmpty == true
                          ? TrendingError.sectors
                          : null,
                      onRefresh: provider.refreshWithCheck,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20.sp),
                        child: const TrendingSectors(),
                      ),
                    ),

                    TrendingPartialLoading(
                      loading: provider.isLoadingStories,
                      error: !provider.isLoadingStories &&
                              provider.trendingStories?.generalNews?.isEmpty ==
                                  true
                          ? TrendingError.stories
                          : null,
                      onRefresh: provider.refreshWithCheck,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20.sp),
                        child: const TrendingStories(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

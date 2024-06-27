import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/trending_industries.dart';
import 'package:stocks_news_new/providers/trending_provider.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/most_bearish.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/most_bullish.dart';

import 'package:stocks_news_new/screens/tabs/trending/widgets/trending_stories.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/loading.dart';

import '../../trendingIndustries/index.dart';
import 'widgets/trending_partial_loading.dart';
import 'widgets/trending_sectors.dart';

class TrendingView extends StatefulWidget {
  const TrendingView({
    super.key,
    this.index = 0,
  });
  final int index;
  @override
  State<TrendingView> createState() => _TrendingViewState();
}

class _TrendingViewState extends State<TrendingView> {
  bool refresh = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // context.read<TrendingProvider>().getData();
      log("TRENDING INDEX   => ${widget.index}");
    });
  }

  @override
  Widget build(BuildContext context) {
    TrendingProvider provider = context.watch<TrendingProvider>();

    return provider.isLoadingBullish && provider.mostBullish == null
        ? const Loading()
        : CustomTabContainerNEW(
            scrollable: true,
            // initialIndex: widget.index,
            tabs: List.generate(
              provider.tabs.length,
              (index) => provider.tabs[index],
            ),
            widgets: List.generate(
              provider.tabs.length,
              (index) {
                if (index == 0) {
                  return CommonRefreshIndicator(
                    onRefresh: () async {
                      await provider.getMostBullish();
                    },
                    child: TrendingTabWidget(
                      index: 0,
                      content: TrendingPartialLoading(
                        loading: provider.isLoadingBullish,
                        error: !provider.isLoadingBullish &&
                                (provider.mostBullish?.mostBullish == null ||
                                    provider.mostBullish?.mostBullish
                                            ?.isEmpty ==
                                        true)
                            ? TrendingError.bullish
                            : null,
                        onRefresh: provider.refreshWithCheck,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.sp),
                          child: const MostBullish(),
                        ),
                      ),
                    ),
                  );
                }

                if (index == 1) {
                  return CommonRefreshIndicator(
                    onRefresh: () async {
                      await provider.getMostBearish();
                    },
                    child: TrendingTabWidget(
                      index: 1,
                      content: TrendingPartialLoading(
                        loading: provider.isLoadingBearish,
                        error: provider.statusBearish != Status.ideal &&
                                !provider.isLoadingBearish &&
                                (provider.mostBearish == null ||
                                    provider.mostBearish?.mostBearish
                                            ?.isEmpty ==
                                        true)
                            ? TrendingError.bearish
                            : null,
                        onRefresh: provider.refreshWithCheck,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.sp),
                          child: const MostBearish(),
                        ),
                      ),
                    ),
                  );
                }

                if (index == 2) {
                  return CommonRefreshIndicator(
                    onRefresh: () async {
                      provider.getTrendingStories();
                    },
                    child: TrendingTabWidget(
                      index: 2,
                      content: TrendingPartialLoading(
                        loading: provider.isLoadingStories,
                        error: provider.statusStories != Status.ideal &&
                                !provider.isLoadingStories &&
                                (provider.trendingStories?.sectors == null ||
                                    provider.trendingStories?.sectors
                                            ?.isEmpty ==
                                        true)
                            ? TrendingError.sectors
                            : null,
                        onRefresh: provider.refreshWithCheck,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.sp),
                          child: const TrendingSectors(),
                        ),
                      ),
                    ),
                  );
                }

                if (index == 3) {
                  return CommonRefreshIndicator(
                    onRefresh: () async {
                      provider.getTrendingStories();
                    },
                    child: TrendingTabWidget(
                      index: 2,
                      content: TrendingPartialLoading(
                        loading: provider.isLoadingStories,
                        error: provider.statusStories != Status.ideal &&
                                !provider.isLoadingStories &&
                                (provider.trendingStories?.generalNews ==
                                        null ||
                                    provider.trendingStories?.generalNews
                                            ?.isEmpty ==
                                        true)
                            ? TrendingError.stories
                            : null,
                        onRefresh: provider.refreshWithCheck,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.sp),
                          child: const TrendingStories(),
                        ),
                      ),
                    ),
                  );
                }

                if (index == 4) {
                  return const TrendingTabWidget(
                    index: 4,
                    content: TrendingIndustries(),
                  );
                }

                return Container();
              },
            ),
          );
  }
}

class TrendingTabWidget extends StatefulWidget {
  final Widget content;
  final int index;

  const TrendingTabWidget({
    required this.content,
    super.key,
    required this.index,
  });

  @override
  State<TrendingTabWidget> createState() => _TrendingTabWidgetState();
}

class _TrendingTabWidgetState extends State<TrendingTabWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  _getData() {
    TrendingProvider provider = context.read<TrendingProvider>();
    TrendingIndustriesProvider trendingIndustriesProvider =
        context.read<TrendingIndustriesProvider>();
    if (widget.index == 0 &&
        (provider.mostBullish?.mostBullish == null ||
            provider.mostBullish?.mostBullish?.isEmpty == true)) {
      // provider.getMostBullish(showProgress: true);
    } else if (widget.index == 1 &&
        (provider.mostBearish?.mostBearish == null ||
            provider.mostBearish?.mostBearish?.isEmpty == true)) {
      provider.getMostBearish();
    } else if (widget.index == 2 &&
        (provider.trendingStories?.sectors == null ||
            provider.trendingStories?.sectors?.isEmpty == true)) {
      provider.getTrendingStories();
    } else if (widget.index == 3 &&
        (provider.trendingStories?.generalNews == null ||
            provider.trendingStories?.generalNews?.isEmpty == true)) {
      provider.getTrendingStories();
    } else if (widget.index == 4 &&
        (trendingIndustriesProvider.data == null ||
            trendingIndustriesProvider.data?.isEmpty == true)) {
      trendingIndustriesProvider.getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.content;
  }
}

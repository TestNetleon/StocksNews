import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/trending_industries.dart';
import 'package:stocks_news_new/providers/trending_provider.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/most_bearish.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/most_bullish.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/trending_stories.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

import '../../trendingIndustries/index.dart';
import 'widgets/trending_partial_loading.dart';
import 'widgets/trending_sectors.dart';

//

// class TrendingView extends StatefulWidget {
//   const TrendingView({super.key});

//   @override
//   State<TrendingView> createState() => _TrendingViewState();
// }

// class _TrendingViewState extends State<TrendingView> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       // context.read<TrendingProvider>().getData();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     TrendingProvider provider = context.watch<TrendingProvider>();

//     return provider.isLoadingBullish
//         ? Center(
//             child: Text(
//               "We are preparing…",
//               style: styleGeorgiaRegular(
//                 color: Colors.white,
//               ),
//             ),
//           )
//         : RefreshIndicator(
//             onRefresh: () async {
//               await provider.refreshData();
//             },
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(
//                   Dimen.padding.sp,
//                   Dimen.padding.sp,
//                   Dimen.padding.sp,
//                   0,
//                 ),
//                 child: Column(
//                   children: [
//                     // const ScreenTitle(title: "Trending"),
//                     // TextInputFieldSearchCommon(
//                     //   hintText: "Search symbol, company name or news",
//                     //   onChanged: (text) {},
//                     // ),
//                     // const SpacerVertical(),
//                     // const TrendingGraphTabs(),
//                     // const SentimentsGraph(),
//                     // const SpacerVertical(),
//                     // const TrendingFilter(),
//                     // const SpacerVertical(),
//                     TrendingPartialLoading(
//                       loading: provider.isLoadingBullish,
//                       error: !provider.isLoadingBullish &&
//                               provider.mostBullish?.mostBullish?.isEmpty == true
//                           ? TrendingError.bullish
//                           : null,
//                       onRefresh: provider.refreshWithCheck,
//                       child: Container(
//                         margin: EdgeInsets.only(bottom: 20.sp),
//                         child: const MostBullish(),
//                       ),
//                     ),

//                     TrendingPartialLoading(
//                       loading: provider.isLoadingBearish,
//                       error: !provider.isLoadingBearish &&
//                               (provider.mostBearish == null ||
//                                   provider.mostBearish?.mostBearish?.isEmpty ==
//                                       true)
//                           ? TrendingError.bearish
//                           : null,
//                       onRefresh: provider.refreshWithCheck,
//                       child: Container(
//                         margin: EdgeInsets.only(bottom: 20.sp),
//                         child: const MostBearish(),
//                       ),
//                     ),

//                     TrendingPartialLoading(
//                       loading: provider.isLoadingStories,
//                       error: !provider.isLoadingStories &&
//                               provider.trendingStories?.sectors?.isEmpty == true
//                           ? TrendingError.sectors
//                           : null,
//                       onRefresh: provider.refreshWithCheck,
//                       child: Container(
//                         margin: EdgeInsets.only(bottom: 10.sp),
//                         child: const TrendingSectors(),
//                       ),
//                     ),

//                     TrendingPartialLoading(
//                       loading: provider.isLoadingStories,
//                       error: !provider.isLoadingStories &&
//                               provider.trendingStories?.generalNews?.isEmpty ==
//                                   true
//                           ? TrendingError.stories
//                           : null,
//                       onRefresh: provider.refreshWithCheck,
//                       child: Container(
//                         margin: EdgeInsets.only(bottom: 20.sp),
//                         child: const TrendingStories(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//   }
// }

class TrendingView extends StatefulWidget {
  const TrendingView({super.key});

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
    });
  }

  @override
  Widget build(BuildContext context) {
    TrendingProvider provider = context.watch<TrendingProvider>();

    return provider.isLoadingBullish && provider.mostBullish == null
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  Images.progressGIF,
                  width: 100,
                  height: 100,
                ),
                Text(
                  "We are preparing data for you. Please wait...",
                  textAlign: TextAlign.center,
                  style: styleGeorgiaRegular(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        : CustomTabContainerNEW(
            scrollable: true,
            tabs: List.generate(
                provider.tabs.length, (index) => provider.tabs[index]),
            widgets: List.generate(
              provider.tabs.length,
              (index) {
                if (index == 0) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      provider.getMostBullish(showProgress: true);
                    },
                    child: TrendingTabWidget(
                      index: 0,
                      content: TrendingPartialLoading(
                        loading: false,
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
                  return RefreshIndicator(
                    onRefresh: () async {
                      provider.getMostBearish();
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
                  return RefreshIndicator(
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
                  return RefreshIndicator(
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

    // RefreshIndicator(
    //     onRefresh: () async {
    //       await provider.refreshData();
    //     },
    //     child: SingleChildScrollView(
    //       physics: const AlwaysScrollableScrollPhysics(),
    //       child: Padding(
    //         padding: EdgeInsets.fromLTRB(
    //           Dimen.padding.sp,
    //           Dimen.padding.sp,
    //           Dimen.padding.sp,
    //           0,
    //         ),
    //         child: Column(
    //           children: [
    //             // const ScreenTitle(title: "Trending"),
    //             // TextInputFieldSearchCommon(
    //             //   hintText: "Search symbol, company name or news",
    //             //   onChanged: (text) {},
    //             // ),
    //             // const SpacerVertical(),
    //             // const TrendingGraphTabs(),
    //             // const SentimentsGraph(),
    //             // const SpacerVertical(),
    //             // const TrendingFilter(),
    //             // const SpacerVertical(),
    //             TrendingPartialLoading(
    //               loading: provider.isLoadingBullish,
    //               error: !provider.isLoadingBullish &&
    //                       provider.mostBullish?.mostBullish?.isEmpty == true
    //                   ? TrendingError.bullish
    //                   : null,
    //               onRefresh: provider.refreshWithCheck,
    //               child: Container(
    //                 margin: EdgeInsets.only(bottom: 20.sp),
    //                 child: const MostBullish(),
    //               ),
    //             ),

    //             TrendingPartialLoading(
    //               loading: provider.isLoadingBearish,
    //               error: !provider.isLoadingBearish &&
    //                       (provider.mostBearish == null ||
    //                           provider.mostBearish?.mostBearish?.isEmpty ==
    //                               true)
    //                   ? TrendingError.bearish
    //                   : null,
    //               onRefresh: provider.refreshWithCheck,
    //               child: Container(
    //                 margin: EdgeInsets.only(bottom: 20.sp),
    //                 child: const MostBearish(),
    //               ),
    //             ),

    //             TrendingPartialLoading(
    //               loading: provider.isLoadingStories,
    //               error: !provider.isLoadingStories &&
    //                       provider.trendingStories?.sectors?.isEmpty == true
    //                   ? TrendingError.sectors
    //                   : null,
    //               onRefresh: provider.refreshWithCheck,
    //               child: Container(
    //                 margin: EdgeInsets.only(bottom: 10.sp),
    //                 child: const TrendingSectors(),
    //               ),
    //             ),

    //             TrendingPartialLoading(
    //               loading: provider.isLoadingStories,
    //               error: !provider.isLoadingStories &&
    //                       provider.trendingStories?.generalNews?.isEmpty ==
    //                           true
    //                   ? TrendingError.stories
    //                   : null,
    //               onRefresh: provider.refreshWithCheck,
    //               child: Container(
    //                 margin: EdgeInsets.only(bottom: 20.sp),
    //                 child: const TrendingStories(),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
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

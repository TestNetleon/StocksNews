import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/news_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/technicalAnalysis/base.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/custom_tab_item_label.dart';
import 'package:stocks_news_new/screens/tabs/news/news_list.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
//
import 'featuredNews/container.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int i = 1;
  List<TabData> tabs = [
    TabData(tabName: "Featured"),
    TabData(tabName: "From Reuters"),
  ];
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    if (_tabController != null) _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController == null) return const SizedBox();
    return BaseContainer(
      drawer: const BaseDrawer(),
      appbar: const AppBarHome(
        canSearch: true,
      ),
      // body: NewsList(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimen.padding.sp,
          Dimen.padding.sp,
          Dimen.padding.sp,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // const ScreenTitle(title: "Stock Market News"),
            // const NewsHeaderStocks(),

            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: ThemeColors.accent, width: 1.sp),
                ),
              ),
              child: Row(
                children: [
                  CustomTabLabel(
                    "Featured",
                    selected: _selectedIndex == 0,
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                      if (context.read<FeaturedNewsProvider>().data?.isEmpty ==
                              true ||
                          context.read<FeaturedNewsProvider>().data == null) {
                        context
                            .read<FeaturedNewsProvider>()
                            .getNews(showProgress: true);
                      }
                    },
                  ),
                  VerticalDivider(
                    color: ThemeColors.accent,
                    width: 1.sp,
                    thickness: 1.sp,
                  ),
                  CustomTabLabel(
                    "From Sources",
                    selected: _selectedIndex == 1,
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                      if (context.read<NewsProvider>().data?.isEmpty == true ||
                          context.read<NewsProvider>().data == null) {
                        context
                            .read<NewsProvider>()
                            .getNews(showProgress: true);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SpacerVerticel(height: 10),
            Expanded(
                child: _selectedIndex == 0
                    ? const FeaturedNewsList()
                    : const NewsList()),

            // Expanded(child: NewsList()),
            // Expanded(
            //   child: CustomTabContainer(
            //     showDivider: true,
            //     onChange: (index) {
            //       if (index == 0 &&
            //           (context.read<FeaturedNewsProvider>().data?.isEmpty ==
            //                   true ||
            //               context.read<FeaturedNewsProvider>().data == null)) {
            //         context
            //             .read<FeaturedNewsProvider>()
            //             .getNews(showProgress: true);
            //       } else if (index == 1 &&
            //           (context.read<NewsProvider>().data?.isEmpty == true ||
            //               context.read<NewsProvider>().data == null)) {
            //         while (i == 1) {
            //           context.read<NewsProvider>().getNews(showProgress: true);
            //           i = 2;
            //           setState(() {});
            //         }
            //       }
            //     },
            //     tabs:
            //         List.generate(tabs.length, (index) => tabs[index].tabName),
            //     widgets: const [
            //       FeaturedNewsList(),
            //       NewsList(),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// class CustomTab extends StatelessWidget {
//   final String label;
//   final bool divider;
//   const CustomTab({
//     required this.label,
//     this.divider = true,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Tab(
//       child: Row(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 12.sp),
//             child: Text(label),
//           ),
//           Visibility(
//             visible: divider,
//             child: const TabDivider(),
//           ),
//         ],
//       ),
//     );
//   }
// }

class TabDivider extends StatelessWidget {
  const TabDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 1.sp,
      color: ThemeColors.dividerDark,
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/news_provider.dart';
// import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/custom_tab_item_label.dart';
// import 'package:stocks_news_new/screens/tabs/news/featuredNews/container.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';
// import 'package:stocks_news_new/widgets/error_display_common.dart';
// import 'package:stocks_news_new/widgets/screen_title.dart';
// import 'package:stocks_news_new/widgets/spacer_verticle.dart';

// class News extends StatefulWidget {
//   const News({super.key});

//   @override
//   State<News> createState() => _NewsState();
// }

// class _NewsState extends State<News> {
//   ScrollController _controller = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     FeaturedNewsProvider provider = context.watch<FeaturedNewsProvider>();

//     return BaseContainer(
//       drawer: const BaseDrawer(),
//       appbar: const AppBarHome(),
//       body: Padding(
//         padding: EdgeInsets.fromLTRB(
//           Dimen.padding.sp,
//           Dimen.padding.sp,
//           Dimen.padding.sp,
//           0,
//         ),
//         child: provider.isLoading
//             ? Center(
//                 child: Text(
//                   "We are preparing …",
//                   style: styleGeorgiaRegular(
//                     color: Colors.white,
//                   ),
//                 ),
//               )
//             : !provider.isLoading && provider.tabs == null
//                 ? ErrorDisplayWidget(
//                     error: provider.error,
//                   )
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       const ScreenTitle(title: "Stock Market News"),
//                       Container(
//                         decoration: BoxDecoration(
//                           border: Border(
//                             bottom: BorderSide(
//                               color: ThemeColors.accent,
//                               width: 1.sp,
//                             ),
//                           ),
//                         ),
//                         child: SingleChildScrollView(
//                           controller: _controller,
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: List.generate(
//                               provider.tabs?.length ?? 0,
//                               (index) {
//                                 return CustomTabLabelNews(
//                                   provider.tabs?[index].name ?? "",
//                                   selected: provider.selectedIndex == index,
//                                   onTap: () {
//                                     provider.tabChange(index);
//                                     // Calculate the offset to scroll to the selected tab
//                                     double offset = index * 100.0;
//                                     _controller.animateTo(
//                                       offset,
//                                       duration:
//                                           const Duration(milliseconds: 500),
//                                       curve: Curves.easeInOut,
//                                     );
//                                   },
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SpacerVerticel(height: 10),
//                       const Expanded(child: FeaturedNewsList()),
//                     ],
//                   ),
//       ),
//     );
//   }
// }

// class CustomTab extends StatelessWidget {
//   final String label;
//   final bool divider;
//   const CustomTab({
//     required this.label,
//     this.divider = true,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Tab(
//       child: Row(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 12.sp),
//             child: Text(label),
//           ),
//           Visibility(
//             visible: divider,
//             child: const TabDivider(),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TabDivider extends StatelessWidget {
//   const TabDivider({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 24,
//       width: 1.sp,
//       color: ThemeColors.dividerDark,
//     );
//   }
// }

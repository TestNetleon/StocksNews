import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/moreStocks/index.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/custom_tab_item_label.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/home_top_gainer.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/home_top_loser.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/home_trending.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/error_display_widget.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/view_more_widget.dart';

class HomeInnerTabs extends StatefulWidget {
  const HomeInnerTabs({super.key});
//
  @override
  State<HomeInnerTabs> createState() => _HomeInnerTabsState();
}

class _HomeInnerTabsState extends State<HomeInnerTabs> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: ThemeColors.accent, width: 1.sp),
            ),
          ),
          child: Row(
            children: [
              CustomTabLabel(
                "Trending",
                coloredLetters: const ['T'],
                selected: _selectedIndex == 0,
                onTap: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              ),
              VerticalDivider(
                color: ThemeColors.accent,
                width: 1.sp,
                thickness: 1.sp,
              ),
              CustomTabLabel(
                "Top Gainers",
                coloredLetters: const ['G'],
                selected: _selectedIndex == 1,
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
              ),
              VerticalDivider(
                color: ThemeColors.accent,
                width: 1.sp,
                thickness: 1.sp,
              ),
              CustomTabLabel(
                "Top Losers",
                coloredLetters: const ['L'],
                selected: _selectedIndex == 2,
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
              ),
            ],
          ),
        ),
        provider.topLoading
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 40.sp),
                child: const CircularProgressIndicator(
                  color: ThemeColors.accent,
                ),
              )
            : provider.homeTrendingRes != null
                ? AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: _selectedIndex == 0
                        ? const HomeTrending()
                        : _selectedIndex == 1
                            ? const HomeTopGainer()
                            : const HomeTopLoser(),
                  )
                : Center(
                    child: ErrorDisplayNewWidget(
                      error: provider.error,
                      onRefresh: provider.getHomeTrendingData,
                    ),
                  ),
        const SpacerVertical(height: Dimen.itemSpacing),

        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: ThemeButtonSmall(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (_) => MoreStocks(
        //             type: _selectedIndex == 0
        //                 ? StocksType.trending
        //                 : _selectedIndex == 1
        //                     ? StocksType.gainers
        //                     : StocksType.losers,
        //           ),
        //         ),
        //       );
        //     },
        //     text: "View More",
        //   ),
        // ),

        ViewMoreWidget(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MoreStocks(
                  type: _selectedIndex == 0
                      ? StocksType.trending
                      : _selectedIndex == 1
                          ? StocksType.gainers
                          : StocksType.losers,
                ),
              ),
            );
          },
          text: _selectedIndex == 0
              ? "View More Trending"
              : _selectedIndex == 1
                  ? "View More Top Gainers"
                  : "View More Top Losers",
        ),
      ],
    );
  }
}

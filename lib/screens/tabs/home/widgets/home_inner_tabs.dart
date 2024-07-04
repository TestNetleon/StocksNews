import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/error_display_widget.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/view_more_widget.dart';
import 'package:vibration/vibration.dart';

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

    // return CommonTabContainer(
    //   onChange: (index) {},
    //   padding: const EdgeInsets.only(bottom: 10),
    //   physics: const NeverScrollableScrollPhysics(),
    //   scrollable: true,
    //   tabs: ["Trending", "Top Gainers", "Top Losers"],
    //   widgets: [
    //     const HomeTrending(),
    //     const HomeTopGainer(),
    //     const HomeTopLoser(),
    //   ],
    // );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpacerVertical(height: isPhone ? 0 : 5),
        Container(
          padding: const EdgeInsets.all(2),
          // margin: widget.padding,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 21, 21, 21),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomTabHome(
                label: "Trending",
                selected: _selectedIndex == 0,
                onTap: () async {
                  try {
                    if (Platform.isAndroid) {
                      bool isVibe = await Vibration.hasVibrator() ?? false;
                      if (isVibe) {
                        Vibration.vibrate(
                            pattern: [50, 50, 79, 55], intensities: [1, 10]);
                      }
                    } else {
                      HapticFeedback.lightImpact();
                    }
                  } catch (e) {}
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              ),
              CustomTabHome(
                label: "Top Gainers",
                selected: _selectedIndex == 1,
                onTap: () async {
                  try {
                    if (Platform.isAndroid) {
                      bool isVibe = await Vibration.hasVibrator() ?? false;
                      if (isVibe) {
                        Vibration.vibrate(
                            pattern: [50, 50, 79, 55], intensities: [1, 10]);
                      }
                    } else {
                      HapticFeedback.lightImpact();
                    }
                  } catch (e) {}
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
              ),
              CustomTabHome(
                label: "Top Losers",
                selected: _selectedIndex == 2,
                onTap: () async {
                  try {
                    if (Platform.isAndroid) {
                      bool isVibe = await Vibration.hasVibrator() ?? false;
                      if (isVibe) {
                        Vibration.vibrate(
                            pattern: [50, 50, 79, 55], intensities: [1, 10]);
                      }
                    } else {
                      HapticFeedback.lightImpact();
                    }
                  } catch (e) {}
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
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: false,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10.sp, 0, 0),
                                  child: Text(
                                    provider.homeTrendingRes?.text?.trending ??
                                        "",
                                    style: stylePTSansRegular(
                                        fontSize: 14,
                                        color: ThemeColors.greyText),
                                  ),
                                ),
                              ),
                              const HomeTrending(),
                            ],
                          )
                        : _selectedIndex == 1
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible: false,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10.sp, 0, 0),
                                      child: Text(
                                        provider.homeTrendingRes?.text
                                                ?.gainers ??
                                            "",
                                        style: stylePTSansRegular(
                                            fontSize: 14,
                                            color: ThemeColors.greyText),
                                      ),
                                    ),
                                  ),
                                  const HomeTopGainer(),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible: false,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10.sp, 0, 0),
                                      child: Text(
                                        provider.homeTrendingRes?.text
                                                ?.losers ??
                                            "",
                                        style: stylePTSansRegular(
                                            fontSize: 14,
                                            color: ThemeColors.greyText),
                                      ),
                                    ),
                                  ),
                                  const HomeTopLoser(),
                                ],
                              ),
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

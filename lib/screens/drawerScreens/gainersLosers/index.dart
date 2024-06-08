import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/drawerScreens/gainersLosers/today_breakout_stocks.dart';
import 'package:stocks_news_new/screens/drawerScreens/gainersLosers/today_top_gainer.dart';
import 'package:stocks_news_new/screens/drawerScreens/gainersLosers/today_top_losers.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

import '../../../utils/constants.dart';

class GainersLosersIndex extends StatefulWidget {
  static const path = "GainersLosersIndex";
  final StocksType type;

  const GainersLosersIndex({super.key, required this.type});

  @override
  State<GainersLosersIndex> createState() => _GainersLosersIndexState();
}

class _GainersLosersIndexState extends State<GainersLosersIndex> {
  @override
  Widget build(BuildContext context) {
    return const BaseContainer(
      appBar: AppBarHome(
        isPopback: true,
        canSearch: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimen.padding,
          Dimen.padding,
          Dimen.padding,
          0,
        ),
        child: CustomTabContainerNEW(
          scrollable: true,
          tabsPadding: EdgeInsets.zero,
          tabs: [
            "Today's Gainers",
            "Today's Losers",
            "Today's Breakout Stocks"
          ],
          // onChange: (index) => onChange(index),
          widgets: [
            TodaysTopGainer(),
            TodaysTopLoser(),
            TodaysBreakoutStocks(),
            // BaseUiContainer(
            //   error: provider.error,
            //   hasData: gainers != null && gainers.isNotEmpty,
            //   isLoading: provider.isLoading,
            //   errorDispCommon: true,
            //   onRefresh: () => provider.getGainersLosers(
            //       showProgress: true, type: widget.type.name),
            //   child: RefreshControl(
            //     onRefresh: () async => provider.getGainersLosers(
            //         showProgress: true, type: widget.type.name),
            //     canLoadMore: provider.canLoadMore,
            //     onLoadMore: () async => provider.getGainersLosers(
            //         loadMore: true, type: widget.type.name),
            //     child: ListView.separated(
            //       padding: EdgeInsets.only(
            //           bottom: Dimen.padding.sp, top: Dimen.padding.sp),
            //       itemBuilder: (context, index) {
            //         if (gainers == null || gainers.isEmpty) {
            //           return const SizedBox();
            //         }
            //         return Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             if (index == 0)
            //               HtmlTitle(
            //                   subTitle:
            //                       provider.extraUpGainers?.subTitle ?? ""),
            //             const SpacerVertical(),
            //             GainerLoserItem(
            //               data: gainers[index],
            //               index: index,
            //               marketData: true,
            //             ),
            //           ],
            //         );
            //       },
            //       separatorBuilder: (context, index) {
            //         return Divider(
            //           color: ThemeColors.greyBorder,
            //           height: 12.sp,
            //         );
            //       },
            //       itemCount: gainers?.length ?? 0,
            //     ),
            //   ),
            // ),
            // BaseUiContainer(
            //   error: provider.errorLosers,
            //   hasData: losers != null && losers.isNotEmpty,
            //   isLoading: provider.isLoadingLosers,
            //   errorDispCommon: true,
            //   onRefresh: () =>
            //       provider.getLosers(showProgress: true, type: "losers"),
            //   child: RefreshControl(
            //     onRefresh: () async =>
            //         provider.getLosers(showProgress: true, type: "losers"),
            //     canLoadMore: provider.canLoadMoreLosers,
            //     onLoadMore: () async =>
            //         provider.getLosers(loadMore: true, type: "losers"),
            //     child: ListView.separated(
            //       padding: EdgeInsets.only(
            //           bottom: Dimen.padding.sp, top: Dimen.padding.sp),
            //       itemBuilder: (context, index) {
            //         if (losers == null || losers.isEmpty) {
            //           return const SizedBox();
            //         }
            //         return Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             if (index == 0)
            //               HtmlTitle(
            //                   subTitle: provider.extraUpLosers?.subTitle ?? ""),
            //             GainerLoserItem(
            //               losers: true,
            //               data: losers[index],
            //               index: index,
            //               marketData: true,
            //             ),
            //           ],
            //         );
            //       },
            //       separatorBuilder: (context, index) {
            //         return Divider(
            //           color: ThemeColors.greyBorder,
            //           height: 12.sp,
            //         );
            //       },
            //       itemCount: losers?.length ?? 0,
            //     ),
            //   ),
            // ),
            // BaseUiContainer(
            //   error: provider.errorBreakoutStocks,
            //   hasData: breakoutStocks != null && breakoutStocks.isNotEmpty,
            //   isLoading: provider.isLoadingBreakOut,
            //   errorDispCommon: true,
            //   onRefresh: () => provider.getBreakoutStocks(showProgress: true),
            //   child: RefreshControl(
            //     onRefresh: () async =>
            //         provider.getBreakoutStocks(showProgress: true),
            //     canLoadMore: provider.canLoadMoreBreakOut,
            //     onLoadMore: () async =>
            //         provider.getBreakoutStocks(loadMore: true),
            //     child: ListView.separated(
            //       padding: EdgeInsets.only(
            //           bottom: Dimen.padding.sp, top: Dimen.padding.sp),
            //       itemBuilder: (context, index) {
            //         if (breakoutStocks == null || breakoutStocks.isEmpty) {
            //           return const SizedBox();
            //         }
            //         return Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             if (index == 0)
            //               HtmlTitle(
            //                   subTitle: provider.extraUpLosers?.subTitle ?? ""),
            //             BreakOutStocksItem(
            //               data: breakoutStocks[index],
            //               index: index,
            //             ),
            //           ],
            //         );
            //       },
            //       separatorBuilder: (context, index) {
            //         return Divider(
            //           color: ThemeColors.greyBorder,
            //           height: 12.sp,
            //         );
            //       },
            //       itemCount: breakoutStocks?.length ?? 0,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

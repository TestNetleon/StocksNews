import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/sector_industry_res.dart';
import 'package:stocks_news_new/providers/sector_industry_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/AlertWatchlist/alert_popup.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/sectorIndustry/sector_industry_item.dart';
import 'package:stocks_news_new/screens/tabs/trending/menuButton/slidable_menu.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import '../../../../widgets/spacer_vertical.dart';
import 'graph/graph.dart';

class SectorIndustryList extends StatelessWidget {
  final StockStates stockStates;
  final String name;
  const SectorIndustryList(
      {required this.stockStates, super.key, required this.name});
//
  @override
  Widget build(BuildContext context) {
    SectorIndustryProvider provider = context.watch<SectorIndustryProvider>();

    return SlidableAutoCloseBehavior(
      child: RefreshControl(
        onRefresh: () async => provider.getStateIndustry(
            name: name, stockStates: stockStates, showProgress: true),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () async => provider.getStateIndustry(
            name: name, stockStates: stockStates, loadMore: true),
        child: ListView.separated(
          padding: EdgeInsets.only(bottom: Dimen.padding.sp),
          itemCount: provider.data?.data.length ?? 0,
          itemBuilder: (context, index) {
            SectorIndustryData? data = provider.data?.data[index];
            if (index == 0 && stockStates == StockStates.sector) {
              return Column(
                children: [
                  const SectorGraph(),
                  SlidableMenuWidget(
                    index: index,
                    alertForBullish: data?.isAlertAdded?.toInt() ?? 0,
                    watlistForBullish: data?.isWatchlistAdded?.toInt() ?? 0,
                    onClickAlert: () => _onAlertClick(
                        context, data?.symbol ?? "", data?.isAlertAdded, index),
                    onClickWatchlist: () => _onWatchListClick(context,
                        data?.symbol ?? "", data?.isWatchlistAdded, index),
                    child: SectorIndustryItem(
                      index: index,
                      data: data,
                    ),
                  ),
                  // SectorIndustryItem(
                  //   index: index,
                  //   data: data,
                  // ),
                ],
              );
            }

            return SlidableMenuWidget(
              index: index,
              alertForBullish: data?.isAlertAdded?.toInt() ?? 0,
              watlistForBullish: data?.isWatchlistAdded?.toInt() ?? 0,
              onClickAlert: () => _onAlertClick(
                  context, data?.symbol ?? "", data?.isAlertAdded, index),
              onClickWatchlist: () => _onWatchListClick(
                  context, data?.symbol ?? "", data?.isWatchlistAdded, index),
              child: SectorIndustryItem(index: index, data: data),
            );

            // return SectorIndustryItem(index: index, data: data);
          },
          separatorBuilder: (context, index) {
            return const SpacerVertical(height: 12);
            // return Divider(
            //   color: ThemeColors.greyBorder,
            //   height: 12.sp,
            // );
          },
        ),
      ),
    );
  }

  void _onAlertClick(BuildContext context, String symbol, num? isAlertAdded,
      int? index) async {
    if ((isAlertAdded?.toInt() ?? 0) == 1) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const Alerts()),
      );
    } else {
      if (context.read<UserProvider>().user != null) {
        showPlatformBottomSheet(
          backgroundColor: const Color.fromARGB(255, 23, 23, 23),
          context: context,
          showClose: false,
          content: AlertPopup(
            insetPadding:
                EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
            symbol: symbol,
            index: index ?? 0,
            sectorAndIndustry: true,
          ),
        );

        return;
      }
      try {
        ApiResponse res = await context
            .read<SectorIndustryProvider>()
            .getStateIndustry(
                name: name, stockStates: stockStates, showProgress: true);
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<SectorIndustryProvider>()
                  .data
                  ?.data[index ?? 0]
                  .isAlertAdded ??
              0;
          if (alertOn == 0) {
            showPlatformBottomSheet(
              backgroundColor: const Color.fromARGB(255, 23, 23, 23),
              context: context,
              showClose: false,
              content: AlertPopup(
                insetPadding:
                    EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
                symbol: symbol,
                index: index ?? 0,
                sectorAndIndustry: true,
              ),
            );
          } else {
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => const Alerts()),
            );
          }
        }
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  void _onWatchListClick(BuildContext context, String symbol,
      num? isWatchlistAdded, int index) async {
    if (isWatchlistAdded == 1) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const WatchList()),
      );
    } else {
      if (context.read<UserProvider>().user != null) {
        await navigatorKey.currentContext!
            .read<SectorIndustryProvider>()
            .addToWishList(
              symbol: symbol,
              index: index,
              up: true,
            );
        return;
      }
      try {
        ApiResponse res = await navigatorKey.currentContext!
            .read<SectorIndustryProvider>()
            .getStateIndustry(
                name: name, stockStates: stockStates, showProgress: true);
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<SectorIndustryProvider>()
                  .data
                  ?.data[index]
                  .isWatchlistAdded ??
              0;
          if (alertOn == 0) {
            await navigatorKey.currentContext!
                .read<SectorIndustryProvider>()
                .addToWishList(
                  symbol: symbol,
                  index: index,
                  up: true,
                );
          } else {
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => const WatchList()),
            );
          }
        }
      } catch (e) {
        //
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/top_trending_res.dart';
import 'package:stocks_news_new/providers/featured_ticker.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/AlertWatchlist/alert_popup.dart';
import 'package:stocks_news_new/screens/tabs/trending/menuButton/slidable_menu.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/common_item_ui.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';

import '../../modals/home_alert_res.dart';

class AllFeaturedContainer extends StatelessWidget {
  const AllFeaturedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    FeaturedTickerProvider provider = context.watch<FeaturedTickerProvider>();

    return SlidableAutoCloseBehavior(
      child: RefreshControl(
        onRefresh: () async => provider.getFeaturedTicker(showProgress: false),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () async => provider.getFeaturedTicker(loadMore: true),
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: Dimen.itemSpacing),
          itemBuilder: (context, index) {
            HomeAlertsRes? data = provider.data?[index];
            if (data == null) {
              return const SizedBox();
            }
            int count = provider.data?.length ?? 0;

            Utils().showLog("Count = $count, index = $index");

            if (count == index + 1 && provider.extra?.disclaimer != null) {
              return Column(
                children: [
                  SlidableMenuWidget(
                    index: index,
                    alertForBullish: data.isAlertAdded?.toInt() ?? 0,
                    watlistForBullish: data.isWatchlistAdded?.toInt() ?? 0,
                    onClickAlert: () => _onAlertClick(
                        context, data.symbol, data.isAlertAdded, index),
                    onClickWatchlist: () => _onWatchListClick(
                        context, data.symbol, data.isWatchlistAdded, index),
                    child: CommonItemUi(
                      data: TopTrendingDataRes(
                          image: data.image,
                          symbol: data.symbol,
                          isAlertAdded: data.isAlertAdded ?? 0,
                          isWatchlistAdded: data.isWatchlistAdded ?? 0,
                          name: data.name,
                          change: data.change,
                          changePercentage: data.changesPercentage,
                          price: data.price),
                    ),
                  ),
                  // AllFeaturedItem(data: data),
                  DisclaimerWidget(data: provider.extra!.disclaimer!)
                ],
              );
            } else {
              return SlidableMenuWidget(
                index: index,
                alertForBullish: data.isAlertAdded?.toInt() ?? 0,
                watlistForBullish: data.isWatchlistAdded?.toInt() ?? 0,
                onClickAlert: () => _onAlertClick(
                    context, data.symbol, data.isAlertAdded, index),
                onClickWatchlist: () => _onWatchListClick(
                    context, data.symbol, data.isWatchlistAdded, index),
                child: CommonItemUi(
                  data: TopTrendingDataRes(
                      image: data.image,
                      symbol: data.symbol,
                      isAlertAdded: data.isAlertAdded ?? 0,
                      isWatchlistAdded: data.isWatchlistAdded ?? 0,
                      name: data.name,
                      change: data.change,
                      changePercentage: data.changesPercentage,
                      price: data.price),
                ),
              );
              // return AllFeaturedItem(data: data);
            }
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: 16,
              color: ThemeColors.greyBorder,
            );
          },
          itemCount: provider.data?.length ?? 0,
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
            insetPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            symbol: symbol,
            index: index ?? 0,
            homeFeatureStocks: true,
          ),
        );

        return;
      }
      try {
        ApiResponse res =
            await context.read<FeaturedTickerProvider>().getFeaturedTicker();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<FeaturedTickerProvider>()
                  .data?[index!]
                  .isAlertAdded ??
              0;
          if (alertOn == 0) {
            showPlatformBottomSheet(
              backgroundColor: const Color.fromARGB(255, 23, 23, 23),
              context: context,
              showClose: false,
              content: AlertPopup(
                insetPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                symbol: symbol,
                index: index ?? 0,
                homeFeatureStocks: true,
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
            .read<FeaturedTickerProvider>()
            .addToWishList(
              symbol: symbol,
              index: index,
              up: true,
            );
        return;
      }
      try {
        ApiResponse res = await navigatorKey.currentContext!
            .read<FeaturedTickerProvider>()
            .getFeaturedTicker();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<FeaturedTickerProvider>()
                  .data?[index]
                  .isWatchlistAdded ??
              0;
          if (alertOn == 0) {
            await navigatorKey.currentContext!
                .read<FeaturedTickerProvider>()
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

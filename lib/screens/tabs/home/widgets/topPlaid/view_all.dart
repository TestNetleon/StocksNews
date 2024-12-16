import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/most_purchased.dart';
import 'package:stocks_news_new/modals/top_trending_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/AlertWatchlist/alert_popup.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/trending/menuButton/slidable_menu.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/common_item_ui.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TopPlaidIndexView extends StatefulWidget {
  const TopPlaidIndexView({super.key});

  @override
  State<TopPlaidIndexView> createState() => _TopPlaidIndexViewState();
}

class _TopPlaidIndexViewState extends State<TopPlaidIndexView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().getMostPurchased();
    });
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();

    return BaseContainer(
      appBar: AppBarHome(
        isPopBack: true,
        title: provider.extraMostPopular?.title ?? "",
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimen.padding,
          // Dimen.padding,
          0,
          Dimen.padding,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ScreenTitle(
            //   title: provider.extraMostPopular?.title ?? "",
            // ),
            Expanded(
              child: BaseUiContainer(
                hasData: !provider.isLoadingMostPurchased &&
                    (provider.mostPurchasedView?.isNotEmpty == true &&
                        provider.mostPurchasedView != null),
                isLoading: provider.isLoadingMostPurchased,
                error: provider.errorMostPurchased,
                isFull: true,
                showPreparingText: true,
                onRefresh: () {
                  provider.getMostPurchased();
                },
                child: SlidableAutoCloseBehavior(
                  child: CommonRefreshIndicator(
                    onRefresh: () async {
                      provider.getMostPurchased();
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: Dimen.padding),
                      itemBuilder: (context, index) {
                        MostPurchasedRes? data =
                            provider.mostPurchasedView?[index];
                        if (data == null) {
                          return const SizedBox();
                        }
                        // return TopPlaidItemView(data: data);
                        return SlidableMenuWidget(
                          index: index,
                          alertForBullish: data.isAlertAdded?.toInt() ?? 0,
                          watlistForBullish:
                              data.isWatchlistAdded?.toInt() ?? 0,
                          onClickAlert: () => _onAlertClick(
                            context,
                            data.symbol ?? "",
                            data.name ?? "",
                            data.isAlertAdded,
                            index,
                          ),
                          onClickWatchlist: () => _onWatchListClick(
                            context,
                            data.symbol ?? "",
                            data.name ?? "",
                            data.isWatchlistAdded,
                            index,
                          ),
                          child: CommonItemUi(
                            data: TopTrendingDataRes(
                                image: data.image,
                                symbol: data.symbol ?? "",
                                isAlertAdded: data.isAlertAdded ?? 0,
                                isWatchlistAdded: data.isWatchlistAdded ?? 0,
                                name: data.name ?? "",
                                change: data.change,
                                changePercentage: data.changesPercentage,
                                price: data.price),
                          ),
                        );
                        // return CommonStockItem(
                        //   change: data.change,
                        //   changesPercentage: data.changesPercentage,
                        //   image: data.image,
                        //   name: data.name,
                        //   price: data.price,
                        //   symbol: data.symbol,
                        //   isAlertAdded: data.isAlertAdded,
                        //   isWatchlistAdded: data.isWatchlistAdded,
                        // );
                      },
                      separatorBuilder: (context, index) {
                        return const SpacerVertical(height: 12);
                      },
                      itemCount: provider.mostPurchasedView?.length ?? 0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onAlertClick(
    BuildContext context,
    String symbol,
    String companyName,
    num? isAlertAdded,
    int? index,
  ) async {
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
            companyName: companyName,
            index: index ?? 0,
            homeMostBoughtMembers: true,
          ),
        );

        return;
      }
      try {
        ApiResponse res =
            await context.read<HomeProvider>().getHomeTrendingData();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<HomeProvider>()
                  .mostPurchasedView?[index!]
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
                companyName: companyName,
                index: index ?? 0,
                homeMostBoughtMembers: true,
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

  void _onWatchListClick(
    BuildContext context,
    String symbol,
    String companyName,
    num? isWatchlistAdded,
    int index,
  ) async {
    if (isWatchlistAdded == 1) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const WatchList()),
      );
    } else {
      if (context.read<UserProvider>().user != null) {
        await navigatorKey.currentContext!.read<HomeProvider>().addToWishList(
              type: "homeMostBoughtMembers",
              symbol: symbol,
              companyName: companyName,
              index: index,
              up: true,
            );
        return;
      }
      try {
        ApiResponse res = await navigatorKey.currentContext!
            .read<HomeProvider>()
            .getHomeTrendingData();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<HomeProvider>()
                  .mostPurchasedView?[index]
                  .isWatchlistAdded ??
              0;
          if (alertOn == 0) {
            await navigatorKey.currentContext!
                .read<HomeProvider>()
                .addToWishList(
                  type: "homeMostBoughtMembers",
                  symbol: symbol,
                  companyName: companyName,
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

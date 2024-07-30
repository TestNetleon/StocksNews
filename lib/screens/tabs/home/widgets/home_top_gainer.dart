import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/modals/top_trending_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/AlertWatchlist/alert_popup.dart';
import 'package:stocks_news_new/screens/tabs/trending/menuButton/slidable_menu.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/common_item_ui.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom_readmore_text.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HomeTopGainer extends StatefulWidget {
  const HomeTopGainer({super.key});

  @override
  State<HomeTopGainer> createState() => _HomeTopGainerState();
}

class _HomeTopGainerState extends State<HomeTopGainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      HomeProvider provider = context.read<HomeProvider>();
      if (provider.homeTopGainerRes == null) {
        context.read<HomeProvider>().getHomeTopGainerData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();

    if (provider.homeTopGainerRes?.gainers?.isEmpty == true) {
      return const ErrorDisplayWidget(
        error: Const.errNoRecord,
        smallHeight: true,
      );
    }

    return BaseUiContainer(
      hasData: (provider.homeTopGainerRes != null &&
              provider.homeTopGainerRes?.gainers?.isNotEmpty == true) &&
          !provider.isLoadingGainers &&
          provider.statusGainers != Status.ideal,
      isLoading: provider.isLoadingGainers,
      showPreparingText: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpacerVertical(height: 10.sp),
          CustomReadMoreText(
            text: provider.homeTrendingRes?.text?.gainers ?? "",
          ),
          SlidableAutoCloseBehavior(
            child: ListView.separated(
              itemCount: provider.homeTopGainerRes?.gainers?.length ?? 0,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 12.sp),
              itemBuilder: (context, index) {
                Top top = provider.homeTopGainerRes!.gainers![index];
                // return StocksItem(top: top, gainer: true);
                return SlidableMenuWidget(
                  index: index,
                  alertForBullish: top.isAlertAdded?.toInt() ?? 0,
                  watlistForBullish: top.isWatchlistAdded?.toInt() ?? 0,
                  onClickAlert: () => _onAlertClick(
                      context, top.symbol, top.isAlertAdded, index),
                  onClickWatchlist: () => _onWatchListClick(
                      context, top.symbol, top.isWatchlistAdded, index),
                  child: CommonItemUi(
                    data: TopTrendingDataRes(
                        image: top.image,
                        symbol: top.symbol,
                        isAlertAdded: top.isAlertAdded ?? 0,
                        isWatchlistAdded: top.isWatchlistAdded ?? 0,
                        name: top.name,
                        change: top.displayChange,
                        changePercentage: top.changesPercentage,
                        price: top.price),
                  ),
                );
                // return CommonStockItem(
                //   change: top.displayChange,
                //   changesPercentage: top.changesPercentage,
                //   image: top.image,
                //   name: top.name,
                //   price: top.price,
                //   symbol: top.symbol,
                //   isAlertAdded: top.isAlertAdded,
                //   isWatchlistAdded: top.isWatchlistAdded,
                // );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SpacerVertical(height: 12);
              },
            ),
          ),
        ],
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
            homeTopGainers: true,
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
                  .homeTopGainerRes!
                  .gainers![index ?? 0]
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
                homeTopGainers: true,
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
        await navigatorKey.currentContext!.read<HomeProvider>().addToWishList(
              type: "homeTopGainers",
              symbol: symbol,
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
                  .homeTopGainerRes
                  ?.gainers?[index]
                  .isWatchlistAdded ??
              0;
          if (alertOn == 0) {
            await navigatorKey.currentContext!
                .read<HomeProvider>()
                .addToWishList(
                  type: "homeTopGainers",
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
      } catch (e) {}
    }
  }
}

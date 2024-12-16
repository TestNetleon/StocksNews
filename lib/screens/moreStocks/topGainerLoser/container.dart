// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/gainers_losers_res.dart';
import 'package:stocks_news_new/providers/more_stocks_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/AlertWatchlist/alert_popup.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/trending/menuButton/slidable_menu.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../utils/colors.dart';
import 'item.dart';

//
class GainerLoserContainer extends StatefulWidget {
  final StocksType type;

  const GainerLoserContainer({super.key, required this.type});

  @override
  State<GainerLoserContainer> createState() => _GainerLoserContainerState();
}

class _GainerLoserContainerState extends State<GainerLoserContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      navigatorKey.currentContext!
          .read<MoreStocksProvider>()
          .getGainersLosers(showProgress: true, type: widget.type.name);

      String title = widget.type == StocksType.gainers
          ? "Today’s Top Gainers"
          : widget.type == StocksType.losers
              ? "Today’s Top Losers"
              : "Popular Stocks";

      FirebaseAnalytics.instance.logEvent(
        name: 'ScreensVisit',
        parameters: {'screen_name': title},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    MoreStocksProvider provider = context.watch<MoreStocksProvider>();
    List<GainersLosersDataRes>? data = provider.gainersLosers?.data;

    log(" SUBTITL =>  ${provider.extraUpGainers?.subTitle}");

    return BaseContainer(
      drawer: const BaseDrawer(
        resetIndex: true,
      ),
      appBar: AppBarHome(
        isPopBack: true,
        title: widget.type == StocksType.gainers
            ? "Today’s Top Gainers"
            : widget.type == StocksType.losers
                ? "Today’s Top Losers"
                : data?.length == 1
                    ? "Popular Stock"
                    : provider.extraUpGainers?.title ?? "Popular Stocks",
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(Dimen.padding, 0, Dimen.padding, 0),
        child: Column(
          children: [
            if (widget.type != StocksType.gainers &&
                widget.type != StocksType.losers &&
                provider.extraUpGainers?.subTitle != null &&
                provider.extraUpGainers?.subTitle != "")
              ScreenTitle(
                // title: widget.type == StocksType.gainers
                //     ? "Today’s Top Gainers"
                //     : widget.type == StocksType.losers
                //         ? "Today’s Top Losers"
                //         : data?.length == 1
                //             ? "Popular Stock"
                //             : provider.extraUpGainers?.title ??
                //                 "Popular Stocks",
                subTitle: widget.type == StocksType.gainers ||
                        widget.type == StocksType.losers
                    ? ""
                    : provider.extraUpGainers?.subTitle,
                subTitleHtml: true,
                dividerPadding: (widget.type == StocksType.gainers ||
                        widget.type == StocksType.losers)
                    ? const EdgeInsets.only(top: 12)
                    : null,
              ),
            Expanded(
              child: BaseUiContainer(
                error: provider.error,
                hasData: data != null && data.isNotEmpty,
                isLoading: provider.isLoading,
                errorDispCommon: true,
                onRefresh: () => provider.getGainersLosers(
                    showProgress: true, type: widget.type.name),
                child: SlidableAutoCloseBehavior(
                  child: RefreshControl(
                    onRefresh: () async => provider.getGainersLosers(
                        showProgress: true, type: widget.type.name),
                    canLoadMore: provider.canLoadMore,
                    onLoadMore: () async => provider.getGainersLosers(
                        loadMore: true, type: widget.type.name),
                    child: ListView.separated(
                      padding: EdgeInsets.only(bottom: Dimen.padding),
                      itemBuilder: (context, index) {
                        if (data == null || data.isEmpty) {
                          return const SizedBox();
                        }
                        return SlidableMenuWidget(
                          index: index,
                          alertForBullish:
                              data[index].isAlertAdded?.toInt() ?? 0,
                          watlistForBullish:
                              data[index].isWatchlistAdded?.toInt() ?? 0,
                          onClickAlert: () => _onAlertClick(
                              navigatorKey.currentContext!,
                              data[index].symbol,
                              data[index].name,
                              data[index].isAlertAdded,
                              index),
                          onClickWatchlist: () => _onWatchListClick(
                              navigatorKey.currentContext!,
                              data[index].symbol,
                              data[index].name,
                              data[index].isWatchlistAdded,
                              index),
                          child: GainerLoserItem(
                            data: data[index],
                            index: index,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SpacerVertical(height: 12);
                      },
                      itemCount: data?.length ?? 0,
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
    context,
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
      if (navigatorKey.currentContext!.read<UserProvider>().user != null) {
        showPlatformBottomSheet(
          backgroundColor: const Color.fromARGB(255, 23, 23, 23),
          context: navigatorKey.currentContext!,
          showClose: false,
          content: AlertPopup(
            insetPadding:
                EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
            symbol: symbol,
            companyName: companyName,
            index: index ?? 0,
            homeGainersAndLosers: widget.type,
          ),
        );

        return;
      }
      try {
        ApiResponse res = await navigatorKey.currentContext!
            .read<MoreStocksProvider>()
            .getGainersLosers(showProgress: true, type: widget.type.name);
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<MoreStocksProvider>()
                  .gainersLosers
                  ?.data?[index ?? 0]
                  .isAlertAdded ??
              0;
          if (alertOn == 0) {
            showPlatformBottomSheet(
              backgroundColor: const Color.fromARGB(255, 23, 23, 23),
              context: navigatorKey.currentContext!,
              showClose: false,
              content: AlertPopup(
                insetPadding:
                    EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
                symbol: symbol,
                companyName: companyName,
                index: index ?? 0,
                homeGainersAndLosers: widget.type,
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
        await navigatorKey.currentContext!
            .read<MoreStocksProvider>()
            .addToWishList(
              type: widget.type.name,
              symbol: symbol,
              companyName: companyName,
              index: index,
              up: true,
            );
        return;
      }
      try {
        ApiResponse res = await context
            .read<MoreStocksProvider>()
            .getGainersLosers(showProgress: true, type: widget.type.name);
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<MoreStocksProvider>()
                  .gainersLosers
                  ?.data?[index]
                  .isWatchlistAdded ??
              0;
          if (alertOn == 0) {
            await navigatorKey.currentContext!
                .read<MoreStocksProvider>()
                .addToWishList(
                  type: widget.type.name,
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

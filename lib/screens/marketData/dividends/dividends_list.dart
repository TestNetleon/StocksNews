import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/dividends_res.dart';
import 'package:stocks_news_new/providers/dividends_provider.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/marketData/dividends/dividends_item.dart';
import 'package:stocks_news_new/screens/marketData/lock/common_lock.dart';
import 'package:stocks_news_new/screens/marketData/widget/marketDataBottomSheet/md_bottom_sheet.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_title.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/AlertWatchlist/alert_popup.dart';
import 'package:stocks_news_new/screens/tabs/trending/menuButton/slidable_menu.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class DividendsList extends StatefulWidget {
  const DividendsList({super.key});

  @override
  State<DividendsList> createState() => _DividendsListState();
}

class _DividendsListState extends State<DividendsList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      DividendsProvider provider = context.read<DividendsProvider>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getDividendsStocks();
    });
  }

  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    DividendsProvider gapUpProvider = context.read<DividendsProvider>();

    if (provider.data == null) {
      await context.read<FilterProvider>().getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Dividend Announcements",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: gapUpProvider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<DividendsProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    DividendsProvider provider = context.watch<DividendsProvider>();
    List<DividendsRes>? data = provider.data;

    UserProvider userProvider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();

    bool purchased = userProvider.user?.membership?.purchased == 1;

    bool isLocked = homeProvider.extra?.membership?.permissions?.any(
            (element) => (element.key == "dividends" && element.status == 0)) ??
        false;

    if (purchased && isLocked) {
      bool havePermissions = userProvider.user?.membership?.permissions?.any(
              (element) =>
                  (element.key == "dividends" && element.status == 1)) ??
          false;

      isLocked = !havePermissions;
    }
    Utils().showLog("isLocked? $isLocked, Purchased? $purchased");

    // bool isLocked = false;

    // if (purchased) {
    //   bool havePermissions = userProvider.user?.membership?.permissions?.any(
    //           (element) =>
    //               element == "gap-up-stocks" || element == "gap-down-stocks") ??
    //       false;
    //   isLocked = !havePermissions;
    // } else {
    //   if (!isLocked) {
    //     isLocked = homeProvider.extra?.membership?.permissions?.any((element) =>
    //             element == "gap-up-stocks" || element == "gap-down-stocks") ??
    //         false;
    //   }
    // }

    // Utils().showLog("GAP UP DOWN OPEN? $isLocked");

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: Dimen.padding, right: Dimen.padding, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (provider.data != null || provider.filterParams != null)
                MarketDataTitle(
                  htmlTitle: true,
                  title: provider.extra?.title,
                  subTitleHtml: true,
                  subTitle: provider.extra?.subTitle,
                  provider: provider,
                ),
              Expanded(
                child: BaseUiContainer(
                  error: provider.error,
                  hasData: data != null && data.isNotEmpty,
                  isLoading: provider.isLoading,
                  errorDispCommon: true,
                  showPreparingText: true,
                  onRefresh: () => provider.getDividendsStocks(),
                  child: SlidableAutoCloseBehavior(
                    child: RefreshControl(
                      onRefresh: () async => provider.getDividendsStocks(),
                      canLoadMore: provider.canLoadMore,
                      onLoadMore: () async =>
                          provider.getDividendsStocks(loadMore: true),
                      child: ListView.separated(
                        padding: const EdgeInsets.only(top: Dimen.padding),
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
                                context,
                                data[index].symbol,
                                data[index].isAlertAdded,
                                index),
                            onClickWatchlist: () => _onWatchListClick(
                                context,
                                data[index].symbol,
                                data[index].isWatchlistAdded,
                                index),
                            child:
                                DividendsItem(data: data[index], index: index),
                          );
                          // return DividendsItem(data: data[index], index: index);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SpacerVertical(height: 12);
                        },
                        // itemCount: up?.length ?? 0,
                        itemCount: data?.length ?? 0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: MdBottomSheet(
            isFilter: provider.isFilterApplied(),
            isSort: provider.isSortingApplied(),
            onTapFilter: _onFilterClick,
            onTapSorting: () => onSortingClick(
              selected: context.read<DividendsProvider>().filterParams?.sorting,
              onTap: (sortingKey) {
                Navigator.pop(navigatorKey.currentContext!);
                context.read<DividendsProvider>().applySorting(sortingKey);
              },
              onResetClick: () {
                Navigator.pop(navigatorKey.currentContext!);
                context.read<DividendsProvider>().applySorting("");
              },
            ),
          ),
        ),
        if (isLocked)
          CommonLock(
            showLogin: true,
            isLocked: isLocked,
          ),
      ],
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
            marketDataDividends: true,
          ),
        );

        return;
      }
      try {
        ApiResponse res =
            await context.read<DividendsProvider>().getDividendsStocks();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<DividendsProvider>()
                  .data?[index ?? 0]
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
                marketDataDividends: true,
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
            .read<DividendsProvider>()
            .addToWishList(
              symbol: symbol,
              index: index,
              up: true,
            );
        return;
      }
      try {
        ApiResponse res = await navigatorKey.currentContext!
            .read<DividendsProvider>()
            .getDividendsStocks();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<DividendsProvider>()
                  .data?[index]
                  .isWatchlistAdded ??
              0;
          if (alertOn == 0) {
            await navigatorKey.currentContext!
                .read<DividendsProvider>()
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
      } catch (e) {}
    }
  }
}

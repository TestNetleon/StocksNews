import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/breakout_stocks_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/today_breackout_stocks_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/marketData/gainersLosers/break_out_item.dart';
import 'package:stocks_news_new/screens/marketData/widget/marketDataBottomSheet/md_bottom_sheet.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/AlertWatchlist/alert_popup.dart';
import 'package:stocks_news_new/screens/tabs/trending/menuButton/slidable_menu.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/market_data_header.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class TodaysBreakoutStocks extends StatefulWidget {
  const TodaysBreakoutStocks({super.key});

  @override
  State<TodaysBreakoutStocks> createState() => _TodaysBreakoutStocksState();
}

class _TodaysBreakoutStocksState extends State<TodaysBreakoutStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TodayBreakoutStockProvider provider =
          context.read<TodayBreakoutStockProvider>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getData(showProgress: true);
    });
  }

  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    FilteredParams? filterParams =
        context.read<TodayBreakoutStockProvider>().filterParams;

    if (provider.data == null) {
      await provider.getFilterData();
    }

    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Today's Top Breakout Stocks",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: filterParams,
        showTimePeriod: true,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<TodayBreakoutStockProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    TodayBreakoutStockProvider provider =
        context.watch<TodayBreakoutStockProvider>();
    List<BreakoutStocksRes>? gainers = provider.data;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: Dimen.padding, right: Dimen.padding, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MarketDataHeader(
                provider: provider,
                onFilterClick: _onFilterClick,
                // onDeleteExchange: (exchange) => provider.exchangeFilter(exchange),
              ),
              // HtmlTitle(
              //   subTitle: provider.extra?.subTitle ?? "",
              //   onFilterClick: _onFilterClick,
              //   hasFilter: provider.filterParams != null,
              // ),
              // if (provider.filterParams != null)
              //   FilterUiValues(
              //     params: provider.filterParams,
              //     onDeleteExchange: (exchange) {
              //       provider.exchangeFilter(exchange);
              //     },
              //   ),
              Expanded(
                child: BaseUiContainer(
                  error: provider.error,
                  hasData: gainers != null && gainers.isNotEmpty,
                  isLoading: provider.isLoading,
                  errorDispCommon: true,
                  showPreparingText: true,
                  onRefresh: () => provider.getData(showProgress: true),
                  child: SlidableAutoCloseBehavior(
                    child: RefreshControl(
                      onRefresh: () async =>
                          provider.getData(showProgress: true),
                      canLoadMore: provider.canLoadMore,
                      onLoadMore: () async => provider.getData(loadMore: true),
                      child: ListView.separated(
                        padding: const EdgeInsets.only(
                          bottom: Dimen.padding,
                          top: 0,
                        ),
                        itemBuilder: (context, index) {
                          if (gainers == null || gainers.isEmpty) {
                            return const SizedBox();
                          }
                          return SlidableMenuWidget(
                            index: index,
                            alertForBullish:
                                gainers[index].isAlertAdded?.toInt() ?? 0,
                            watlistForBullish:
                                gainers[index].isWatchlistAdded?.toInt() ?? 0,
                            onClickAlert: () => _onAlertClick(
                                context,
                                gainers[index].symbol,
                                gainers[index].name,
                                gainers[index].isAlertAdded,
                                index),
                            onClickWatchlist: () => _onWatchListClick(
                                context,
                                gainers[index].symbol,
                                gainers[index].name,
                                gainers[index].isWatchlistAdded,
                                index),
                            child: BreakOutStocksItem(
                              data: gainers[index],
                              index: index,
                            ),
                          );
                          // return BreakOutStocksItem(
                          //   data: gainers![index],
                          //   index: index,
                          //   // marketData: true,
                          // );
                        },
                        separatorBuilder: (context, index) {
                          return const SpacerVertical(height: 12);
                          // return Divider(
                          //   color: ThemeColors.greyBorder,
                          //   height: 12.sp,
                          // );
                        },
                        itemCount: gainers?.length ?? 0,
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
              breakOutType: true,
              selected: provider.filterParams?.sorting,
              onTap: (sortingKey) {
                Navigator.pop(navigatorKey.currentContext!);
                context
                    .read<TodayBreakoutStockProvider>()
                    .applySorting(sortingKey);
              },
              onResetClick: () {
                Navigator.pop(navigatorKey.currentContext!);
                context.read<TodayBreakoutStockProvider>().applySorting("");
              },
            ),
          ),
        ),
      ],
    );
  }

  void _onAlertClick(
    BuildContext context,
    String symbol,
    String cN,
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
            companyName: cN,
            index: index ?? 0,
            marketDataTodaysBreakOut: true,
          ),
        );

        return;
      }
      try {
        ApiResponse res =
            await context.read<TodayBreakoutStockProvider>().getData();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<TodayBreakoutStockProvider>()
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
                companyName: cN,
                index: index ?? 0,
                marketDataTodaysBreakOut: true,
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
            .read<TodayBreakoutStockProvider>()
            .addToWishList(
              type: "homeTopGainers",
              symbol: symbol,
              companyName: companyName,
              index: index,
              up: true,
            );
        return;
      }
      try {
        ApiResponse res = await navigatorKey.currentContext!
            .read<TodayBreakoutStockProvider>()
            .getData();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<TodayBreakoutStockProvider>()
                  .data?[index]
                  .isWatchlistAdded ??
              0;
          if (alertOn == 0) {
            await navigatorKey.currentContext!
                .read<TodayBreakoutStockProvider>()
                .addToWishList(
                  type: "homeTopGainers",
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

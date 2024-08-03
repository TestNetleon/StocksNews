import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/low_price_stocks_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/low_prices_stocks.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/marketData/lowPriceStocks/item_sale_on_stocks.dart';
import 'package:stocks_news_new/screens/marketData/widget/marketDataBottomSheet/md_bottom_sheet.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/AlertWatchlist/alert_popup.dart';
import 'package:stocks_news_new/screens/tabs/trending/menuButton/slidable_menu.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/market_data_header.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import 'item.dart';

class LowPriceStocksList extends StatefulWidget {
  final int index;
  const LowPriceStocksList({required this.index, super.key});

  @override
  State<LowPriceStocksList> createState() => _LowPriceStocksListState();
}

class _LowPriceStocksListState extends State<LowPriceStocksList> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     LowPriceStocksProvider provider = context.read<LowPriceStocksProvider>();
  //     if (provider.data != null) {
  //       return;
  //     }
  //     provider.resetFilter();
  //     // provider.getLowPriceData();
  //     provider.tabChange(widget.index);
  //   });
  // }

  void _onFilterClick() async {
    FilterProvider filterProvider = context.read<FilterProvider>();
    LowPriceStocksProvider provider = context.read<LowPriceStocksProvider>();

    if (filterProvider.data == null) {
      await context.read<FilterProvider>().getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter ${provider.tabs?[provider.selectedIndex].key}",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: provider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<LowPriceStocksProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    LowPriceStocksProvider provider = context.watch<LowPriceStocksProvider>();
    // List<LowPriceStocksTabRes>? tabs = provider.tabs;

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
              ),
              Expanded(
                child: BaseUiContainer(
                  error: provider.error,
                  hasData: !provider.isLoading && provider.data != null,
                  isLoading: provider.isLoading,
                  showPreparingText: true,
                  onRefresh: () {
                    provider.getLowPriceData();
                  },
                  child: SlidableAutoCloseBehavior(
                    child: RefreshControl(
                      onRefresh: () async => provider.getLowPriceData(),
                      canLoadMore: provider.canLoadMore,
                      onLoadMore: () async =>
                          provider.getLowPriceData(loadMore: true),
                      child: ListView.separated(
                        padding: EdgeInsets.only(bottom: 10.sp),
                        itemBuilder: (context, index) {
                          LowPriceStocksRes? data = provider.data?[index];
                          if (data == null) {
                            return const SizedBox();
                          }
                          return SlidableMenuWidget(
                            index: index,
                            alertForBullish: data.isAlertAdded?.toInt() ?? 0,
                            watlistForBullish:
                                data.isWatchlistAdded?.toInt() ?? 0,
                            onClickAlert: () => _onAlertClick(context,
                                data.symbol ?? "", data.isAlertAdded, index),
                            onClickWatchlist: () => _onWatchListClick(
                                context,
                                data.symbol ?? "",
                                data.isWatchlistAdded,
                                index),
                            child: provider.typeIndex == 1
                                ? SaleOnStocksItem(data: data)
                                : LowPriceStocksItem(data: data),
                          );
                          // return provider.typeIndex == 1
                          //     ? SaleOnStocksItem(data: data)
                          //     : LowPriceStocksItem(data: data);
                        },
                        separatorBuilder: (context, index) {
                          return const SpacerVertical(height: 12);
                        },
                        itemCount: provider.data?.length ?? 0,
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
                selected: context
                    .read<LowPriceStocksProvider>()
                    .filterParams
                    ?.sorting,
                onTap: (sortingKey) {
                  Navigator.pop(navigatorKey.currentContext!);
                  context
                      .read<LowPriceStocksProvider>()
                      .applySorting(sortingKey);
                },
                onResetClick: () {
                  Navigator.pop(navigatorKey.currentContext!);
                  context.read<LowPriceStocksProvider>().applySorting("");
                },
              ),
            ))
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
            marketDataLowPriceStocks: true,
          ),
        );

        return;
      }
      try {
        ApiResponse res =
            await context.read<LowPriceStocksProvider>().getLowPriceData();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<LowPriceStocksProvider>()
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
                marketDataLowPriceStocks: true,
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
            .read<LowPriceStocksProvider>()
            .addToWishList(
              symbol: symbol,
              index: index,
              up: true,
            );
        return;
      }
      try {
        ApiResponse res = await navigatorKey.currentContext!
            .read<LowPriceStocksProvider>()
            .getLowPriceData();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<LowPriceStocksProvider>()
                  .data?[index]
                  .isWatchlistAdded ??
              0;
          if (alertOn == 0) {
            await navigatorKey.currentContext!
                .read<LowPriceStocksProvider>()
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/low_pe_growth_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/marketData/highLowPE/item.dart';
import 'package:stocks_news_new/screens/marketData/widget/marketDataBottomSheet/md_bottom_sheet.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/AlertWatchlist/alert_popup.dart';
import 'package:stocks_news_new/screens/tabs/trending/menuButton/slidable_menu.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/market_data_header.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../modals/highlow_pe_res.dart';
import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class LowPEGrowthStocks extends StatefulWidget {
  const LowPEGrowthStocks({super.key});

  @override
  State<LowPEGrowthStocks> createState() => _LowPEGrowthStocksState();
}

class _LowPEGrowthStocksState extends State<LowPEGrowthStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      LowPeGrowthProvider provider = context.read<LowPeGrowthProvider>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getData(showProgress: true);
      //-------
    });
  }

  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    FilteredParams? filterParams =
        context.read<LowPeGrowthProvider>().filterParams;

    if (provider.data == null) {
      await provider.getFilterData();
    }

    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Low PE Growth Stocks",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<LowPeGrowthProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    LowPeGrowthProvider provider = context.watch<LowPeGrowthProvider>();

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
                  hasData: !provider.isLoading &&
                      provider.data != null &&
                      provider.data?.isNotEmpty == true,
                  isLoading: provider.isLoading,
                  errorDispCommon: true,
                  showPreparingText: true,
                  onRefresh: () => provider.getData(showProgress: true),
                  child: SlidableAutoCloseBehavior(
                    child: RefreshControl(
                      onRefresh: () async =>
                          provider.getData(showProgress: true),
                      canLoadMore: provider.canLoadMore,
                      onLoadMore: () async =>
                          provider.getData(showProgress: false, loadMore: true),
                      child: ListView.separated(
                        padding: const EdgeInsets.only(
                          bottom: Dimen.padding,
                          top: 0,
                        ),
                        itemBuilder: (context, index) {
                          List<HIghLowPeRes>? data = provider.data;
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
                                data[index].symbol ?? "",
                                data[index].isAlertAdded,
                                index),
                            onClickWatchlist: () => _onWatchListClick(
                                context,
                                data[index].symbol ?? "",
                                data[index].isWatchlistAdded,
                                index),
                            child:
                                HighLowPEItem(index: index, data: data[index]),
                          );
                          // return HighLowPEItem(index: index, data: low);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SpacerVertical(height: 12);
                        },
                        // itemCount: up?.length ?? 0,
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
                selected:
                    context.read<LowPeGrowthProvider>().filterParams?.sorting,
                onTap: (sortingKey) {
                  Navigator.pop(navigatorKey.currentContext!);
                  context.read<LowPeGrowthProvider>().applySorting(sortingKey);
                },
                onResetClick: () {
                  Navigator.pop(navigatorKey.currentContext!);
                  context.read<LowPeGrowthProvider>().applySorting("");
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
            marketDataLowPeGrowth: true,
          ),
        );

        return;
      }
      try {
        ApiResponse res = await context.read<LowPeGrowthProvider>().getData();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<LowPeGrowthProvider>()
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
                marketDataLowPeGrowth: true,
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
            .read<LowPeGrowthProvider>()
            .addToWishList(
              symbol: symbol,
              index: index,
              up: true,
            );
        return;
      }
      try {
        ApiResponse res = await navigatorKey.currentContext!
            .read<LowPeGrowthProvider>()
            .getData();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<LowPeGrowthProvider>()
                  .data?[index]
                  .isWatchlistAdded ??
              0;
          if (alertOn == 0) {
            await navigatorKey.currentContext!
                .read<LowPeGrowthProvider>()
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

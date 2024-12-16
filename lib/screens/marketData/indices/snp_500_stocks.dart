import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/dow_thirty_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/snp_500_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
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

class Snp500Stocks extends StatefulWidget {
  const Snp500Stocks({super.key});

  @override
  State<Snp500Stocks> createState() => _Snp500StocksState();
}

class _Snp500StocksState extends State<Snp500Stocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // AmplitudeService.logUserInteractionEvent(type: "S&P Stocks");

      SnP500Provider provider = context.read<SnP500Provider>();
      // if (provider.data != null) {
      //   return;
      // }
      provider.resetFilter();
      provider.getData();
    });
  }

  void _onFilterClick() async {
    FilterProvider filterProvider = context.read<FilterProvider>();
    SnP500Provider provider = context.read<SnP500Provider>();
    if (filterProvider.data == null) {
      await filterProvider.getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter S&P 500 Stocks",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: provider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<SnP500Provider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    SnP500Provider provider = context.watch<SnP500Provider>();
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimen.padding,
          ),
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
                  errorDispCommon: true,
                  onRefresh: () async => await provider.onRefresh(),
                  child: SlidableAutoCloseBehavior(
                    child: RefreshControl(
                      onRefresh: () async => await provider.onRefresh(),
                      canLoadMore: provider.canLoadMore,
                      onLoadMore: () async =>
                          await provider.getData(loadMore: true),
                      child: ListView.separated(
                        padding: const EdgeInsets.only(bottom: 10),
                        itemBuilder: (context, index) {
                          Result? data = provider.data?[index];
                          if (data == null) {
                            return const SizedBox();
                          }

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
                                index),
                            child: IndicesItem(data: data, index: index),
                          );
                          // return IndicesItem(data: data, index: index);
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
                selected: context.read<SnP500Provider>().filterParams?.sorting,
                onTap: (sortingKey) {
                  Navigator.pop(navigatorKey.currentContext!);
                  context.read<SnP500Provider>().applySorting(sortingKey);
                },
                onResetClick: () {
                  Navigator.pop(navigatorKey.currentContext!);
                  context.read<SnP500Provider>().applySorting("");
                },
              ),
            ))
      ],
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
            marketDataSP500: true,
          ),
        );

        return;
      }
      try {
        ApiResponse res = await context.read<SnP500Provider>().getData();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<SnP500Provider>()
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
                companyName: companyName,
                index: index ?? 0,
                marketDataSP500: true,
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
        await navigatorKey.currentContext!.read<SnP500Provider>().addToWishList(
              symbol: symbol,
              companyName: companyName,
              index: index,
              up: true,
            );
        return;
      }
      try {
        ApiResponse res =
            await navigatorKey.currentContext!.read<SnP500Provider>().getData();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<SnP500Provider>()
                  .data?[index]
                  .isWatchlistAdded ??
              0;
          if (alertOn == 0) {
            await navigatorKey.currentContext!
                .read<SnP500Provider>()
                .addToWishList(
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
